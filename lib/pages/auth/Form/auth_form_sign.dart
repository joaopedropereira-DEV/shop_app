import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/auth/Form/Validator/email_validator.dart';
import 'package:shop_app/pages/auth/Form/Validator/full_name_validator.dart';
import 'package:shop_app/pages/auth/Form/Validator/password_validator.dart';
import '../../../Error/auth_exceptions.dart';
import '../../../components/auth_button.dart';
import '../../../providers/auth.dart';

class AuthFormSign extends StatefulWidget {
  const AuthFormSign({
    Key? key,
    required this.onLoading,
    required this.offLoading,
  }) : super(key: key);

  final void Function() onLoading;
  final void Function() offLoading;

  @override
  State<AuthFormSign> createState() => _AuthFormSignState();
}

class _AuthFormSignState extends State<AuthFormSign> {
  final _fullNameFocus = FocusNode();
  final _emailAdressFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  final _passwordController = TextEditingController();

  final _signKey = GlobalKey<FormState>();
  Map<String, String> _authSignData = {
    "fullName": '',
    "email": '',
    "password": ''
  };

  @override
  void dispose() {
    super.dispose();
    _fullNameFocus.dispose();
    _emailAdressFocus.dispose();
    _passwordFocus.dispose();
    _passwordController.dispose();
    _confirmPasswordFocus.dispose();
  }

  void _showErrorDialogSign(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ocorreu um erro"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  Future<void> _signSubmit() async {
    bool isValid = _signKey.currentState?.validate() ?? false;

    if (!isValid) return;

    widget.onLoading();

    _signKey.currentState!.save();

    // Provider
    Auth auth = Provider.of<Auth>(context, listen: false);

    try {
      // Processo de Registrar
      await auth.signUp(
        _authSignData["email"]!,
        _authSignData["password"]!,
      );
    } on AuthExceptions catch (error) {
      _showErrorDialogSign(error.toString());
    } catch (error) {
      _showErrorDialogSign("Ocorreu um erro inesperado");
    }

    Navigator.of(context).pop();
    widget.offLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            onSaved: (name) => _authSignData["fullName"] = name ?? "",
            validator: (_name) {
              final name = _name ?? "";
              return FullNameCheck.validFullName(name);
            },
            focusNode: _fullNameFocus,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_emailAdressFocus);
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              filled: true,
              hintText: "Nome completo",
              fillColor: Colors.grey.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 18),
          TextFormField(
            onSaved: (email) => _authSignData["email"] = email ?? "",
            validator: (_email) {
              final email = _email ?? "";
              return EmailCheck.validEmail(email);
            },
            focusNode: _emailAdressFocus,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocus);
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              filled: true,
              hintText: "Email",
              fillColor: Colors.grey.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 18),
          TextFormField(
            onSaved: (password) => _authSignData["password"] = password ?? "",
            validator: (_password) {
              final password = _password ?? "";
              return PasswordCheck.validPassword(password);
            },
            focusNode: _passwordFocus,
            controller: _passwordController,
            obscureText: true,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_confirmPasswordFocus);
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              filled: true,
              hintText: "Senha",
              fillColor: Colors.grey.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 18),
          TextFormField(
            validator: (_confirmPassword) {
              final confirmPassword = _confirmPassword ?? "";
              if (confirmPassword != _passwordController.text) {
                return "Senha incorreta";
              }

              return null;
            },
            focusNode: _confirmPasswordFocus,
            obscureText: true,
            onFieldSubmitted: (_) {},
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              filled: true,
              hintText: "Confirmar senha",
              fillColor: Colors.grey.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 18),
          AuthButton(
            label: 'to Sign',
            colorText: Colors.white,
            colorButtom: Color(0xFFF37953),
            func: _signSubmit,
            isOutlined: false,
          ),
        ],
      ),
    );
  }
}
