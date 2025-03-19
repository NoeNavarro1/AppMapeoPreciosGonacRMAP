class Producto {
  final String nombreProducto;
  late final String marca;
  late final String categoria;
  final String establecimiento;
  late final String zona;
  late final String region;
  final String unidad;
  final String gramaje;
  final double precio;
  final DateTime fecha;
  String foto;

  Producto({
    required this.nombreProducto,
    required this.marca,
    required this.categoria,
    required this.establecimiento,
    required this.zona,
    required this.region,
    required this.unidad,
    required this.gramaje,
    required this.precio,
    required this.fecha,
    required this.foto,

  });
}
