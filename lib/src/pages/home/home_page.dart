import 'package:farefinder/src/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class HomePage extends StatefulWidget {

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController _con = new HomeController();

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _bannerApp(context),
            SizedBox(height: 50),
            _textSelectYourRol(),
            SizedBox(height: 30),
            _imageTypeUser(context, 'assets/img/pasajero.png', 'cliente'),
            SizedBox(height: 10),
            _textTypeUser('Cliente'),
            SizedBox(height: 30),
            _imageTypeUser(context, 'assets/img/conductor.png','conductor'),
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
      child: FittedBox(
        fit: BoxFit.fill,
        child: Image.asset(
          'assets/img/logos_app.png',
        ),
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

  Widget _imageTypeUser(BuildContext context, String image, String typeUser) {
    return GestureDetector(
        onTap: () => _con.goToLoginPage(typeUser),
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
