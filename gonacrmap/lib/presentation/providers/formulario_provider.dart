import 'package:flutter/material.dart';

class FormularioProvider extends ChangeNotifier {

  final Map<String, TextEditingController> controllers = {
    'nombreProducto': TextEditingController(),
    'marca': TextEditingController(),
    'categoria': TextEditingController(),
    'establecimiento': TextEditingController(),
    'zona': TextEditingController(),
    'region': TextEditingController(),
    'gramage': TextEditingController(),
    'unidad': TextEditingController(),
    'precio': TextEditingController(),
    'fecha': TextEditingController(),
  
  };

  final Map<String, String?> selectedValues = {
    'marca': '',
    'categoria': '',
    'zona': '',
    'region': '',
    'unidad': '',
  };

  void updateSelectedValue(String key, String? value) {
    selectedValues[key] = value;
    notifyListeners();
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
