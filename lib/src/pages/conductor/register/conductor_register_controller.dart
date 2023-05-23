import 'package:farefinder/src/models/conductor.dart';
import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:farefinder/src/providers/conductor_provider.dart';
import 'package:farefinder/src/utils/my_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:farefinder/src/utils/snackbar.dart' as utils;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


class ConductorRegisterController {
  late BuildContext context;
   GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    TextEditingController pin1Controller = TextEditingController();
    TextEditingController pin2Controller = TextEditingController();
    TextEditingController pin3Controller = TextEditingController();
    TextEditingController pin4Controller = TextEditingController();
    TextEditingController pin5Controller = TextEditingController();
    TextEditingController pin6Controller = TextEditingController();


  late  AuthProvider _authProvider;
  late ConductorProvider _conductorProvider;
  late ProgressDialog _progressDialog;

  Future<void> init(BuildContext context) async {
    this.context = context;
    _authProvider = new AuthProvider();
    _conductorProvider = new ConductorProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context,'Espere un momento');
  }

  void register() async {
      String username = usernameController.text;
      String email = emailController.text.trim();
      String confirmPassword = confirmPasswordController.text.trim();
      String password = passwordController.text.trim();

      String pin1 = pin1Controller.text.trim();
      String pin2 = pin2Controller.text.trim();
      String pin3 = pin3Controller.text.trim();
      String pin4 = pin4Controller.text.trim();
      String pin5 = pin5Controller.text.trim();
      String pin6 = pin6Controller.text.trim();

      String plate = '$pin1$pin2$pin3-$pin4$pin5$pin6';

    

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
     bool isRegister = await _authProvider.register(email, password);

      if (isRegister) {

        final user = _authProvider.getUser();
        if (user != null) {
          Conductor conductor = Conductor(
              id: user.uid,
              email: user.email?.trim() ?? '',
              username: username,
              password: password,
              plate : plate, 
              token: '',
              image: ''
              );

          await _conductorProvider.create(conductor);
          _progressDialog.hide();
          Navigator.pushNamedAndRemoveUntil(context, 'conductor/map',(route) => false);

          utils.Snackbar.showSnackbar(context, key, 'El Conductor se registró correctamente');
          print('El Conductor se registró correctamente');
        } else {
          _progressDialog.hide();
          print('No se pudo obtener información del usuario');
        }
      } else {
        _progressDialog.hide();
        print('El Conductor no se pudo registrar');
      }
    } catch (error) {
      _progressDialog.hide();
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
      print('Error: $error');
    }
  }
}
