import 'package:get/get.dart';
import 'package:weather_app/app/data/models/city_model.dart';
import 'package:weather_app/app/data/services/city_service.dart';

class HomeController extends GetxController {
  final CityService _service = Get.put(CityService());
  final isLoading = false.obs;
  final cities = <CityModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCities();
  }

  void loadCities() {
    cities.assignAll(_service.getCities());
  }

  void removeCity(CityModel city) {
    _service.removeCityByKey(city.name, city.lat, city.lon);
    loadCities();
  }
}
