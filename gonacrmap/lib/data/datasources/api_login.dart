import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gonacrmap/presentation/providers/user_provider.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';

class AuthService {

  final logger = Logger();

  final ApiService _apiService = ApiService();

  // Función de login, que hace la solicitud a la API para autenticar al usuario
  Future<Map<String, dynamic>> loginUser(int numeroEmpleado, String password, BuildContext context) async {
    final data = {
      'numero_empleado': numeroEmpleado,
      'password': password,
    };
    try {
      // Solicitar datos a la API a través del ApiService
      final response = await _apiService.postRequest(
        'mobile-login/', 
        data, 
        options: Options(headers: {'Content-type': 'application/json'})
      );

      if (response['mensaje'] == 'Inicio de sesión exitoso') {
        // Actualizar el nombre del usuario en el UserProvider
        Provider.of<UserProvider>(context, listen: false).setUsername(response['usuario']);
        logger.i("Inicio de sesión exitoso, datos de usuario: $data");
      }

      // Retornar la respuesta si es exitosa
      return response;
    } catch (e) {
      // Manejo de errores si la solicitud falla
      logger.e("Error al realizar el login: $e");
      throw ("Error al realizar el login");
    }
  }
}
