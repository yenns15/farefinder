import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:farefinder/src/utils/my_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:farefinder/src/utils/snackbar.dart' as utils;

class LoginController {
  late BuildContext context;
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthProvider _authProvider;
  late ProgressDialog _progressDialog;

  LoginController({required AuthProvider authProvider})
      : _authProvider = authProvider {
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Espere un momento');
  }

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
    _progressDialog.show();
    try {
      bool isLogin = await _authProvider.login(email, password);
      _progressDialog.hide();
      if (isLogin) {
        print('El usuario esta logeado');
        utils.Snackbar.showSnackbar(context, key, 'El usuario esta logeado');
      } else {
          utils.Snackbar.showSnackbar(context, key, 'El usuario no se pudo autenticar');
        print('El usuario no se pudo autenticar');
      }
    } catch (error) {
        utils.Snackbar.showSnackbar(context, key, 'Error: $error');
      _progressDialog.hide();
      print('Error: $error');
    }
  }
}
