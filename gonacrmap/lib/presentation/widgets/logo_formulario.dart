import 'package:flutter/material.dart';

class LogoFormulario extends StatelessWidget {
  const LogoFormulario({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Usar SizedBox para controlar el tamaño de la imagen
        SizedBox(
           // Ajusta el tamaño según lo necesites
          child: (
             Image.asset("assets/images/GonacLogo.png"))  // Carga la imagen de assets
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: 
          Text(
            "Bienvenido",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.headlineMedium
                : Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.black, fontSize:35, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
