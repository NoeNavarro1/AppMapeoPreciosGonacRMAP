// presentation/widgets/navegacion.dart
import 'package:flutter/material.dart';
import 'package:gonacrmap/domain/services/navigation_service.dart'; // Importamos el servicio
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Navegacion extends StatefulWidget {
  const Navegacion({Key? key}) : super(key: key);

  @override
  State<Navegacion> createState() => _NavegacionState();
}

class _NavegacionState extends State<Navegacion> {
  int _selectedIndex = 0;
  final NavigationService _navigationService = NavigationService();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navigationService.getPage(_selectedIndex),  // Usamos el servicio para obtener la página
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff6200ee),
        unselectedItemColor: const Color(0xff757575),
        onTap: _onItemTapped,
        items: _navBarItems,
      ),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(Icons.monetization_on),
    title: const Text("Mapeo"),
    selectedColor: Colors.purple,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.check_circle),
    title: const Text("Reportes"),
    selectedColor: Colors.pink,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.bar_chart_rounded),
    title: const Text("Análisis"),
    selectedColor: Colors.orange,
  ),
];
