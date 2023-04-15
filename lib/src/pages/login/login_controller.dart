import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';

class LoginController {
  late BuildContext context;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

   late AuthProvider _authProvider;

  Future<void> init(BuildContext context) async {
    this.context = context;
  }

  void login() async {
    String email = emailController.text;
    String password = passwordController.text;

    print('Email: $email');
    print('Password: $password');
    try {
      bool isLogin =  await _authProvider.login(email, password);

      if (isLogin) {
        print('El usuario esta logeado');
      } else {
        print('El usuario no se pudo autenticar');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}

