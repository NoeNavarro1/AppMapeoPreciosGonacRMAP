import 'package:flutter/material.dart';
import 'package:gonacrmap/domain/services/navbar_service.dart'; // Importamos el servicio

class ProfileIcon extends StatelessWidget {
  final NavbarService navigationService; // Recibimos el servicio de navegación

  const ProfileIcon({Key? key, required this.navigationService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      icon: const Icon(
        Icons.person,
        color: Colors.white,
      ),
      offset: const Offset(0, 40),
      onSelected: (Menu item) {
        // Delegamos la acción seleccionada al servicio
        navigationService.handleMenuItem(item, context);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        const PopupMenuItem<Menu>(
          value: Menu.itemOne,
          child: Text('Cuenta'),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.itemTwo,
          child: Text('Configuración'),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.itemThree,
          child: Text('Cerrar Sesión'),
        ),
      ],
    );
  }
}
