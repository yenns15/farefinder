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
    _con.init(context, refresh);
  }

  void dispose() {
    super.dispose();
    print('se ejecuto el dispose');
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      drawer: _drawer(),
      body: Stack(
        children: [
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buttonDrawer(), _buttonCenterPosition()],
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

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: Text(
                  _con.conductor?.username?? 'Nombre de usuario',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                )),
                Container(
                    child: Text(
                  _con.conductor?.email ?? 'Correo electronico',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                )),
                SizedBox(height: 10),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/img/profile.jpg'),
                  radius: 40,
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.amber
            ),
          ),
          ListTile(
            title: Text('Editar perfil'),
            trailing: Icon(Icons.edit),
           // leading: Icon(Icons.cancel),

            onTap: _con.goToEditarPage,
          ),
           ListTile(
            title: Text('Cerrar sesión'),
            trailing: Icon(Icons.power_settings_new),
           // leading: Icon(Icons.cancel),
           onTap: _con.singOut,
          ),
        ],
      ),
    );
  }

  Widget _buttonCenterPosition() {
    return GestureDetector(
      onTap: _con.centerPosition,
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

  Widget _buttonDrawer() {
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: _con.openDrawer,
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
        onPressed: _con.connect,
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.black,
          primary: _con.isConnect ? Colors.grey[300] : Colors.amber,
        ),
        child: Text(_con.isConnect ? 'DESCONECTARSE' : 'CONECTARSE'),
      ),
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
    );
  }

  void refresh() {
    setState(() {});
  }
}
