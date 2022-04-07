import 'package:flutter/material.dart';
import 'package:shop_app/components/auth_button.dart';
import 'package:shop_app/pages/auth/Form/auth_form_login.dart';
import 'package:shop_app/utils/app_routes.dart';

import '../custom/custom_auth_page.dart';

class AuthLoginPage extends StatefulWidget {
  AuthLoginPage({Key? key}) : super(key: key);

  @override
  State<AuthLoginPage> createState() => _AuthLoginPageState();
}

class _AuthLoginPageState extends State<AuthLoginPage> {
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
                      sizeHeight: deviceSize.height * 0.5,
                      sizeWidth: deviceSize.width,
                      image: "assets/icons/illustration.png",
                      label: "Login",
                    ),
                    SizedBox(height: deviceSize.height * 0.05),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: AuthFormLogin(
                          onLoading: _onLoading, offLoading: _offLoading),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                height: 0.5,
                                width: 150,
                                color: Colors.grey[600],
                              ),
                              Text(
                                "Or",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              Container(
                                height: 0.5,
                                width: 150,
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          AuthButton(
                            label: "Sign up",
                            colorButtom: Color(0xFFF37953),
                            colorText: Colors.grey,
                            isOutlined: true,
                            padding: 10,
                            func: () => Navigator.of(context)
                                .pushNamed(AppRoutes.AUTH_SIGNUP),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
