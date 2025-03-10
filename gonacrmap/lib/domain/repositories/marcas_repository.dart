import 'package:gonacrmap/domain/entities/marcas.dart';

abstract class MarcasRepository {
  Future<List<Marcas>> getMarcas();
}