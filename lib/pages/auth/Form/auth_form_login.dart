import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/auth/Form/Validator/email_validator.dart';
import 'package:shop_app/pages/auth/Form/Validator/password_validator.dart';

import '../../../components/auth_button.dart';
import '../../../providers/auth.dart';

class AuthFormLogin extends StatefulWidget {
  AuthFormLogin({
    Key? key,
    required this.onLoading,
    required this.offLoading,
  }) : super(key: key);

  final void Function() onLoading;
  final void Function() offLoading;

  @override
  State<AuthFormLogin> createState() => _AuthFormLoginState();
}

class _AuthFormLoginState extends State<AuthFormLogin> {
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final _loginKey = GlobalKey<FormState>();
  Map<String, String> _authLoginData = {"email": '', "password": ''};

  Future<void> _loginSubmit() async {
    bool isValid = _loginKey.currentState?.validate() ?? false;

    if (!isValid) return;

    widget.onLoading();

    _loginKey.currentState?.save();

    // Provider
    Auth auth = Provider.of<Auth>(context, listen: false);

    // Processo de Login
    await auth.signUp(
      _authLoginData["email"]!,
      _authLoginData["password"]!,
    );

    widget.offLoading();
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            onSaved: (email) => _authLoginData["email"] = email ?? "",
            validator: (_email) {
              final email = _email ?? "";
              EmailValidator.validEmail(email);
            },
            focusNode: _emailFocus,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              hintText: "Email",
              //suffixIcon: Icon(Icons.check),
            ),
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocus);
            },
          ),
          SizedBox(
            height: 18,
          ),
          TextFormField(
            cursorColor: Color(0xFFF37953).withOpacity(0.5),
            onSaved: (password) => _authLoginData["password"] = password ?? "",
            validator: (_password) {
              final password = _password ?? "";
              ValidatorPassword.validPassword(password);
            },
            focusNode: _passwordFocus,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              hintText: "Senha",
              //suffixIcon: Icon(Icons.check),
            ),
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus();
            },
          ),
          SizedBox(
            height: 40,
          ),
          AuthButton(
            label: 'Login',
            colorText: Colors.white,
            colorButtom: Color(0xFFF37953),
            func: _loginSubmit,
            isOutlined: false,
          ),
        ],
      ),
    );
  }
}
