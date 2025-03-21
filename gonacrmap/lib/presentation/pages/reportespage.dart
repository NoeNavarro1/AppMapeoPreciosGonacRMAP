import 'package:flutter/material.dart';
import 'package:gonacrmap/domain/services/navbar_service.dart';
import 'package:gonacrmap/presentation/pages/reportepage.dart';
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
        title: Text(
          "Reportes de calidad",
          style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400),
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
      // Aquí definimos el Drawer (menú lateral)
      drawer: CustomDrawer(drawerColor: Colors.pink),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Alinea los widgets al inicio
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0), // Margen alrededor del botón
            child: ElevatedButton(
              onPressed: () {
                // Funcionalidad del botón
               Navigator.push(context, MaterialPageRoute(builder: (context) => ReportePage()),
               );
              },
              child: Text('Reportar producto'),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(
                  16.0), // Margen para el contenido adicional
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contenido adicional',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Aquí puedes agregar más contenido, como texto, imágenes, o cualquier otro widget que necesites.',
                  ),
                  SizedBox(height: 20),
                  // Agrega más widgets aquí según sea necesario
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
