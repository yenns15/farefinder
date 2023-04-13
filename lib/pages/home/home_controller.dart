import 'package:flutter/material.dart';

class HomeController {
 late BuildContext context;
  Future? init(BuildContext context) {
    this.context = context;
  }

  void goToLoginPage() {
    Navigator.pushNamed(context, 'login');
  }
}
