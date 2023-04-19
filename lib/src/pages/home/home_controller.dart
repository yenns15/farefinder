import 'package:farefinder/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class HomeController {


  late BuildContext context;
  late SharedPref _sharedPref;


   void init(BuildContext context) {
    this.context = context;
    _sharedPref = new SharedPref();
  }

  void goToLoginPage(String typeUser) {
    saveTypeUser(typeUser);
    Navigator.pushNamed(context, 'login');
  }

  void saveTypeUser(String typeUser) async {
      _sharedPref.save('typeUser', typeUser);
  }

}
