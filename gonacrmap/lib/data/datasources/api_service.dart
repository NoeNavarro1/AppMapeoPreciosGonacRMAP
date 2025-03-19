import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://10.11.20.126:8000/api/",
    headers: {
      'Content-Type': 'application/json', 
      'Accept': 'application/json',
    },
  ));

  // Método para hacer solicitudes POST
  Future<Map<String, dynamic>> postRequest(String endpoint, dynamic data, {Options? options}) async {
    try {
      final response = await _dio.post(endpoint, data: data, options: options);
      return response.data; // Devolver los datos directamente
    } catch (e) {
      print("Error en POST: $e");
      rethrow;
    }
  }

  // Método para hacer solicitudes GET
  Future<dynamic> getRequest(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return response.data; // Devolver los datos directamente, sean List o Map
    } catch (e) {
      print("Error en GET: $e");
      rethrow;
    }
  }
}
