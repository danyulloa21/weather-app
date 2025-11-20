import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/app/data/models/city_model.dart';
import 'package:weather_app/app/data/models/wearher_model.dart';
import 'package:weather_app/app/data/services/weather_service.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherController extends GetxController {
  final CityModel city;
  final WeatherService weatherService;

  // Estado
  final isLoading = true.obs;
  final errorMessage = RxnString();
  final weather = Rxn<WeatherModel>();

  WeatherController({required this.city, required this.weatherService});

  @override
  void onInit() {
    super.onInit();
    loadWeather();
  }

  /// === FUNCIÓN PRINCIPAL ===
  Future<void> loadWeather() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final result = await weatherService.getCurrentWeatherForCity(city);
      print(result);
      weather.value = result;
    } catch (e) {
      errorMessage.value = 'No se pudo obtener el clima: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Para usar en Pull-To-Refresh
  Future<void> refreshWeather() async => loadWeather();

  // ============================================================
  // HELPERS PARA LA UI
  // ============================================================

  /// Texto principal de temperatura: "27.3 °C"
  String get temperatureLabel {
    final w = weather.value;
    return w == null ? '-- °C' : '${w.temperatura.toStringAsFixed(1)} °C';
  }

  String get timeLabel {
    final w = weather.value;
    if (w == null) return 'Desconocido';
    return _formatearHora(w.dateTime.toIso8601String());
  }

  /// Texto de humedad: "35 %"
  String get humidityLabel {
    final w = weather.value;
    return w == null ? '-- %' : '${w.humedad.toStringAsFixed(0)} %';
  }

  /// Descripción del símbolo del clima
  String get description {
    final w = weather.value;
    if (w == null) return '---';

    return _obtenerDescripcionClima(w.symbolCode);
  }

  /// Puedes mostrar diferentes iconos en la UI (emoji, si lo sigues usando)
  String get weatherIcon {
    final w = weather.value;
    if (w == null) return '☁️';

    switch (w.symbolCode) {
      case 1:
        return '☀️';
      case 2:
        return '🌤️';
      case 3:
        return '⛅';
      case 4:
        return '☁️';
      case 5:
        return '🌧️';
      case 6:
        return '🌨️';
      case 7:
        return '❄️';
      default:
        return '❓';
    }
  }

  /// Icono basado en WeatherIcons (para usar en tu UI con Icon(weatherIconData))
  IconData get weatherIconData {
    final w = weather.value;
    if (w == null) return WeatherIcons.na;
    return _obtenerIconoClima(w.symbolCode);
  }

  // ==========================
  // MÉTODOS PRIVADOS NUEVOS
  // ==========================

  // Mapa de íconos del clima
  IconData _obtenerIconoClima(int simbolo) {
    switch (simbolo) {
      case 0:
        return WeatherIcons.na;
      case 1:
        return WeatherIcons.day_sunny;
      case 2:
        return WeatherIcons.day_sunny_overcast;
      case 3:
        return WeatherIcons.day_cloudy;
      case 4:
        return WeatherIcons.cloud;
      case 101:
        return WeatherIcons.night_clear;
      case 102:
        return WeatherIcons.night_alt_cloudy_gusts;
      case 103:
        return WeatherIcons.night_partly_cloudy;
      case 104:
        return WeatherIcons.night_cloudy;
      default:
        return WeatherIcons.na;
    }
  }

  String _obtenerDescripcionClima(int simbolo) {
    switch (simbolo) {
      case 0:
        return 'Sin datos';
      case 1:
        return 'Despejado';
      case 2:
        return 'Mayormente despejado';
      case 3:
        return 'Parcialmente Nublado';
      case 4:
        return 'Nublado';
      case 101:
        return 'Despejado (noche)';
      case 102:
        return 'Mayormente despejado (noche)';
      case 103:
        return 'Parcialmente nublado (noche)';
      case 104:
        return 'Nublado (noche)';
      default:
        return 'Desconocido';
    }
  }

  String _formatearHora(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return 'Desconocido';
    try {
      final fecha = DateTime.parse(timestamp).toLocal();
      // Ejemplo: "Jueves, 21 de noviembre de 2025 • 07:45 PM"
      final formato = DateFormat('EEEE, d MMMM yyyy • hh:mm a', 'es_MX');
      return formato.format(fecha);
    } catch (e) {
      print(e);
      return 'Desconocido';
    }
  }
}
