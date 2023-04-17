import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthProvider() {
    _initFirebaseAuth();
  }

  Future<void> _initFirebaseAuth() async {
    _firebaseAuth = FirebaseAuth.instance;
  }

  User? getUser() {
    return _firebaseAuth.currentUser;
  }

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







}





