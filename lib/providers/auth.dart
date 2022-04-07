import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  Future<void> authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyAxfZb7TpEZ_ksoj_GIXcIWC05QvH7Q2eY';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );
  }

  Future<void> signUp(String email, String password) async {
    authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    authenticate(email, password, 'signInWithPassword');
  }
}
