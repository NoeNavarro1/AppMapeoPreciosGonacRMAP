//Archivo que maneja las solicitudes a la api (GET, POST, PUT, DELETE)

import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://192.168.1.72:8000/api/",
  headers: {
    'Content-Type': 'application/json', 
    'Accept': 'application/json',
    },
    // connectTimeout: Duration(milliseconds: 5000),
    // receiveTimeout: Duration(milliseconds: 5000),

  ));

  Future<Map<String, dynamic>> postRequest(String endpoint, Map<String, dynamic> data, {required options}) async{
    final response = await _dio.post(endpoint, data:data);
    return response.data;
  }

  Future <List<dynamic>> getRequest(String endpoint) async {
    final response = await _dio.get(endpoint);
    return response.data;
  }
}
