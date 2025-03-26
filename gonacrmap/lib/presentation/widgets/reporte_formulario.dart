import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ReporteFormulario {
  Widget buildTextField({
  required String label,
  required String name,
  TextEditingController? controller,
  void Function(dynamic value)? onChanged, // Hacer que onChanged sea opcional
}) {
  return FormBuilderTextField(
    name: name,
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black),
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    ),
    // Si onChanged no es necesario, puedes omitirlo
    onChanged: onChanged,
    validator: FormBuilderValidators.required(), // Si no es obligatorio, puedes remover esto
  );
}


  Widget buildDatePicker({required String label, required String name}) {
    return FormBuilderDateTimePicker(
      name: name,
      inputType: InputType.date,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      validator: FormBuilderValidators.required(),
      );
  }

  Widget buildDropdown({required String label, required String name, required List<String>items}){
    return FormBuilderDropdown(
      name: name, 
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      validator: FormBuilderValidators.required(), 
      );
  }

  Widget buildIconButton({required IconData icon, required String label, required VoidCallback onPressed}){
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
      ),
    );
  }

  Widget buildSubmitButton({required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text('Enviar Formulario'), 
    );
  }
}