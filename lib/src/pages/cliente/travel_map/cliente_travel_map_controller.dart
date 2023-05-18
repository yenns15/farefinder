import 'package:flutter/material.dart';

class ClienteTravelMapController {
  late BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey();
  late Function refresh;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
  }
}