import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/auth/auth_login_page.dart';
import 'package:shop_app/pages/products_overview_pages.dart';
import 'package:shop_app/providers/auth.dart';

class AuthOrHome extends StatelessWidget {
  const AuthOrHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return auth.isAuth ? ProductOverviewPage() : AuthLoginPage();
  }
}
