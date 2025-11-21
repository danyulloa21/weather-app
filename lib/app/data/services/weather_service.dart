import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/app/data/models/city_model.dart';
import 'package:weather_app/app/data/models/wearher_model.dart';

class WeatherService {
  // ⭐️ mete aquí tu usuario y contraseña de Meteomatics SOLO para pruebas
  void main() async {
  await dotenv.load(fileName: ".env");
}
static String get apiTokenUrl => dotenv.env['meteomatics_api_url'] ?? 'https://login.meteomatics.com/api/v1/token';
  static String get _username => dotenv.env['meteomatics_user'] ?? '';
  static String get _password => dotenv.env['meteomatics_pwd'] ?? '';
  

  Future<WeatherModel> getCurrentWeatherForCity(CityModel city) async {

    // Fecha actual en UTC con formato Meteomatics
    final nowUtc = DateTime.now().toUtc();
    final dateStr = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(nowUtc);

    // parámetros de Meteomatics:
    // - t_2m:C → temperatura a 2m en °C
    // - relative_humidity_2m:p → humedad relativa en %
    // - weather_symbol_1h:idx → símbolo general del tiempo de la última hora
    const params = 't_2m:C,relative_humidity_2m:p,weather_symbol_1h:idx';

    final lat = city.lat;
    final lon = city.lon;

    final uri = Uri.https(
      'api.meteomatics.com',
      '/$dateStr/$params/$lat,$lon/json',
    );

    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$_username:$_password'))}';

    final response = await http.get(uri, headers: {'Authorization': basicAuth});

    if (response.statusCode != 200) {
      throw Exception(
        'Error Meteomatics: ${response.statusCode} ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    // ⭐️ Aquí parseas el JSON a tu WeatherModel.
    // La estructura de Meteomatics es algo como:
    // {
    //   "data": [
    //     { "parameter": "t_2m:C", "coordinates": [ ... ] },
    //     { "parameter": "relative_humidity_2m:p", ... },
    //     { "parameter": "weather_symbol_1h:idx", ... }
    //   ]
    // }
    //
    // Adapta este parseo a tu modelo real:
    return WeatherModel.fromMeteomaticsJson(data);
  }
}
