import 'package:flutter/material.dart';

class ClienteHistoryController {
  late Function refresh;
  late BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();


    Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

   
  }
}
