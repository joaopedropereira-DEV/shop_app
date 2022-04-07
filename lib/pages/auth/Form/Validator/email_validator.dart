class EmailValidator {
  static String? validEmail(String email) {
    RegExp emailValidator = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (email.isEmpty) {
      return "Endereço de email necessário";
    } else {
      if (emailValidator.hasMatch(email)) {
        return "Email inválido";
      }
    }

    return null;
  }
}
