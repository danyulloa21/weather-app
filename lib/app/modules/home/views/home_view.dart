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
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 260,
                  child: PageView.builder(
                    controller: PageController(
                      viewportFraction: 0.88,
                    ), // ⭐️ carrusel de ciudades
                    itemCount: cities.length,
                    padEnds: false,
                    itemBuilder: (context, index) {
                      final city = cities[index];
                      final keyString = '${city.name}_${city.lat}_${city.lon}';
                      String fmt(double v) => v.toStringAsFixed(4);

                      return Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Dismissible(
                          key: ValueKey(keyString),
                          direction: DismissDirection
                              .up, // ⭐️ elimina hacia arriba (no interfiere con el swipe horizontal)
                          background: Container(
                            alignment: Alignment.topCenter,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Colors.redAccent.withOpacity(0.9),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(top: 24.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          onDismissed: (_) {
                            // ⭐️ elimina por modelo completo (usa tu método actualizado)
                            controller.removeCity(city);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Eliminada: ${city.name}'),
                              ),
                            );
                          },
                          child: GestureDetector(
                            onTap: () {
                              // ⭐️ navegación al detalle del clima (ajusta la ruta según tu app)
                              // Get.toNamed('/city', arguments: city);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF4FC3F7), // azul cielo
                                    Color(0xFF1976D2), // azul más intenso
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              city.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Lat: ${fmt(city.lat)} · Lon: ${fmt(city.lon)}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.wb_sunny,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Toca para ver el clima detallado',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            tooltip: 'Ver clima',
                                            icon: const Icon(
                                              Icons.thermostat_outlined,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              // ⭐️ aquí puedes navegar a un detalle si lo agregas
                                              // Get.toNamed('/city', arguments: city);
                                            },
                                          ),
                                          IconButton(
                                            tooltip: 'Eliminar',
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.white,
                                            ),
                                            onPressed: () =>
                                                controller.removeCity(city),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
