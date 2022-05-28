import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/custom/custom_auth_page.dart';
import 'package:shop_app/pages/auth/Form/auth_form_sign.dart';
import 'package:shop_app/providers/auth.dart';

class AuthSignPage extends StatelessWidget {
  const AuthSignPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var auth = Provider.of<Auth>(context);
    return Scaffold(
      body: auth.inProgress
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
                      child: AuthFormSign(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
