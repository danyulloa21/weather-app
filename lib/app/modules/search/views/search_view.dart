import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/global/layout/layout.dart';

import '../controllers/search_controller.dart' as search_ctrl;

class SearchView extends GetView<search_ctrl.SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutView(
      title: 'Agregar Ciudad',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 20,
          children: [
            TextField(
              controller: controller.textController,
              decoration: const InputDecoration(
                labelText: 'Buscar ciudad',
                border: OutlineInputBorder(),
              ),
              onSubmitted: controller.searchCity,
            ),

            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.results.isEmpty) {
                return const Text('Sin resultados');
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: controller.results.length,
                  itemBuilder: (context, index) {
                    final ciudad = controller.results[index];
                    return ListTile(
                      title: Text(ciudad['display_name']),
                      subtitle: Text(
                        'Lat: ${ciudad['lat']}, Lon: ${ciudad['lon']}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_location_alt),
                        onPressed: () => controller.addCity(ciudad),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
