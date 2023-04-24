import 'package:farefinder/src/models/client.dart';
import 'package:farefinder/src/models/conductor.dart';
import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:farefinder/src/providers/client_provider.dart';
import 'package:farefinder/src/providers/conductor_provider.dart';
import 'package:farefinder/src/utils/my_progress_dialog.dart';
import 'package:farefinder/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:farefinder/src/utils/snackbar.dart' as utils;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class LoginController {
  late BuildContext context;
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthProvider _authProvider;
  late ProgressDialog _progressDialog;
  late ConductorProvider _conductorProvider;
  late ClientProvider _clientProvider;

  late SharedPref _sharedPref;
  late String _typeUser;

  LoginController({required AuthProvider authProvider})
      : _authProvider = authProvider;

  Future<void> init(BuildContext context) async {
    this.context = context;
    _authProvider = new AuthProvider();
    _conductorProvider = new ConductorProvider();
    _clientProvider = new ClientProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Espere un momento');
    _sharedPref = new SharedPref();
    _typeUser = await _sharedPref.read('typeUser');

    print('======= TIPO DE USUARIO =======');
    print(_typeUser);
  }

  void goToRegisterPage() async {
    _typeUser = await _sharedPref.read('typeUser');

    if (_typeUser == 'cliente') {
      Navigator.pushNamed(context, 'cliente/register');
    } else {
      Navigator.pushNamed(context, 'conductor/register');
    }
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

        if (_typeUser == 'cliente') {
          Client? client =
              await _clientProvider.getById(_authProvider.getUser()!.uid);
               print('Cliente : $client');

          if (client != null) {
            Navigator.pushNamedAndRemoveUntil(
                context, 'cliente/map', (route) => false);
          } else {
            utils.Snackbar.showSnackbar(
                context, key, 'El usuario no es valido');
            await _authProvider.signOut();
          }
        } else if (_typeUser == 'conductor') {
          Conductor? conductor =
              await _conductorProvider.getById(_authProvider.getUser()!.uid);
              print('Conductor : $conductor');

          if (conductor != null) {
            Navigator.pushNamedAndRemoveUntil(
                context, 'conductor/map', (route) => false);
          } 
          else {
            utils.Snackbar.showSnackbar( context, key, 'El usuario no es valido');
            await _authProvider.signOut();
          }
        }
      } 
      else {
        utils.Snackbar.showSnackbar(
            context, key, 'El usuario no se pudo autenticar');
        print('El usuario no se pudo autenticar');
      }
    } catch (error) {
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
      _progressDialog.hide();
      print('Error: $error');
    }
  }
}
