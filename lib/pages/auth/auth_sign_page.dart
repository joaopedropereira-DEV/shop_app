import 'package:flutter/material.dart';
import 'package:shop_app/pages/auth/Form/auth_form_sign.dart';
import '../custom/custom_auth_page.dart';

class AuthSignPage extends StatefulWidget {
  const AuthSignPage({Key? key}) : super(key: key);

  @override
  State<AuthSignPage> createState() => _AuthSignPageState();
}

class _AuthSignPageState extends State<AuthSignPage> {
  bool _isLoading = false;

  void _onLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _offLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Column(
                  children: <Widget>[
                    CustomPageAuth(
                      sizeHeight: deviceSize.height * 0.4,
                      sizeWidth: deviceSize.width,
                      label: 'Sign in',
                      image: "assets/icons/illustration.png",
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: AuthFormSign(
                        onLoading: _onLoading,
                        offLoading: _offLoading,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
