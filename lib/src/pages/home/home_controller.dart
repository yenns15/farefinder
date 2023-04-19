import 'package:farefinder/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class HomeController {
 late BuildContext context;
 late SharedPref _sharedPref;
  Future? init(BuildContext context) {
    this.context = context;
    _sharedPref = new SharedPref();
    return null;
  }

  void goToLoginPage(String typeUser) {
    saveTypeUser(typeUser);
    Navigator.pushNamed(context, 'login');
  }

  void saveTypeUser(String typeUser) {
     _sharedPref.save('typeUser', typeUser);
  }

}
