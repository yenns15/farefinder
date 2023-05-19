import 'package:farefinder/src/pages/cliente/travel_map/cliente_travel_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClienteTravelMapPage extends StatefulWidget {
  const ClienteTravelMapPage({super.key});

  @override
  State<ClienteTravelMapPage> createState() => _ClienteTravelMapPageState();
}

class _ClienteTravelMapPageState extends State<ClienteTravelMapPage> {
  ClienteTravelMapController _con = new ClienteTravelMapController();

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
      key: _con.key,
      body: Stack(
        children: [
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonUserInfo(),
                    Column(
                      children: [_cardKmInfo('0'), _cardMinInfo('0')],
                    ),
                    _buttonCenterPosition()
                  ],
                ),
                Expanded(child: Container()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _cardKmInfo(String km) {
    return SafeArea(
        child: Container(
      width: 110,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Text(
        '${km ?? ''} km',
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    ));
  }

  Widget _cardMinInfo(String min) {
    return SafeArea(
        child: Container(
      width: 110,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Text(
        '${min ?? ''} seg',
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    ));
  }

  Widget _buttonUserInfo() {
    return GestureDetector(
      onTap: () {},
      child: Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Card(
            shape: CircleBorder(),
            color: Colors.white,
            elevation: 4.0,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.person,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
          )),
    );
  }

  Widget _buttonCenterPosition() {
    return GestureDetector(
      onTap: () {},
      child: Container(
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
          )),
    );
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,
    );
  }

  void refresh() {
    setState(() {});
  }
}
