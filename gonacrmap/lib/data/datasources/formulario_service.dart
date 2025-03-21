import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gonacrmap/data/datasources/api_service.dart';
import 'package:gonacrmap/data/models/producto_model.dart';
import 'package:gonacrmap/presentation/providers/mapeo_precios_provider.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:gonacrmap/presentation/providers/formulario_provider.dart';

class FormularioService {
  final ApiService _apiService = ApiService();
  final logger = Logger();


  // Método para construir el ProductoModel a partir del proveedor
  ProductoModel getProductoFromControllers(BuildContext context) {

    final formularioProvider = Provider.of<FormularioProvider>(context, listen: false);

    String nombreProducto = formularioProvider.controllers['nombreProducto']?.text ?? '';
    String establecimiento = formularioProvider.controllers['establecimiento']?.text ?? '';
    String precio = formularioProvider.controllers['precio']?.text ?? '';
    String gramaje = formularioProvider.controllers['gramaje']?.text ?? '';

    return ProductoModel(
      nombreProducto: nombreProducto,
      marca: formularioProvider.selectedValues['marca'] ?? '',
      categoria: formularioProvider.selectedValues['categoria'] ?? '',
      establecimiento: establecimiento,
      zona: formularioProvider.selectedValues['zona'] ?? '',
      region: formularioProvider.selectedValues['region'] ?? '', 
      unidad: formularioProvider.selectedValues['unidad'] ?? '', 
      gramaje: gramaje,
      precio: double.tryParse(precio) ?? 0.0,
      fecha: DateTime.tryParse(formularioProvider.selectedValues['fecha'] ?? '') ?? DateTime.now(),
      foto: '',
    );
  }

  Future<bool> submitForm(BuildContext context, ProductoModel producto, String? imagePath) async {
    try {
      // Convertir el modelo a JSON
      Map<String, dynamic> formData = producto.toJson();

      // Transformar fecha al formato esperado por la API
      formData['fecha'] = DateFormat('yyyy-MM-dd').format(producto.fecha);

      // Preparar datos para la imagen
      FormData requestData = FormData.fromMap(formData);
      if (imagePath != null) {
        requestData.files.add(
          MapEntry(
            'foto',
            await MultipartFile.fromFile(imagePath, filename: 'producto.png'),
          ),
        );
      }

      // Enviar datos al backend
      final response = await _apiService.postRequest(
        'Productos/',
        requestData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      // Si la API devuelve la imagen, actualizar el producto
      producto.foto = response['foto'] ?? '';

      // Notificar a Provider para actualizar la UI
      Provider.of<MapeoPreciosProvider>(context, listen: false).addProducto(producto);

      return true;
    } catch (e) {
      if (e is DioException) {
        logger.t('Error de conexión: ${e.response?.data ?? e.message}');
      } else {
        logger.e('Error desconocido: $e');
      }
      return false;
    }
  }
}
