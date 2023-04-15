import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';

class RegisterController {
  late BuildContext context;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();

  AuthProvider _authProvider;

  RegisterController({required AuthProvider authProvider})
      : _authProvider = authProvider;

  Future<void> init(BuildContext context) async {
    this.context = context;
  }

  void register() async {
    String username = usernameController.text;
    String email = emailController.text.trim();
    String confirmPassword = ConfirmPasswordController.text.trim();
    String password = passwordController.text.trim();

    print('Email: $email');
    print('Password: $password');

    if (username.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty) {
      print('debe ingresar todos los campos');
      return;
    }

    if (confirmPassword != password) {
      print('Las contraseñas no coinciden');
      return;
    }

    if (password.length < 6) {
      print('la contraseña debe tener al menos 6 caracteres');
      return;
    }

    try {
      bool isRegister = await _authProvider.register(email, password);

      if (isRegister) {
        print('El usuario se registro correctamente');
      } else {
        print('El usuario no se pudo registrar');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
