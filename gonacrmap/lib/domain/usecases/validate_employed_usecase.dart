class ValidateEmployedusecase {
  String? execute(String? value){
    if(value == null || value.isEmpty){
      return "Por favor introduce el numero de empleado";
    }

    final isNumeric = int.tryParse(value) != null;
    if(!isNumeric){
      return "El numero de empleado debe ser numerico";
    }

    if(value.length >= 6 ){
      return "El numero de empleado debe tener 5 digitos";
    }

    return null;
  }
}