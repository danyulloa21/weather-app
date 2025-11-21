import 'package:get/get.dart';
import 'package:weather_app/app/modules/credits/bindings/credits_binding.dart';
import 'package:weather_app/app/modules/credits/views/credits_views.dart';
import 'package:weather_app/app/modules/weather/bindings/weather_binding.dart';
import 'package:weather_app/app/modules/weather/views/weather_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/search/bindings/search_binding.dart';

part 'app_routes.dart'; // opcional si te gusta separar nombres

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.search,
      page: () => const SearchView(),
      binding: SearchBinding(),
      transition: Transition.rightToLeft, // opcional
    ),
    GetPage(
      name: Routes.weather,
      page: () => const WeatherView(),
      binding: WeatherBinding(),
      transition: Transition.rightToLeft, // opcional
    ),
    GetPage(
      name: Routes.credits,
      page: () => const CreditsViews(),
      binding: CreditsBinding(),
      transition: Transition.rightToLeft, // opcional
    ),
  ];
}
