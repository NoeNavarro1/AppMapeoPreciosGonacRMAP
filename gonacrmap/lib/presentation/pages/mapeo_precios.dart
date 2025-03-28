import 'package:flutter/material.dart';
import 'package:gonacrmap/domain/services/navbar_service.dart';
import 'package:gonacrmap/presentation/widgets/customdrawer.dart';
import 'package:gonacrmap/presentation/widgets/profile_icon.dart';
import 'package:provider/provider.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import '../widgets/form_dialog.dart';
import '../providers/mapeo_precios_provider.dart';


class MapeoPrecios extends StatelessWidget {
  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FormDialog(),
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
        centerTitle: true,
        title: const Text(
          "Mapeo de precios",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Botón con animación de hover
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () => _showFormDialog(context),
                    child: const Text(
                      'Mapear Producto',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.productos.length,
                    itemBuilder: (context, index) {
                      final producto = provider.productos[index];
                      return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: ExpansionTileCard(
                          elevation: 4,
                          borderRadius: BorderRadius.circular(20),
                          title: Text(
                            producto.nombreProducto,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            'Precio: \$${producto.precio}',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                          ),
                          leading: Icon(Icons.shopping_cart, color: Colors.purple),
                          trailing: Icon(Icons.expand_more, color: Colors.purple),
                          children: [
                            if (producto.foto.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  producto.foto,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
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
                              title: Text('Unidad de medida: ${producto.unidad}'),
                            ),
                            ListTile(
                              title: Text('Gramaje: ${producto.gramaje}'),
                            ),
                            ListTile(
                              title: Text('Fecha: ${producto.fecha.toLocal()}'),
                            ),
                          ],
                        ),
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

