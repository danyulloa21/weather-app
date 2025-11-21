import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/global/layout/layout.dart';
import 'package:weather_app/app/modules/credits/controllers/credits_controller.dart';

class CreditsViews extends GetView<CreditsController> {
  const CreditsViews({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutView(
      title: 'Creditos',
      body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Integrantes:\nLuis Eduardo Martinez Espinoza\nDaniel Elias Ulloa Mada',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Información tomada de:\nMeteomatics AG',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )
    );
  }
}
