import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayoutView extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showDrawer;
  final bool showBack;

  const LayoutView({
    super.key,
    required this.title,
    required this.body,
    this.showDrawer = true,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: showBack
            ? const BackButton(color: Colors.white)
            : (showDrawer ? null : const SizedBox()),
      ),
      drawer: showDrawer ? _buildDrawer(context) : null,
      body: SafeArea(child: body),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final current = Get.currentRoute.isEmpty ? '/' : Get.currentRoute;

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                child: Text(
                  'Weather App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _drawerItem(
              icon: Icons.home,
              title: 'Inicio',
              route: '/',
              current: current,
            ),
            _drawerItem(
              icon: Icons.search,
              title: 'Buscar ciudad',
              route: '/search',
              current: current,
            ),
            _drawerItem(
              icon: Icons.settings,
              title: 'Ajustes',
              route: '/settings',
              current: current,
            ),
            _drawerItem(
              icon: Icons.contacts,
              title: 'Creditos',
              route: '/credits',
              current: current,
            ),
          ],
        ),
      ),
    );
  }

  // Helper para los items del Drawer
  Widget _drawerItem({
    required IconData icon,
    required String title,
    required String route,
    required String current,
  }) {
    final selected = current == route;

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: selected,
      selectedTileColor: Colors.blue.withValues(alpha: 30),
      onTap: () {
        Navigator.of(Get.context!).maybePop(); // cerrar el drawer
        if (selected) return;
        if (route == '/' || route == '/home') {
          Get.offAllNamed(route);
        } else {
          Get.toNamed(route);
        }
      },
    );
  }
}
