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
              'Conductor'
            ),
             SizedBox(height: 50),
            _creadores(),
             SizedBox(height: 10),
             _yulith(),
              SizedBox(height: 10),
              _elian(),
               SizedBox(height: 10),
               _yenns(),
                SizedBox(height: 10),
                _universidad()


          ],
        ),
      ),
    );
  }

Widget _bannerApp(BuildContext context) {
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

  Widget _creadores() {
    return const Text(
      'CREADO POR:',
      style: TextStyle(color: Colors.black),
    );
  }

 Widget _yulith() {
    return const Text(
      'YULITH CARRASCAL',
      style: TextStyle(color: Colors.black),
    );
  }
  Widget _elian() {
    return const Text(
      'ELIAN FRAGOZO',
      style: TextStyle(color: Colors.black),
    );
  }
  
  Widget _yenns() {
    return const Text(
      'YENNS NOYA',
      style: TextStyle(color: Colors.black),
    );
  }
  Widget _universidad() {
    return const Text(
      'UNIVERSIDAD POPULAR DEL CESAR ',
      style: TextStyle(color: Colors.black),
    );
  }
}
