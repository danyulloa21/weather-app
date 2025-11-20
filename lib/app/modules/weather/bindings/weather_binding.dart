import 'package:get/get.dart';
import 'package:weather_app/app/data/models/city_model.dart';
import 'package:weather_app/app/data/services/weather_service.dart';
import 'package:weather_app/app/modules/weather/controllers/weather_controller.dart';

class WeatherBinding extends Bindings {
  @override
  void dependencies() {
    // ⭐️ Servicio que hablará con la API de Meteomatics
    Get.lazyPut<WeatherService>(() => WeatherService());

    // ⭐️ Controlador que recibe la ciudad seleccionada por argumentos
    Get.lazyPut<WeatherController>(() {
      final city = Get.arguments as CityModel; // viene desde HomeView
      return WeatherController(
        city: city,
        weatherService: Get.find<WeatherService>(),
      );
    });
  }
}
