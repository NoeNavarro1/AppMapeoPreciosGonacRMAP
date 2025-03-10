// import 'package:gonacrmap/data/datasources/api_service.dart';
// import 'package:gonacrmap/domain/entities/marcas.dart';
// import 'package:gonacrmap/domain/repositories/marcas_repository.dart';

// class MarcasRepositoryImpl implements MarcasRepository{
//   final ApiService apiService;

// MarcasRepositoryImpl(this.apiService);

//   @override
//   Future<List<Marcas>> getMarcas() async{
//     final marcasData = await apiService.fetchMarcas();

//     return marcasData.map<Marcas>((json){
//       return Marcas(
//         nombre: json['nombre'],
//         );
//       }).toList();
//     }
//   }