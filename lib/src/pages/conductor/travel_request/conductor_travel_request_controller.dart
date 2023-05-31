import 'dart:io';

import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:farefinder/src/providers/client_provider.dart';
import 'package:farefinder/src/providers/geofire_provider.dart';
import 'package:farefinder/src/providers/travel_info_provider.dart';
import 'package:farefinder/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:farefinder/src/models/client.dart';
import 'dart:async';

class ConductorTravelRequestController {
  late BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey();
  late Function refresh;
  late SharedPref _sharedPref;
  late String from;
  late String to;
  late String idCliente;
  late Client client;
  File? imageFile;

  late ClientProvider _clientProvider;
  late TravelInfoProvider _travelInfoProvider;
  late AuthProvider _authProvider;
  late GeofireProvider _geofireProvider;

  late Timer _timer;
  int seconds = 30;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _sharedPref = new SharedPref();
    _sharedPref.save('isNotification', 'false');

    _clientProvider = new ClientProvider();
    _travelInfoProvider = new TravelInfoProvider();
    _authProvider = new AuthProvider();
    _geofireProvider = new GeofireProvider();

    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    print('Arguments: $arguments');

    from = arguments['origin'];
    to = arguments['destination'];
    idCliente = arguments['idClient'];

    getClienteInfo();
    starTimer();
  }

  void dispose() {
    _timer?.cancel();
  }

  void starTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds = seconds - 1;
      refresh();
      if (seconds == 0) {
        cancelTravel();
      }
    });
  }

  void acceptTravel() {
    Map<String, dynamic> data = {
      'idConductor': _authProvider.getUser()!.uid,
      'status': 'accepted'
    };

    _timer?.cancel();
    _travelInfoProvider.update(data, idCliente);
    _geofireProvider.delete(_authProvider.getUser()!.uid);
     Navigator.pushNamedAndRemoveUntil(context, 'conductor/travel/map', (route) => false,arguments: idCliente );
    //Navigator.pushReplacementNamed(context, 'conductor/travel/map',
     //   arguments: idCliente);
  }

  void cancelTravel() {
    Map<String, dynamic> data = {'status': 'no_accepted'};

    _timer?.cancel();
    _travelInfoProvider.update(data, idCliente);
    Navigator.pushNamedAndRemoveUntil(
        context, 'conductor/map', (route) => false);
  }

  void getClienteInfo() async {
    client = (await _clientProvider.getById(idCliente))!;
    print('Client: ${client.toJson()}');
    refresh();
  }
}
