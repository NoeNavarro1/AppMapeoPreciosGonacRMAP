import '../../domain/entities/producto.dart';

class ProductoModel extends Producto {
  
  ProductoModel({
    required String nombreProducto,
    required String marca,
    required String categoria,
    required String establecimiento,
    required String zona,
    required String region,
    required String unidad,
    required String gramaje,
    required double precio,
    required DateTime fecha,
    required String foto,
  }) : super(
    nombreProducto: nombreProducto,
    marca: marca,
    categoria: categoria,
    establecimiento: establecimiento,
    zona: zona,
    region: region,
    unidad: unidad,
    gramaje: gramaje,
    precio: precio,
    fecha: fecha,
    foto: foto,
  );

  //Convertir desde Json
  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      nombreProducto: json['nombre_producto'] ?? 'Nombre no disponible',
      marca: json['marca'] ?? '',
      categoria: json['categoria'] ?? '',
      establecimiento: json['establecimiento'] ?? 'Establecimiento no encontrado',
      zona: json['zona'] ?? '',
      region: json['region'] ?? '',
      unidad: json['unidad'] ?? '',
      precio: (json['precio'] as num?)?.toDouble() ?? 0.0,
      gramaje: json['gramaje'] ?? '',
      fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
      foto: json['foto'],
    );
}

  //Convertir a Json
  Map<String, dynamic> toJson(){
    return {
      'nombre_producto': nombreProducto,
      'marca': marca,
      'categoria': categoria,
      'establecimiento': establecimiento,
      'zona': zona,
      'region': region,
      'unidad': unidad,
      'gramaje': gramaje,
      'precio': precio,
      'fecha': fecha.toIso8601String(),
      'foto': foto,
    };
  }
}


