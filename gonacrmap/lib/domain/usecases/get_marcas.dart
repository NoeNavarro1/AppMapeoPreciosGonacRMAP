import 'package:gonacrmap/domain/entities/marcas.dart';
import 'package:gonacrmap/domain/repositories/marcas_repository.dart';

class GetMarcas {
  final MarcasRepository repository;

  GetMarcas(this.repository);

  Future<List<Marcas>> call() async{
    return await repository.getMarcas();
  }
}