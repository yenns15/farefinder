import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farefinder/src/models/travel_info.dart';
import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:farefinder/src/providers/conductor_provider.dart';
import 'package:farefinder/src/providers/geofire_provider.dart';
import 'package:farefinder/src/providers/travel_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  List<String> nearbyDrivers = [];

  late StreamSubscription<List<DocumentSnapshot>> _streamSubscription;

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _travelInfoProvider = new TravelInfoProvider();
    _authProvider = new AuthProvider();
    _conductorProvider = new ConductorProvider();
    _geofireProvider = new GeofireProvider();

    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];
    _createTravelInfo();
    _getNearbyDrivers();
  }

  void dispose() {
    _streamSubscription?.cancel();
  }

  void _getNearbyDrivers() {
    Stream<List<DocumentSnapshot>> stream = _geofireProvider.getNearbyDrivers(
        fromLatLng.latitude, fromLatLng.longitude, 5);

    _streamSubscription = stream.listen((List<DocumentSnapshot> documentList) {
      for (DocumentSnapshot d in documentList) {
        print('CONDUCTOR ENCONTRADO ${d.id}');
        nearbyDrivers.add(d.id);
      }
    });
  }

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
    );

    await _travelInfoProvider.create(travelInfo);
  }
}
