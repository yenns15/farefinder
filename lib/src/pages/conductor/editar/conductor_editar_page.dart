import 'package:farefinder/src/pages/conductor/editar/conductor_editar_controller.dart';
import 'package:farefinder/src/utils/otp_widget.dart';
import 'package:farefinder/src/widget/button_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:farefinder/src/utils/colors.dart' as utils;

class ConductorEditarPage extends StatefulWidget {
  const ConductorEditarPage({super.key});

  @override
  _ConductorEditarPageState createState() => _ConductorEditarPageState();
}

class _ConductorEditarPageState extends State<ConductorEditarPage> {
  ConductorEditarController _con = new ConductorEditarController();

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
    body: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _bannerApp(),
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
              ],
            ),
          ),
        ),
        _buttonRegister(),
      ],
    ),
  );
}

Widget _buttonRegister() {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: double.infinity, // Ancho máximo disponible
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: ElevatedButton(
        onPressed: _con.register,
        child: Text(
          'Actualizar',
          style: TextStyle(color: Colors.white),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(utils.colors.farefinder),
        ),
      ),
    ),
  );
}



  Widget _textFieldUsername() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        controller: _con.usernameController,
        decoration: InputDecoration(
            hintText: 'Yenns Noya',
            labelText: 'Nombre de usuario',
            suffixIcon: Icon(
              Icons.person_outlined,
              color: utils.colors.farefinder,
            )),
      ),
    );
  }

  Widget _textLicencePlate() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Placa Del Vehiculo',
        style: TextStyle(color: Colors.grey[600], fontSize: 17),
      ),
    );
  }

  Widget _textLogin() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Editar Perfil',
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
            CircleAvatar(
              backgroundImage: AssetImage('assets/img/profile.jpg'),
              radius: 50,
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text('Nuestro servicio tu destino',
                  style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
