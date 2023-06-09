import 'package:farefinder/src/pages/conductor/travel_request/conductor_travel_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:farefinder/src/utils/colors.dart' as utils;
import 'package:farefinder/src/widget/button_app.dart';

class ConductorTravelRequestPage extends StatefulWidget {
  const ConductorTravelRequestPage({super.key});

  @override
  State<ConductorTravelRequestPage> createState() =>
      _ConductorTravelRequestPageState();
}

class _ConductorTravelRequestPageState
    extends State<ConductorTravelRequestPage> {
  ConductorTravelRequestController _con =
      new ConductorTravelRequestController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _con.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        _bannerClientInfo(),
        _textFromTo(_con.from ?? '', _con.to ?? ''),
        _textTimeLimit(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              color: Colors.black,
              margin: EdgeInsets.all(30),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextButton(
                onPressed: _con.cancelTravel,
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 10), 
            Container(
              height: 50,
              color: Colors.black,
              margin: EdgeInsets.all(30),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextButton(
                onPressed: _con.acceptTravel,
                child: Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


  Widget _buttonsAction() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            child: ButtonApp(
              onPressed: _con.cancelTravel,
              text: 'Cancelar',
              color: Colors.red,
              textColor: Colors.white,
              icon: Icons.cancel_outlined,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            child: ButtonApp(
              onPressed: _con.acceptTravel,
              text: 'Aceptar',
              color: Colors.cyan,
              textColor: Colors.white,
              icon: Icons.check,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textTimeLimit() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Text(
        _con.seconds.toString(),
        style: TextStyle(fontSize: 50),
      ),
    );
  }

  Widget _textFromTo(String from, String to) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Lugar de origen',
            style: TextStyle(fontSize: 20),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              from,
              style: TextStyle(fontSize: 17),
              maxLines: 2,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Lugar de destino',
            style: TextStyle(fontSize: 20),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              to,
              style: TextStyle(fontSize: 17),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bannerClientInfo() {
    return ClipPath(
      clipper: WaveClipperOne(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: double.infinity,
        color: utils.colors.farefinder,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
             backgroundImage:  _con.imageFile != null ?
               FileImage(_con.imageFile!) :
               _con.client?.image != null
                   ? NetworkImage(_con.client!.image)
                   : AssetImage('assets/img/profile.jpg') as ImageProvider,
                radius: 50,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Text(
                _con.client?.username ?? '',
                style: TextStyle(fontSize: 17, color: Colors.white),
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
