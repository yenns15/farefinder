import 'package:farefinder/src/providers/auth_provider.dart' show AuthProvider;
import 'package:farefinder/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class HomeController {


  late BuildContext context;
  late SharedPref _sharedPref;
  late AuthProvider _authProvider;
  late String _typeUser;

   void init(BuildContext context) async {
  this.context = context;
  _sharedPref = new SharedPref();
  _authProvider = new AuthProvider();
  dynamic value = await _sharedPref.read('typeUser');
  if (value != null) {
    _typeUser = value.toString();
  } else {
    _typeUser = '';
 }
 checkIfUserIsAuth();
  }
  
  void checkIfUserIsAuth(){
    bool isSignedIn = _authProvider.isSignedIn();
    if(isSignedIn){
      print('Esta Logeado');
      if (_typeUser == 'cliente'){
          Navigator.pushNamedAndRemoveUntil(context, 'cliente/map',(route) => false);
        }
        else{
          Navigator.pushNamedAndRemoveUntil(context, 'conductor/map',(route) => false);
        }
    }
    else {
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
