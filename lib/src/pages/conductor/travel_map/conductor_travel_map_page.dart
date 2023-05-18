import 'package:farefinder/src/pages/conductor/travel_map/conductor_travel_map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ConductorTravelMapPage extends StatefulWidget {
  const ConductorTravelMapPage({super.key});

  @override
  State<ConductorTravelMapPage> createState() => _ConductorTravelMapPageState();
}

class _ConductorTravelMapPageState extends State<ConductorTravelMapPage> {
  ConductorTravelMapController _con = new ConductorTravelMapController();

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
        child: Text('PANTALLA DEL MAPA DEL CONDUCTOR'),
      ),
    );
  }
  void refresh(){
    setState(() {
      
    });
  }
}
