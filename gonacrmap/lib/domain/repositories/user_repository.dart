/*2. Aqui solo se declara las funciones que ofrecera el repositorio */

import 'package:gonacrmap/domain/entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
}