import 'package:farefinder/src/models/client.dart';
import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:farefinder/src/providers/client_provider.dart';
import 'package:farefinder/src/utils/my_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:farefinder/src/utils/snackbar.dart' as utils;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


class ClienteRegisterController {
  late BuildContext context;
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  late AuthProvider _authProvider;
  late ClientProvider _clientProvider;
  late ProgressDialog _progressDialog;


  Future<void> init(BuildContext context) async {
    this.context = context;
     _authProvider = new AuthProvider();
    _clientProvider = new ClientProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context,'Espere un momento');
  }

  void register() async {
    final String username = usernameController.text;
    final String email = emailController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();
    final String password = passwordController.text.trim();

    print('Email: $email');
    print('Password: $password');

    if (username.isEmpty && email.isEmpty && password.isEmpty && confirmPassword.isEmpty) {
      print('Debe ingresar todos los campos');
     utils.Snackbar.showSnackbar(context, key, 'Debe ingresar todos los campos');
      return;
    }

    if (confirmPassword != password) {
       utils.Snackbar.showSnackbar(context, key, 'Las contraseñas no coinciden');
      return;
    }

    if (password.length < 6) {
      print('La contraseña debe tener al menos 6 caracteres');
     utils.Snackbar.showSnackbar(context, key, 'La contraseña debe tener al menos 6 caracteres');
      return;
    }

    _progressDialog.show();

    try {
      final bool isRegister = await _authProvider.register(email, password);

      if (isRegister) {
        final user = _authProvider.getUser();
        if (user != null) {
          final Client client = Client(
              id: user.uid,
              email: user.email?.trim() ?? '',
              username: username,
              password: password);

          await _clientProvider.create(client);
          _progressDialog.hide();
          utils.Snackbar.showSnackbar(context, key, 'El usuario se registró correctamente');
          print('El usuario se registró correctamente');
        } else {
          _progressDialog.hide();
          print('No se pudo obtener información del usuario');
        }
      } else {
        _progressDialog.hide();
        print('El usuario no se pudo registrar');
      }
    } catch (error) {
      _progressDialog.hide();
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
      print('Error: $error');
    }
  }
}

