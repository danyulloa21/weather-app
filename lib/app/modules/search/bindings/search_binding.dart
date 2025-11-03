import 'package:get/get.dart';
import 'package:weather_app/app/data/services/city_service.dart';
import '../controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // 1) Servicio primero
    Get.lazyPut<CityService>(() => CityService(), fenix: true);

    // 2) Luego el controller que lo usa
    Get.lazyPut<SearchController>(() => SearchController());
  }
}
