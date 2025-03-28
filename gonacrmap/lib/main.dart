import 'package:flutter/material.dart';
import 'package:gonacrmap/presentation/pages/loginpage.dart';
import 'package:gonacrmap/presentation/providers/formulario_provider.dart';
import 'package:gonacrmap/presentation/providers/mapeo_precios_provider.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/user_provider.dart';
import './data/datasources/api_login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MapeoPreciosProvider()),
        ChangeNotifierProvider(create: (_) => FormularioProvider()),
        Provider<AuthService>(create: (_) => AuthService()),
        
      ],
       child: MaterialApp(
        home: Loginpage(),
       ), 
      );
  }
}

