import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:farefinder/src/providers/client_provider.dart';
import 'package:farefinder/src/providers/geofire_provider.dart';
import 'package:farefinder/src/providers/travel_info_provider.dart';
import 'package:farefinder/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:farefinder/src/models/client.dart';
import 'dart:async';

class ConductorTravelCalificacionesController {
  late BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey();
  late Function refresh;

  late String idTravelHistory;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

  
    idTravelHistory = ModalRoute.of(context)?.settings.arguments as String;

    print('ID DEL TRAVEL HISTORY: $idTravelHistory');
  }
}
