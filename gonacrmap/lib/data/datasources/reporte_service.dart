import 'api_service.dart';

class ReporteService {
  
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> fetchEstablecimientos(String query) async {
    try {
      final response = await _apiService.getRequest(
        'ClientesLista/',
        queryParameters: {'search': query},
      );
      print('Respuesta de establecimientos: $response');
      List<Map<String, dynamic>> establecimientos =
          List<Map<String, dynamic>>.from(response);

      return establecimientos.where((establecimiento) {
        return establecimiento['nombre_cliente']
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      print('Error al obtener establecimientos: $e');
      return [];
    }
  }


}