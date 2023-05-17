import 'package:farefinder/src/providers/auth_provider.dart' show AuthProvider;
import 'package:farefinder/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class HomeController {
  late BuildContext context;
  late SharedPref _sharedPref;
  late AuthProvider _authProvider;
  late String _typeUser;
  late String _isNotification;

  Future init(BuildContext context) async {
    this.context = context;
    _sharedPref = new SharedPref();
    _authProvider = new AuthProvider();

    _typeUser = await _sharedPref.read('typeUser');
    _isNotification = await _sharedPref.read('isNotification');
    checkIfUserIsAuth();
  }

  void checkIfUserIsAuth() {
    bool isSignedIn = _authProvider.isSignedIn();
    if (isSignedIn) {
      if (_isNotification != 'true') {
if (_typeUser == 'cliente') {
        Navigator.pushNamedAndRemoveUntil(
            context, 'cliente/map', (route) => false);
        //Navigator.pushNamed(context, 'cliente/map');
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, 'conductor/map', (route) => false);
        // Navigator.pushNamed(  context, 'conductor/map');
      }

      }
      
    } else {
      print('No esta Logeado');
    }
  }

  void goToLoginPage(String typeUser) {
    saveTypeUser(typeUser);
    Navigator.pushNamed(context, 'login');
  }

  void saveTypeUser(String typeUser) {
    _sharedPref.save('typeUser', typeUser);
  }
}
