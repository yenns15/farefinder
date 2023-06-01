import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farefinder/src/models/travel_history.dart';
import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:farefinder/src/providers/travel_history_provider.dart';
import 'package:flutter/material.dart';

class ClienteHistoryController {
  late Function refresh;
  late BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  TravelHistoryProvider? _travelHistoryProvider;
  late AuthProvider _authProvider;

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _travelHistoryProvider = new TravelHistoryProvider();
    _authProvider = new AuthProvider();
    refresh();


  }

/*
  Future<QuerySnapshot?> getAll2() async {
   

    return await _travelHistoryProvider
        ?.consulta(_authProvider.getUser()!.uid);

  }*/
   Future<List<TravelHistory>> getAll() async {
    List<TravelHistory>? travelHistoryList = await _travelHistoryProvider
        ?.getByIdCliente(_authProvider.getUser()!.uid);

    return travelHistoryList != null ? List<TravelHistory>.from(travelHistoryList) : [];
}
}