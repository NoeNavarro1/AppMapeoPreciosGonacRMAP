import 'package:flutter/material.dart';
import 'package:gonacrmap/presentation/widgets/login_formulario.dart';
import 'package:gonacrmap/presentation/widgets/logo_formulario.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Center(
        child: isSmallScreen
        ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LogoFormulario(),
            LoginFormulario(),
          ],
        )
        : Container(
          padding: const EdgeInsets.all(32.0),
          constraints: const BoxConstraints(maxWidth: 800),
          child: Row(
            children: const [
              Expanded(child: LogoFormulario()),
              Expanded(
                child: Center(child: LoginFormulario()),
              )
            ],
          ),
        )
      ),
    );
  }
}