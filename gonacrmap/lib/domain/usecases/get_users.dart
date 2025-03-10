/*5. El caso de uso se encargara de ejecutar la logica */


import 'package:gonacrmap/domain/entities/user.dart';
import 'package:gonacrmap/domain/repositories/user_repository.dart';

class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<List<User>> call() async {
    return await repository.getUsers();
  }
}