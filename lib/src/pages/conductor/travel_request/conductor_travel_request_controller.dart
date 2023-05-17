import 'package:farefinder/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class ConductorTravelRequestController{
  late BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey();
 late Function refresh;
  late SharedPref _sharedPref;

  Future init (BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    _sharedPref = new SharedPref();
    _sharedPref.save('isNotification', 'false');
  }
}