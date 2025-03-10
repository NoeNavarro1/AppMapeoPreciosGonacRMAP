import 'package:flutter/material.dart';
import 'package:gonacrmap/domain/services/navbar_service.dart'; // Servicio de navegación
import 'package:gonacrmap/presentation/widgets/customdrawer.dart';
import 'package:gonacrmap/presentation/widgets/profile_icon.dart'; // Ícono de perfil
import 'package:dio/dio.dart';
import '../widgets/form_dialog.dart';

class MapeoPrecios extends StatelessWidget {

  void _showFormDialog(BuildContext context){
    final Dio dio = Dio();
    showDialog(
      context: context, 
      builder: (context) => FormDialog(dio: dio,) 
      );
  }

  const MapeoPrecios({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = NavbarService(); // Crea el servicio de navegación

    return Scaffold(
        backgroundColor:
            Colors.white, // Fondo blanco o el que desees para tu vista
        appBar: AppBar(
          backgroundColor: Colors.purple, // Color específico para el AppBar
          title: const Text(
            "Mapeo de precios",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
          titleSpacing: 0,
          // Mostrar las 3 rayitas solo en pantallas pequeñas
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu,
                    color: Colors.white), // Menú de las 3 rayitas
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
              child: ProfileIcon(
                  navigationService: navigationService), // Ícono de perfil
            ),
          ],
        ),
        // Usamos el CustomDrawer aquí
        drawer: CustomDrawer(drawerColor: Colors.purple),
        body: Container(
          margin: EdgeInsets.all(15),
          alignment: Alignment.topRight,
          child: TextButton(
            style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor: WidgetStateProperty.all<Color>(Colors.purple)),
            onPressed: () => _showFormDialog(context),
            child: Text("Mapear Precio"),
          )
        ));
  }
}
