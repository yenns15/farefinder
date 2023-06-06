import 'package:farefinder/src/pages/cliente/map/cliente_map_controller.dart';
import 'package:farefinder/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClienteMapPage extends StatefulWidget {
  const ClienteMapPage({super.key});

  @override
  State<ClienteMapPage> createState() => _ClienteMapPageState();
}

class _ClienteMapPageState extends State<ClienteMapPage> {
  ClienteMapController _con = new ClienteMapController();

  @override
  void initState() {
    super.initState();
    
     SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
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
                _buttonDrawer(),
                _cardGooglePlaces(),
                _buttonChangeTo(),
                _buttonCenterPosition(),
                Expanded(child: Container()),
                _ButtonConnect(),
              ],
            ),
          ),
          Align(
            //tener en cuenta
            alignment: Alignment.center,
            child: _iconMyLocation(),
          )
        ],
      ),
    );
  }

  //icono de localizacion
  Widget _iconMyLocation() {
    return Image.asset(
      'assets/img/my_location.png',
      width: 65,
      height: 65,
    );
  }

  //contenedor lateral donde estara toda la informacion basica del usuario
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
                  _con.cliente?.username ?? 'Nombre de usuario',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                )),
                Container(
                    child: Text(
                  _con.cliente?.email ?? 'Correo electronico',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                )),
                SizedBox(height: 10),
                CircleAvatar(
                  backgroundImage: _con.cliente?.image != null
                     ? NetworkImage(_con.cliente!.image)
                     : AssetImage('assets/img/profile.jpg') as ImageProvider,
                  radius: 40,
                )
              ],
            ),
            decoration: BoxDecoration(color: Colors.black),
          ),
          ListTile(
            title: Text('Editar perfil'),
            trailing: Icon(Icons.edit),
            // leading: Icon(Icons.cancel),

            onTap: _con.goToEditarPage,
          ),
          ListTile(
            title: Text('Hstorial de viajes'),
            trailing: Icon(Icons.timer),
            // leading: Icon(Icons.cancel),

            onTap: _con.goToHistoryPage,
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

  //centrar la posicion a la ubicacion actual
  Widget _buttonCenterPosition() {
    return GestureDetector(
      onTap: _con.centerPosition,
      child: Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.symmetric(horizontal: 18),
          child: Card(
            shape: CircleBorder(),
            color: Colors.white,
            elevation: 4.0,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.location_searching,
                color: Colors.black,
                size: 20,
              ),
            ),
          )),
    );
  }

  Widget _buttonChangeTo() {
    return GestureDetector(
      onTap: _con.changeFromTO,
      child: Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.symmetric(horizontal: 18),
          child: Card(
            shape: CircleBorder(),
            color: Colors.white,
            elevation: 4.0,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.refresh,
                color: Colors.black,
                size: 20,
              ),
            ),
          )),
    );
  }

  //boton para desplzar la barra lateral
  Widget _buttonDrawer() {
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: _con.openDrawer,
        icon: Icon(
          Icons.menu,
          color: Colors.black,
        ),
      ),
    );
  }

  //boton donde solicitara un servicio
  Widget _ButtonConnect() {
    return Container(
      height: 50,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: ElevatedButton(
        onPressed: _con.requestDriver,
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: _con.isConnect ? Colors.grey[300] : Colors.black,
        ),
        child: const Text('SOLICITAR'),
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
      onCameraMove: (position) {
        _con.initialPosition = position;
        print('ON CAMERA MOVE: $position');
      },
      onCameraIdle: () async {
        await _con.setLocationDraggableInfo();
      },
    );
  }

  //tarjeta de direcciones
  Widget _cardGooglePlaces() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoCardLocation('Desde', _con.from ?? 'Lugar de recogida', () async {
                await _con.showGoogleAutoComplete(true);
              }),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                child: Divider(
                  color: Colors.grey,
                  height: 10,
                ),
              ),
              SizedBox(height: 5),
              _infoCardLocation('Hasta', _con.to ?? 'Lugar de destino', () async {
                await _con.showGoogleAutoComplete(false);
              }),
            ],
          ),
        ),
      ),
    );
  }



  Widget _infoCardLocation(String title, String value, void Function() function) {
  return GestureDetector(
    onTap: function,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 12),
          textAlign: TextAlign.start,
        ),
        Text(
          value,
          style: TextStyle(color: Colors.black, fontSize: 14),
          maxLines: 2,
        ),
      ],
    ),
  );
}


  void refresh() {
    setState(() {});
  }
}
