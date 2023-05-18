import 'package:farefinder/src/pages/cliente/travel_map/cliente_travel_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
      body: Center(
        child: Text('PANTALLA DEL MAPA DEL CLIENTE '),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
