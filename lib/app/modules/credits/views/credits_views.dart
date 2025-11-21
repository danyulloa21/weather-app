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
                const Icon(
                  Icons.map_outlined,
                  size: 96,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sin ciudades aún',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Agrega tu primera ciudad para ver el clima actual.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => Get.toNamed('/search'),
                  icon: const Icon(Icons.add_location_alt),
                  label: const Text('Agregar ciudad'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          )
    );
  }
}
