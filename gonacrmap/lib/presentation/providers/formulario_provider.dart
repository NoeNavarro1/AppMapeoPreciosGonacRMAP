import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FormularioProvider extends ChangeNotifier {
  final Dio dio;
  final String ip;

  FormularioProvider({required this.dio, required this.ip});

  Map<int, String> marcas = {};
  Map<int, String> categorias = {};
  Map<int, String> zonas = {};
  Map<int, String> regiones = {};

  /// Función genérica para obtener nombres de entidades según su ID
  Future<String> _fetchNombre({
    required Map<int, String> cache,
    required int id,
    required String endpoint,
  }) async {
    if (cache.containsKey(id)) return cache[id]!; // Retorna desde caché

    try {
      final response = await dio.get("http://$ip:8000/api/$endpoint/$id/");
      final nombre = response.data['nombre'] ?? '';
      cache[id] = nombre;
      return nombre;
    } catch (e) {
      print("Error al obtener datos de $endpoint (ID: $id): $e");
      return '';
    }
  }

  /// Métodos específicos utilizando `_fetchNombre`
  Future<String> getMarcaNombre(int marcaId) => _fetchNombre(
        cache: marcas,
        id: marcaId,
        endpoint: "Marcas",
      );

  Future<String> getCategoriaNombre(int categoriaId) => _fetchNombre(
        cache: categorias,
        id: categoriaId,
        endpoint: "Categorias",
      );

  Future<String> getZonaNombre(int zonaId) => _fetchNombre(
        cache: zonas,
        id: zonaId,
        endpoint: "Zona",
      );

  Future<String> getRegionNombre(int regionId) => _fetchNombre(
        cache: regiones,
        id: regionId,
        endpoint: "Region",
      );
}
