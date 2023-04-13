import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            ClipPath(
              clipper: DiagonalPathClipperTwo(),
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/img/logo_app.png',
                      width: 150,
                      height: 100,
                    ),
                    Text('Facil y Rapido')
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Text(
              'SELECIONA TU ROL',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 30),
            CircleAvatar(
              backgroundImage: AssetImage('assets/img/pasajero.png'),
              radius: 50,
              backgroundColor: Colors.grey[900],
            ),
            SizedBox(height: 10),
            Text(
              'Cliente',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 30),
            CircleAvatar(
              backgroundImage: AssetImage('assets/img/driver.png'),
              radius: 50,
              backgroundColor: Colors.grey[900],
            ),
            SizedBox(height: 10),
            Text(
              'Conductor',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
