import 'package:farefinder/src/pages/conductor/map/conductor_map_controller.dart';
import 'package:farefinder/src/utils/colors.dart';
import 'package:farefinder/src/widget/button_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConductorMapPage extends StatefulWidget {
  @override
  State<ConductorMapPage> createState() => _ConductorMapPageState();
}

class _ConductorMapPageState extends State<ConductorMapPage> {
  ConductorMapController _con = new ConductorMapController();

  @override
  void initState() {
    super.initState();
    _con.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                _buttonDrawer(),
                _buttonCenterPosition()
                  ],
                ),
                Expanded(child: Container()),
                _ButtonConnect(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonCenterPosition() {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
      shape: CircleBorder(),
      color: Colors.white,
      elevation: 4.0,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.location_searching, 
          color: Colors.grey[600],
          size: 20,
          ),
      ),
    )
    );
  }

  Widget _buttonDrawer() {
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _ButtonConnect() {
    return Container(
      height: 50,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          primary: Colors.amber,
          onPrimary: Colors.black,
        ),
        child: Text('CONECTARSE'),
      ),
    );
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
    );
  }
}
