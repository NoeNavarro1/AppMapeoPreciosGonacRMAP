// /*4. Aqui convertimos los datos de la API en objetos de dominio (User) */
// import 'package:gonacrmap/data/datasources/api_service.dart';
// import 'package:gonacrmap/domain/entities/user.dart';
// import 'package:gonacrmap/domain/repositories/user_repository.dart';

// class UserRepositoryImpl implements UserRepository{
//   final ApiService apiService;

//   UserRepositoryImpl(this.apiService);

//   @override
//   Future<List<User>> getUsers() async{
//     final usersData = await apiService.fetchUsers();

//     return usersData.map<User>((json) {
//       return User(
//         id: json['id'],
//         name: json['nombre'],
//         edad: json['edad'], 
//         numero_empleado: json['numero_empleado'],
//       );
//     }).toList();
//   }
// }