import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gonacrmap/data/datasources/api_login.dart';
import 'package:gonacrmap/presentation/pages/navegacion.dart';
import 'package:gonacrmap/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class LoginFormulario extends StatefulWidget {
  const LoginFormulario({Key? key}) : super(key: key);

  @override
  State<LoginFormulario> createState() => _LoginFormularioState();
}

class _LoginFormularioState extends State<LoginFormulario> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _numeroEmpleadoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _apiService = AuthService(); // Instancia de ApiService

  // Función para manejar el login
 void _login() async {
  final numeroEmpleado = _numeroEmpleadoController.text;
  final password = _passwordController.text;

  try {
    // Convertir el número de empleado a int
    final employeeNumber = int.tryParse(numeroEmpleado);

    if (employeeNumber == null) {
      // Si la conversión falla (el número no es válido)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, introduce un número de empleado válido")),
      );
      return;
    }

    // Llamada al servicio de API para hacer login
    final response = await _apiService.loginUser(employeeNumber, password, context);

    // Si la respuesta incluye un token, asumimos que el login fue exitoso (SIGUE EN REVISION)
   if(response['mensaje'] == 'Inicio de sesión exitoso'){
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const Navegacion()),
    );
    context.read<UserProvider>().setUsername(response['nombre']);
    } else {
      // Si no hay token, muestra un error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Credenciales incorrectas")),
      );
    }
  } catch (e) {
    // Manejo de errores
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 330,
              child: TextFormField(
                controller: _numeroEmpleadoController,
                validator: (value) {
                  // Aquí puedes agregar la validación de número de empleado
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Número de empleado",
                  hintText: "Introduce tu número de empleado",
                  prefixIcon: Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(height: 16),
            // Campo de contraseña
            SizedBox(
              width: 330,
              child: TextFormField(
                controller: _passwordController,
                validator: (value) {
                  // Aquí puedes agregar la validación de la contraseña
                  return null;
                },
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  hintText: "Introduce tu contraseña",
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _rememberMe,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _rememberMe = value;
                });
              },
              title: const Text('Recuérdame'),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: const EdgeInsets.all(0),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 330,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange, // Fondo anaranjado
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "INICIAR SESIÓN",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Llamada al método de login
                    _login();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gonacrmap/domain/services/auth_service.dart';
// import 'package:gonacrmap/domain/usecases/validate_employed_usecase.dart';
// import 'package:gonacrmap/domain/usecases/validate_password_usecase.dart';
// import 'package:gonacrmap/presentation/pages/navegacion.dart';

// class LoginFormulario extends StatefulWidget {
//   const LoginFormulario({Key? key}) : super(key: key);

//   @override
//   State<LoginFormulario> createState() => _LoginFormularioState();
// }

// class _LoginFormularioState extends State<LoginFormulario> {
//   bool _isPasswordVisible = false;
//   bool _rememberMe = false;

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final TextEditingController _employeeNumberController =
//       TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: const BoxConstraints(maxHeight: 300),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               width: 330,
//               child: TextFormField(
//                 controller: _employeeNumberController,
//                 validator: (value) => ValidateEmployedusecase().execute(value),
//                 decoration: const InputDecoration(
//                   labelText: "Número de empleado",
//                   hintText: "Introduce tu número de empleado",
//                   prefixIcon: Icon(Icons.badge_outlined),
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Campo de contraseña
//             SizedBox(
//               width: 330,
//               child: TextFormField(
//                 controller: _passwordController,
//                 validator: (value) => ValidatePasswordUsecase().execute(value),
//                 obscureText: !_isPasswordVisible,
//                 decoration: InputDecoration(
//                   labelText: 'Contraseña',
//                   hintText: "Introduce tu contraseña",
//                   prefixIcon: const Icon(Icons.lock_outline_rounded),
//                   border: const OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(_isPasswordVisible
//                         ? Icons.visibility_off
//                         : Icons.visibility),
//                     onPressed: () {
//                       setState(() {
//                         _isPasswordVisible = !_isPasswordVisible;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             CheckboxListTile(
//               value: _rememberMe,
//               onChanged: (value) {
//                 if (value == null) return;
//                 setState(() {
//                   _rememberMe = value;
//                 });
//               },
//               title: const Text('Recuérdame'),
//               controlAffinity: ListTileControlAffinity.leading,
//               dense: true,
//               contentPadding: const EdgeInsets.all(0),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: 330,
//                 child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepOrange, // Fondo anaranjado
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(10.0),
//                   child: Text(
//                   "INICIAR SESIÓN",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), 
//                   ),
//                 ),
//                 onPressed: () {
//                   if (_formKey.currentState?.validate() ?? false) {
//                   // Lógica de autenticación
//                   final employeeNumber = _employeeNumberController.text;
//                   final password = _passwordController.text;

//                   final AuthService _authService = AuthService();

//                   if (_authService.authenticate(employeeNumber, password)) {
//                     //Logica para redireccionar
//                     Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder:(context) => const Navegacion(),
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("Credenciales incorrectas")),
//                     );
//                   }
//                   }
//                 },
//                 ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
