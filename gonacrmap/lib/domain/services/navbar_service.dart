import 'package:flutter/material.dart';
import 'package:gonacrmap/presentation/pages/loginpage.dart';

const Color redcolor = Colors.red; // Define redcolor
const Color primarycolor = Colors.blue; // Define primarycolor


class NavbarService {
  // Método para manejar lo que ocurre cuando se selecciona una opción en el menú
  void handleMenuItem(Menu item, BuildContext context) {
    switch (item) {
      case Menu.itemOne:
        print("Perfil seleccionado");
        // Aquí puedes navegar a una pantalla de cuenta o realizar alguna acción.
        break;
      case Menu.itemTwo:
        print("Configuración seleccionado");
        // Aquí puedes navegar a una pantalla de configuración o mostrar un diálogo.
        break;
      case Menu.itemThree:
        print("Cerrar sesión seleccionado");
        _logout(context);
        break;
    }
  }

  //Metodo para cerrar sesión
    _logout(BuildContext context){
    Widget cancelButton = ElevatedButton(
      child: Text("Cancelar"),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(primarycolor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
            )
        )
      ),
      onPressed: (){
        print("Cancelando...");
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Confirmar"),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(redcolor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
        )
      ),
      onPressed: (){
        print("Saliendo...");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Loginpage()),
          (route) =>false
        );
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Cerrar sesión"),
      content:  Text("Estas seguro de cerrar sesión"),
      actions: [
        cancelButton,
        continueButton
      ],
    );
    //Mostrar el dialogo...
    showDialog(
      context: context,
      builder: (BuildContext context){
        return alert;
      }
    );
  }
}

enum Menu { itemOne, itemTwo, itemThree }


// Navigator.of(context).pushAndRemoveUntil(
//     //   MaterialPageRoute(builder: (context) => const Loginpage()),
//     //   (route) => false,
//     // );
