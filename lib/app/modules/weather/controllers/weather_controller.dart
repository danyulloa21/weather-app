import 'package:get/get.dart';
import 'package:weather_app/app/data/models/city_model.dart';
import 'package:weather_app/app/data/models/wearher_model.dart';
import 'package:weather_app/app/data/services/weather_service.dart';

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

  /// Texto de humedad: "35 %"
  String get humidityLabel {
    final w = weather.value;
    return w == null ? '-- %' : '${w.humedad.toStringAsFixed(0)} %';
  }

  /// Descripción del símbolo del clima
  String get description {
    final w = weather.value;
    if (w == null) return '---';

    // Mapa según weather_symbol_1h:idx
    switch (w.symbolCode) {
      case 1:
        return 'Despejado';
      case 2:
        return 'Mayormente despejado';
      case 3:
        return 'Parcialmente nublado';
      case 4:
        return 'Nublado';
      case 5:
        return 'Lluvia ligera';
      case 6:
        return 'Lluvia';
      case 7:
        return 'Tormenta';
      default:
        return 'Clima desconocido';
    }
  }

  /// Puedes mostrar diferentes iconos en la UI
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
        return '🌦️';
      case 6:
        return '🌧️';
      case 7:
        return '⛈️';
      default:
        return '❓';
    }
  }
}
