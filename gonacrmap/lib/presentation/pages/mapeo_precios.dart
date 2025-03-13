import 'package:flutter/material.dart';
import 'package:gonacrmap/domain/services/navbar_service.dart';
import 'package:gonacrmap/presentation/widgets/customdrawer.dart';
import 'package:gonacrmap/presentation/widgets/profile_icon.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart'; 
import '../widgets/form_dialog.dart';
import '../providers/mapeo_precios_provider.dart';

class MapeoPrecios extends StatelessWidget {
  void _showFormDialog(BuildContext context) {
    final Dio dio = Dio();
    showDialog(
      context: context,
      builder: (context) => FormDialog(dio: dio),
    );
  }

  const MapeoPrecios({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = NavbarService();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          "Mapeo de precios",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
        titleSpacing: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ProfileIcon(navigationService: navigationService),
          ),
        ],
      ),
      drawer: CustomDrawer(drawerColor: Colors.purple),
      body: Consumer<MapeoPreciosProvider>(
        builder: (context, provider, child) {
          return Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.purple),
                  ),
                  onPressed: () => _showFormDialog(context),
                  child: const Text("Mapear Precio"),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.productos.length,
                    itemBuilder: (context, index) {
                      final producto = provider.productos[index];
                      return ExpansionTileCard(
                        elevation: 2,
                        title: Text(producto.nombreProducto),
                        subtitle: Text('Precio: \$${producto.precio}'),
                        children: [
                          ListTile(
                            title: Text('Marca: ${producto.marca}'),
                          ),
                          ListTile(
                            title: Text('Categoría: ${producto.categoria}'),
                          ),
                          ListTile(
                            title: Text('Establecimiento: ${producto.establecimiento}'),
                          ),
                          ListTile(
                            title: Text('Zona: ${producto.zona}'),
                          ),
                          ListTile(
                            title: Text('Región: ${producto.region}'),
                          ),
                          ListTile(
                            title: Text('Unidad de medida: ${producto.unidadMedida}'),
                          ),
                          ListTile(
                            title: Text('Fecha: ${producto.fecha.toLocal()}'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
