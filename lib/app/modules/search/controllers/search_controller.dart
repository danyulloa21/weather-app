import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/data/models/city_model.dart';
import 'package:weather_app/app/data/services/city_service.dart';
import 'package:weather_app/app/modules/home/controllers/home_controller.dart';

class SearchController extends GetxController {
  final CityService _service = Get.find();

  final results = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  final textController = TextEditingController();

  @override
  void onClose() {
    textController.dispose();
    results.clear();
    super.onClose();
  }

  Future<void> searchCity(String name) async {
    isLoading.value = true;
    results.value = await _service.searchCity(name);
    // print(results);
    isLoading.value = false;
  }

  void addCity(Map<String, dynamic> data) {
    final city = CityModel(
      name: data['display_name'],
      lat: double.parse(data['lat']),
      lon: double.parse(data['lon']),
    );
    _service.addCity(city);
    final home = Get.find<HomeController>();
    home.loadCities();
  }
}
