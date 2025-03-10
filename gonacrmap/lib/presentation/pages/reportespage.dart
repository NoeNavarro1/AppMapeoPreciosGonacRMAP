import 'package:flutter/material.dart';
import 'package:gonacrmap/domain/services/navbar_service.dart';
import 'package:gonacrmap/presentation/widgets/customdrawer.dart';
import 'package:gonacrmap/presentation/widgets/profile_icon.dart';

class Reportespage extends StatelessWidget {
  const Reportespage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = NavbarService();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("Reportes de calidad",
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w400
          ),
        ),
        titleSpacing: 0,
        // Mostrar las 3 rayitas solo en pantallas pequeñas
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white), // Menú de las 3 rayitas
              onPressed: () {
                // Abrir el drawer (menú lateral) al presionar las 3 rayitas
                Scaffold.of(context).openDrawer(); // Se abre el Drawer
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ProfileIcon(navigationService: navigationService), // Ícono de perfil
          ),
        ],
      ),
      // Aquí definimos el Drawer (menú lateral)
      drawer: CustomDrawer(drawerColor: Colors.pink),
      body: const Center(
        child: Text("Contenido de Reportes de calidad"),
      ),
    );
  }
}
