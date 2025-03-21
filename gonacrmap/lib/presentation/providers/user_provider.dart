import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  String _nombre = '';

  String get nombre => _nombre;

  //Actualizamos el nombre de usuario...
  void setUsername(String nombre){
    _nombre = nombre;
    notifyListeners(); //Notificar a los widgets que utlizaran este provider
  }
}
