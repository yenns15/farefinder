import 'package:farefinder/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class HomePage extends StatelessWidget {
  HomeController _con = new HomeController();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    _con.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _bannerApp(context),
            SizedBox(height: 50),
            _textSelectYourRol(),
            SizedBox(height: 30),
            _imageTypeUser(context, 'assets/img/pasajero.png'),
            SizedBox(height: 10),
            _textTypeUser('Cliente'),
            SizedBox(height: 30),
            _imageTypeUser(context, 'assets/img/driver.png'),
            SizedBox(height: 10),
            _textTypeUser(
              'Conductor',
            )
          ],
        ),
      ),
    );
  }

  Widget _bannerApp(BuildContext context) {
    return ClipPath(
      clipper: DiagonalPathClipperTwo(),
      child: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height * 0.30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/img/logo_app.png',
              width: 150,
              height: 100,
            ),
            Text('Nuestro servicio tu destino',
                style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _textSelectYourRol() {
    return Text(
      'SELECCIONA TU ROL',
      style: TextStyle(color: Colors.black),
    );
  }

  Widget _imageTypeUser(BuildContext context, String image) {
    return GestureDetector(
        onTap: _con.goToLoginPage,
        child: CircleAvatar(
          backgroundImage: AssetImage(image),
          radius: 50,
          backgroundColor: Colors.grey[900],
        ));
  }

  Widget _textTypeUser(String typeUser) {
    return Text(
      typeUser,
      style: TextStyle(color: Colors.black),
    );
  }
}
