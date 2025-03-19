import 'package:flutter/material.dart';
import 'package:gonacrmap/data/models/producto_model.dart';


class MapeoPreciosProvider extends ChangeNotifier {
  List<ProductoModel> _productos = [];

  List<ProductoModel> get productos => _productos;

  void setProductos(List<ProductoModel> nuevosProductos) {
    _productos = nuevosProductos;
    notifyListeners();
  }

  void addProducto(ProductoModel producto) {
    _productos.add(producto);
    notifyListeners();
  }
}
