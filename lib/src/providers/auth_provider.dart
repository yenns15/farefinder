import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthProvider() {
    _initFirebaseAuth();
  }

  Future<void> _initFirebaseAuth() async {
    _firebaseAuth = FirebaseAuth.instance;
  }
  //Obtener el usuario actual 
  User? getUser() {
    return _firebaseAuth.currentUser;
  }
  //Comprobar si el usuario está registrado
  bool isSignedIn() {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    return false;
  } else {
    return true;
  }
}

   //Compruebe si el usuario ha iniciado sesión y rediríjalo a la página adecuada
  void CheckIfUserIsLogged(BuildContext context, String typeUser ){
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null){

        if (typeUser == 'cliente'){
          Navigator.pushNamedAndRemoveUntil(context, 'cliente/map',(route) => false);
        }
        else{
          Navigator.pushNamedAndRemoveUntil(context, 'conductor/map',(route) => false);
        }
        print('El usuario esta logeado');
      }
      else {
        print('El usuario no esta logeado');
      }
     });
  }
  //Iniciar sesión como usuario usando correo electrónico y contraseña
  Future<bool> login(String email, String password) async {
    String? errorMessage;

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      print(error);
      errorMessage = error.toString();
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
    return true;
  }
   //Registrar un usuario usando correo electrónico y contraseña
  Future<bool> register(String email, String password) async {
    String? errorMessage;

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      print(error);
      errorMessage = error.toString();
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
    return true;
  }
  //Cerrar sesión del usuario actual 
   Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  }






