class ValidatorFullName {
  static String? validFullName(String fullName) {
    RegExp hasDigits = RegExp(r"/^?=.*\d$/");
    RegExp hasSpecialCharacter = RegExp(r"/^?=.*[$*&@#]$/");
    RegExp verifyName = RegExp(r"/[A-Z][a-z]* [A-Z][a-z]*/");

    if (fullName.isEmpty) {
      return "Nome completo não preenchido";
    }

    if (hasDigits.hasMatch(fullName)) {
      return "Deve conter ao menos um dígito";
    }

    if (hasSpecialCharacter.hasMatch(fullName)) {
      return "Não deve conter caracteres especiais";
    }

    if (verifyName.hasMatch(fullName)) {
      return "A inicial deve ser maiuscula";
    }

    return null;
  }
}
