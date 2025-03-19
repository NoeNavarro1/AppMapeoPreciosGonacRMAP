import 'api_service.dart';

class MapeoService {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> fetchProductos(String query) async {
    try {
      query = query.trim().isEmpty ? '' : query.toLowerCase();

      final response = await _apiService.getRequest(
        'ProductosCompetencia/',
        queryParameters: {'search': query},
      );
      print('Respuesta de productos: $response');
      List<Map<String, dynamic>> productos =
          List<Map<String, dynamic>>.from(response);

      return productos.where((producto) {
        return producto['nombre_producto']?.toString().toLowerCase().contains(query) ?? false;
      }).toList();
    } catch (e) {
      print('Error al obtener productos: $e');
      return [];
    }
  }

  Future<String> getMarcaNombre(String marcaId) async {
    try {
      final response = await _apiService.getRequest('Marcas/$marcaId/');
      print('Respuesta de la marca: $response');
      final Map<String, dynamic> data = response as Map<String, dynamic>;
      return data['nombre'] ?? '';
    } catch (e) {
      print('Error al obtener marcas: $e');
      return '';
    }
  }

  Future<String> getCategoriaName(String categoriaId) async {
    try {
      final response = await _apiService.getRequest('Categorias/$categoriaId/');
      print('Respuesta de la categoría: $response');
      final Map<String, dynamic> data = response as Map<String, dynamic>;
      return data['nombre'] ?? '';
    } catch (e) {
      print('Error al obtener categorías: $e');
      return '';
    }
  }

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

  Future<String> getZonaName(String zonaId) async {
    try {
      final response = await _apiService.getRequest('Zona/$zonaId/');
      print('Respuesta de Zona: $response');
      final Map<String, dynamic> data = response as Map<String, dynamic>;
      return data['nombre'] ?? '';
    } catch (e) {
      print('Error al obtener Zona: $e');
      return '';
    }
  }

  Future<String> getRegionName(String regionId) async {
    try {
      final response = await _apiService.getRequest('Region/$regionId');
      print('Respuesta de Región: $response');
      final Map<String, dynamic> data = response as Map<String, dynamic>;
      return data['nombre'] ?? '';
    } catch (e) {
      print('Error al obtener Regiones: $e');
      return '';
    }
  }
}
