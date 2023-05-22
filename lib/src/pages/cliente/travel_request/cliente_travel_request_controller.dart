import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farefinder/src/models/travel_info.dart';
import 'package:farefinder/src/models/conductor.dart';
import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:farefinder/src/providers/conductor_provider.dart';
import 'package:farefinder/src/providers/geofire_provider.dart';
import 'package:farefinder/src/providers/push_notifications_provider.dart';
import 'package:farefinder/src/providers/travel_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:farefinder/src/utils/snackbar.dart' as utils;

class ClienteTravelRequestController {
  late BuildContext context;
  late Function refresh;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  late String from;
  late String to;
  late LatLng fromLatLng;
  late LatLng toLatLng;

  late TravelInfoProvider _travelInfoProvider;
  late AuthProvider _authProvider;
  late ConductorProvider _conductorProvider;
  late GeofireProvider _geofireProvider;
  late PushNotificationsProvider _pushNotificationsProvider;

  List<String> nearbyDrivers = [];

  late StreamSubscription<List<DocumentSnapshot>> _streamSubscription;
  late StreamSubscription<DocumentSnapshot> _streamStatusSubscription;

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _travelInfoProvider = new TravelInfoProvider();
    _authProvider = new AuthProvider();
    _conductorProvider = new ConductorProvider();
    _geofireProvider = new GeofireProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();

    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];
    _createTravelInfo();
    _getNearbyDrivers();
  }

  void _checkDriverResponse() {
    Stream<DocumentSnapshot> stream =
        _travelInfoProvider.getByIdStream(_authProvider.getUser()!.uid);
    _streamStatusSubscription = stream.listen((DocumentSnapshot document) {
      if (document.exists) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          TravelInfo travelInfo = TravelInfo.fromJson(data);

          if (travelInfo.idConductor != null &&
              travelInfo.status == 'accepted') {
            Navigator.pushNamedAndRemoveUntil( context, 'cliente/travel/map', (route) => false);
            // Navigator.pushReplacementNamed( context, 'cliente/travel/map');
          } else if (travelInfo.status == 'no_accepted') {
            utils.Snackbar.showSnackbar(
                context, key, 'El conductor no acepto tu solicitud');
            Future.delayed(Duration(milliseconds: 5000), () {
           
            Navigator.pushNamedAndRemoveUntil(
                context, 'cliente/map', (route) => false);
            });

           
          }
        }
      }
    });
  }

  void dispose() {
    _streamSubscription?.cancel();
    _streamStatusSubscription?.cancel();
  }

  void _getNearbyDrivers() {
    Stream<List<DocumentSnapshot>> stream = _geofireProvider.getNearbyDrivers(
        fromLatLng.latitude, fromLatLng.longitude, 5);

    _streamSubscription = stream.listen((List<DocumentSnapshot> documentList) {
      for (DocumentSnapshot d in documentList) {
        print('CONDUCTOR ENCONTRADO ${d.id}');
        nearbyDrivers.add(d.id);
      }

      getDriverInfo(nearbyDrivers[0]);
      _streamSubscription?.cancel();
    });
  }

  //aqui me cambia cuando hago algo en el model travel info

  void _createTravelInfo() async {
    TravelInfo travelInfo = TravelInfo(
      id: _authProvider.getUser()!.uid,
      from: from,
      to: to,
      fromLat: fromLatLng.latitude,
      fromLng: fromLatLng.longitude,
      toLat: toLatLng.latitude,
      toLng: toLatLng.longitude,
      status: 'created',
      idConductor: '',
     idTravelHistory: '', 
     price: 1,
      
    );

    await _travelInfoProvider.create(travelInfo);
    _checkDriverResponse();
  }

  Future<void> getDriverInfo(String idConductor) async {
    Conductor? conductor = await _conductorProvider.getById(idConductor);
    _sendNotification(conductor!.token);
  }

  void _sendNotification(String token) {
    print('TOKEN: $token');

    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'idClient': _authProvider.getUser()!.uid,
      'origin': from,
      'destination': to,
    };
    _pushNotificationsProvider.sendMessage(token, data, 'Solicitud de servicio',
        'Un cliente esta solicitando viaje');
  }
}
