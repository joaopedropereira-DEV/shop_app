class PasswordCheck {
  static String? validPassword(String password) {
    RegExp hasDigits = RegExp(r'/^?=.*\d$/');
    RegExp hasLowercase = RegExp(r'/^?=.*[a-z]$/');
    RegExp hasUppercase = RegExp(r'/^?=.*[A-Z]$/');
    RegExp hasSpecialCharacter = RegExp(r'/^?=.*[$*&@#]$/');

    if (password.isEmpty) {
      "Senha necessária";
    } else {
      if (hasDigits.hasMatch(password)) {
        return "Deve possuir pelo menos um digito";
      }

      if (hasLowercase.hasMatch(password)) {
        return "Deve possuir pelo menos uma letra minúscula";
      }

      if (hasUppercase.hasMatch(password)) {
        return "Deve possuir pelo menos uma letra maiúscula";
      }

      if (hasSpecialCharacter.hasMatch(password)) {
        return "Deve possuir pelo menos um caracter especial";
      }

      if (password.trim().length < 6) {
        return "Deve possuir no mínimo 6 letras";
      }
    }

    return null;
  }
}
