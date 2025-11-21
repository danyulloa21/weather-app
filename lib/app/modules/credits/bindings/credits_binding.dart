import 'package:get/get.dart';
import 'package:weather_app/app/modules/credits/controllers/credits_controller.dart';

class CreditsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditsController>(() => CreditsController());
  }
}
