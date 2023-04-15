import 'package:farefinder/src/pages/login/login_controller.dart';
import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:farefinder/src/widget/button_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:farefinder/src/utils/colors.dart' as utils;


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  LoginController _con = new LoginController(authProvider: AuthProvider());
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    print('INIT STATE');

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
     _con.init(context);
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromARGB(255, 7, 7, 7),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _bannerApp(),
              _textLogin(),
             SizedBox(
              height: MediaQuery.of(context).size.height * 0.17
              ),
              _textFieldEmail(),
              _textFieldPassword(),
              _buttonLogin(),
              _textDontHaveAccount(),
            ],
          ),
        ));
  }

  Widget _textDontHaveAccount() {
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      child: Text(
        'No tienes cuenta?',
        style: TextStyle(fontSize: 15, color: Colors.grey),
      ),
    );
  }

  Widget _buttonLogin() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.login,
        text: 'Iniciar Sesión',
        color: utils.colors.farefinder,
        textColor: Colors.white,
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.emailController,
        decoration: InputDecoration(
            hintText: 'correo@gmail.com',
            labelText: 'Correo Electronico',
            suffixIcon: Icon(
              Icons.email_outlined,
              color: utils.colors.farefinder,
            )),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
            labelText: 'Contraseña',
            suffixIcon: Icon(
              Icons.lock_open_outlined,
              color: utils.colors.farefinder,
            )),
      ),
    );
  }

  Widget _textLogin() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Iniciar sesión',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
      ),
    );
  }

  Widget _bannerApp() {
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        color: utils.colors.farefinder,
        height: MediaQuery.of(context).size.height * 0.15,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/img/logo_app.png',
              width: 150,
              height: 100,
            ),
            const Text('Nuestro servicio tu destino',
                style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }
}
