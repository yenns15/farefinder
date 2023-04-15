import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';

class LoginController {
  late BuildContext context;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthProvider _authProvider;

  LoginController({required AuthProvider authProvider})
      : _authProvider = authProvider;

  Future<void> init(BuildContext context) async {
    this.context = context;
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context, 'register');
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    print('Email: $email');
    print('Password: $password');
    try {
      bool isLogin = await _authProvider.login(email, password);

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
