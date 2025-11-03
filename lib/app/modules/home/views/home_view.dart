import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/global/layout/layout.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutView(
      title: 'Mis Ciudades',
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final cities = controller.cities;
        if (cities.isEmpty) {
          return Center(
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
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.loadCities(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: cities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final city = cities[index];
                final keyString = '${city.name}_${city.lat}_${city.lon}';
                String fmt(double v) => v.toStringAsFixed(4);

                return Dismissible(
                  key: ValueKey(keyString),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    // ⭐️ elimina por modelo completo (usa tu método actualizado)
                    controller.removeCity(city);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Eliminada: ${city.name}')),
                    );
                  },
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: const CircleAvatar(
                        child: Icon(Icons.wb_sunny_outlined),
                      ),
                      title: Text(
                        city.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Lat: ${fmt(city.lat)} · Lon: ${fmt(city.lon)}',
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            tooltip: 'Ver clima',
                            icon: const Icon(Icons.thermostat_outlined),
                            onPressed: () {
                              // ⭐️ aquí puedes navegar a un detalle si lo agregas
                              // Get.toNamed('/city', arguments: city);
                            },
                          ),
                          IconButton(
                            tooltip: 'Eliminar',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              controller.removeCity(city);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
