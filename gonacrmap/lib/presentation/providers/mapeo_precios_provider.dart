import 'package:flutter/material.dart';
import 'package:gonacrmap/domain/entities/producto.dart';

class MapeoPreciosProvider extends ChangeNotifier {
  List<Producto> _productos = [];

  List<Producto> get productos => _productos;

  void addProducto(Producto producto) {
    _productos.add(producto);
    notifyListeners();
  }
}
