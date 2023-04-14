import 'package:flutter/material.dart';

class LoginController{

 late BuildContext context;

 TextEditingController emailController = new TextEditingController();
 TextEditingController passwordController = new TextEditingController();

  Future <void> init (BuildContext context)async {
    this.context = context;
  }

  void login() {
    String email = emailController.text;
    String password = passwordController.text;

    print('Email: $email');
    print('Password: $password');
  }

}

