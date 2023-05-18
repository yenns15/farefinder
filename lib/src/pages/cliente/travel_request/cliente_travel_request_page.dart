import 'package:farefinder/src/pages/cliente/travel_request/cliente_travel_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:farefinder/src/utils/colors.dart' as utils;
import 'package:farefinder/src/widget/button_app.dart';
import 'package:lottie/lottie.dart';

class ClienteTravelRequestPage extends StatefulWidget {
  const ClienteTravelRequestPage({super.key});

  @override
  State<ClienteTravelRequestPage> createState() =>
      _ClienteTravelRequestPageState();
}

class _ClienteTravelRequestPageState extends State<ClienteTravelRequestPage> {
  ClienteTravelRequestController _con = new ClienteTravelRequestController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
         
          _driverInfo(),
          _lottieAnimation(),
          _textLookingFor(),
          _textCounter(),
          Container(
            height: 50,
            color: Colors.amber,
            margin: EdgeInsets.all(30),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.only(left: 20,right: 20),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
            },
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.black),),
            ),
          )
        ],
      ),
    );
  }

Widget _buttonCancel() {
    return Container(
      height: 50,
      margin: EdgeInsets.all(30),
      child: ButtonApp(
        text: 'Cancelar viaje',
        color: Colors.amber,
        icon: Icons.cancel_outlined,
        textColor: Colors.black,
        onPressed: () { Navigator.pop(context);},
      ),
    );
  }
  
  

  Widget _textCounter() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Text(
        '0',
        style: TextStyle(fontSize: 30),
      ),
    );
  }

  Widget _lottieAnimation() {
    return Lottie.asset('assets/json/car-control.json',
        width: MediaQuery.of(context).size.width * 0.70,
        height: MediaQuery.of(context).size.height * 0.35,
        fit: BoxFit.fill);
  }

  Widget _textLookingFor() {
    return Container(
      child: Text(
        'Buscando conductor',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _driverInfo() {
    return ClipPath(
      clipper: WaveClipperOne(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        color: utils.colors.farefinder,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/img/profile.jpg'),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Tu Conductor',
                maxLines: 1,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
