import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gonacrmap/presentation/providers/user_provider.dart';

class CustomDrawer extends StatelessWidget {
  final String? drawerTitle;
  final Color drawerColor; // Color del encabezado

  const CustomDrawer({
    super.key,
    this.drawerTitle = 'Menú',
    required this.drawerColor,
  });

  // Lista de opciones de menú con iconos
  static const List<Map<String, dynamic>> menuItems = [
    {'title': 'Acerca de la aplicación', 'icon': Icons.info},
    {'title': 'Contacto', 'icon': Icons.contact_mail},
    {'title': 'Configuraciones', 'icon': Icons.settings},
    {'title': 'Cerrar sesión', 'icon': Icons.logout},
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Encabezado con el color personalizado
          Container(
            color: drawerColor,
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/GonacLogo.png",
                      width: 100,
                      height: 100,
                      ),
                    const SizedBox(height: 10),
                    Text(
                      'BIENVENIDO, ${userProvider.nombre.isEmpty ? 'Usuario' : userProvider.nombre}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Lista de opciones con fondo blanco
          Expanded(
            child: Container(
              color: Colors.white, // Fondo blanco
              child: ListView(
                padding: EdgeInsets.only(top: 20),
                children: menuItems.map((item) {
                  return ListTile(
                    leading: Icon(item['icon'], color: Colors.black),
                    title: Text(item['title']),
                    textColor: Colors.black,
                    onTap: () {
                      Navigator.pop(context);
                      // Lógica de navegación o acciones
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
