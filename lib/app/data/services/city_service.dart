import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/city_model.dart';

class CityService extends GetConnect {
  final _box = GetStorage();
  static const _key = 'ciudades';

  // Pequeño rate limit local (>= 1 segundo entre requests)
  DateTime _lastCall = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void onInit() {
    // Configuración base para todas las peticiones
    httpClient.baseUrl = 'https://nominatim.openstreetmap.org';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 10);

    // User-Agent y headers requeridos por Nominatim
    httpClient.addRequestModifier<void>((request) {
      request.headers['User-Agent'] = 'com.unison.weatherapp/1.0 (debug)';
      request.headers['Referer'] = 'https://unison.mx';
      request.headers['Accept'] = 'application/json';

      print('➡️ Request: ${request.url}');
      return request;
    });

    super.onInit();
  }

  // ----------------------------
  // 🌍 Consultas a API Nominatim
  // ----------------------------

  Future<List<Map<String, dynamic>>> searchCity(String query) async {
    final now = DateTime.now();
    if (now.difference(_lastCall) < const Duration(seconds: 1)) {
      // espera mínima para no spamear
      await Future.delayed(const Duration(milliseconds: 300));
    }
    _lastCall = DateTime.now();

    if (query.trim().isEmpty) return [];

    final response = await get(
      '/search',
      query: {
        'q': query,
        'format': 'json',
        'limit': '5',
        // Opcional: mejora resultados para tu usuario
        'accept-language': 'es',
        // 'email': 'tu-email@dominio.com', // también lo aceptan como contacto
      },
    );

    if (!response.isOk) {
      // Si te vuelven a bloquear, Nominatim contesta HTML con 403
      print('❌ Error Nominatim: ${response.statusCode}');
      print('❌ Body: ${response.bodyString}');
      Get.snackbar(
        'Error',
        'Nominatim bloqueó la solicitud (${response.statusCode}).',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
    }

    if (response.body is! List) return [];

    final List data = response.body;

    // Filtra a tipos de lugar útiles (evita "county"/"administrative")
    final filtered = data.where((item) {
      final type = item['type'] ?? '';
      return type == 'city' || type == 'town' || type == 'village';
    }).toList();

    return List<Map<String, dynamic>>.from(
      filtered.map(
        (item) => {
          'name': item['name'] ?? '',
          'display_name': item['display_name'] ?? '',
          'lat': item['lat'] ?? '0',
          'lon': item['lon'] ?? '0',
        },
      ),
    );
  }

  // (Opcional) Si planeas más APIs (por ejemplo clima):
  Future<Response> getWeather(double lat, double lon) async {
    // Aquí podrías cambiar la baseUrl antes o usar otro endpoint
    // Ejemplo placeholder:
    final url =
        'https://api.meteomatics.com/2025-11-03T00:00:00Z/t_2m:C/$lat,$lon/json';
    final response = await get(url);
    return response;
  }

  // ----------------------------
  // 💾 Almacenamiento local
  // ----------------------------

  List<CityModel> getCities() {
    final raw = _box.read<List>(_key) ?? [];
    return raw
        .map((e) => CityModel.fromJson(json.decode(e)))
        .toList()
        .cast<CityModel>();
  }

  void addCity(CityModel city) {
    final raw = _box.read<List>(_key) ?? [];
    final newKey = _makeKey(city.name, city.lat, city.lon);

    // 1) Duplicado por key (nuevo esquema)
    final byKey = raw.any((e) {
      final decoded = json.decode(e);
      return decoded['key'] == newKey;
    });

    // 2) Fallback: duplicado por nombre (esquema viejo sin 'key')
    final byNameOnly = raw.any((e) {
      final decoded = json.decode(e);
      return decoded['key'] == null &&
          (decoded['nombre']?.toString().toLowerCase().trim() ?? '') ==
              city.name.toLowerCase().trim();
    });

    if (byKey || byNameOnly) {
      Get.snackbar(
        'Aviso',
        'La ciudad ya está guardada',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final toStore = city.toJson(); // { nombre, latitud, longitud }
    toStore['key'] = newKey; // ⭐️ agrega clave compuesta

    raw.add(json.encode(toStore));
    _box.write(_key, raw);

    Get.snackbar(
      'Éxito',
      'Ciudad agregada: ${city.name}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ⭐️ Reemplazo recomendado
  void removeCityByKey(String name, double lat, double lon) {
    final raw = _box.read<List>(_key) ?? [];
    final targetKey = _makeKey(name, lat, lon);
    final initialLen = raw.length;

    final updated = raw.where((e) {
      final d = json.decode(e);
      final hasKey = d['key'] != null;
      if (hasKey) return d['key'] != targetKey;
      // Fallback si es viejo sin 'key': compara por nombre normalizado
      return (d['nombre']?.toString().toLowerCase().trim() ?? '') !=
          name.toLowerCase().trim();
    }).toList();

    _box.write(_key, updated);

    final removed = initialLen - updated.length;
    if (removed > 0) {
      Get.snackbar(
        'Eliminada',
        'Ciudad eliminada: $name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.delete_outline, color: Colors.white),
      );
    } else {
      Get.snackbar(
        'Sin cambios',
        'No se encontró la ciudad para eliminar',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey,
        colorText: Colors.white,
        icon: const Icon(Icons.info_outline, color: Colors.white),
      );
    }
  }

  void clearAll() {
    _box.remove(_key);
  }

  String _makeKey(String name, double lat, double lon) {
    final n = name.toLowerCase().trim();
    final la = lat.toStringAsFixed(4); // ajusta precisión si quieres
    final lo = lon.toStringAsFixed(4);
    return '$n@$la,$lo';
  }
}
