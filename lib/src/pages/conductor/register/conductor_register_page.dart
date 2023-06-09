import 'package:farefinder/src/pages/conductor/register/conductor_register_controller.dart';
import 'package:farefinder/src/utils/otp_widget.dart';
import 'package:farefinder/src/widget/button_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:farefinder/src/utils/colors.dart' as utils;

class ConductorRegisterPage extends StatefulWidget {
  const ConductorRegisterPage({super.key});


  @override
  _ConductorRegisterPageState createState() => _ConductorRegisterPageState();
}

class _ConductorRegisterPageState extends State<ConductorRegisterPage> {

  ConductorRegisterController _con = new ConductorRegisterController();


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
      key: _con.key,
      appBar: AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Color.fromARGB(255, 7, 7, 7),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _bannerApp(),
              SizedBox(height: 30),
              _textLogin(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              _textLicencePlate(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: OTPFields(
                  pin1: _con.pin1Controller,
                  pin2: _con.pin2Controller,
                  pin3: _con.pin3Controller,
                  pin4: _con.pin4Controller,
                  pin5: _con.pin5Controller,
                  pin6: _con.pin6Controller,
                ),
              ),
              _textFieldUsername(),
              _textFieldEmail(),
              _textFieldPassword(),
              _textFieldConfirmPassword(),
              _buttonRegister(),
            ],
          ),
        ));
  }

  Widget _buttonRegister() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.register,
        text: 'Registrarse ahora',
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

  Widget _textFieldUsername() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        controller: _con.usernameController,
        decoration: InputDecoration(
            hintText: 'Tu Nombre',
            labelText: 'Nombre de usuario',
            suffixIcon: Icon(
              Icons.person_outlined,
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

  Widget _textFieldConfirmPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        controller: _con.confirmPasswordController,
        obscureText: true,
        decoration: InputDecoration(
            labelText: 'Confirmar Contraseña',
            suffixIcon: Icon(
              Icons.lock_open_outlined,
              color: utils.colors.farefinder,
            )),
      ),
    );
  }


  Widget _textLicencePlate(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Placa Del Vehiculo',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 17
        ),

      ),
    );
  }

  Widget _textLogin() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Registro Conductor',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
      ),
    );
  }

 Widget _bannerApp() {
  return Container(
    color: Colors.black,
    height: MediaQuery.of(context).size.height * 0.20,
    child: FittedBox(
      fit: BoxFit.fill,
      child: Image.asset(
        'assets/img/logos_app.png',
      ),
    ),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.transparent, // Cambiar el color del borde inferior aquí si es necesario
          width: 1.0, // Cambiar el ancho del borde inferior aquí si es necesario
        ),
      ),
    ),
  );
}
}