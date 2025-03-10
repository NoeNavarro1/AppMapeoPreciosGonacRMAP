// import 'package:flutter/material.dart';
// import 'package:gonacrmap/domain/entities/user.dart';
// import 'package:gonacrmap/data/repositories/user_repository_impl.dart';
// import 'package:gonacrmap/data/datasources/api_service.dart';

// class UserScreen extends StatefulWidget {
//   @override
//   _UserScreenState createState() => _UserScreenState();
// }

// class _UserScreenState extends State<UserScreen> {
//   late Future<List<User>> _usersFuture;
//   late UserRepositoryImpl _userRepository;

//   @override
//   void initState() {
//     super.initState();
//     _userRepository = UserRepositoryImpl(ApiService());
//     _usersFuture = _userRepository.getUsers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Usuarios')),
//       body: FutureBuilder<List<User>>(
//         future: _usersFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No hay usuarios disponibles'));
//           } else {
//             final users = snapshot.data!;
//             return ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 final user = users[index];
//                 return ListTile(
//                   title: Text(user.name),
//                   subtitle: Text("Edad: ${user.edad}\nNúmero de empleado: ${user.numero_empleado}"),
                  
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
