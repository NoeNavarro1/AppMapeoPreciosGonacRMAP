class ValidatePasswordUsecase {
  String? execute(String? value){
    if(value == null || value.isEmpty){
      return "Por favor introduce tu contraseña";
    }

    if(value.length < 6){
      return "La contraseña debe tener al menos 6 caracteres";
    }

    return null;
  }
}