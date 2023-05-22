import 'package:farefinder/src/providers/travel_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:farefinder/src/models/TravelHistory.dart';
import 'package:farefinder/src/utils/snackbar.dart' as utils;

class ConductorTravelCalificacionesController {
  late BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey();
  late Function refresh;

  late String idTravelHistory;

  late TravelHistoryProvider _travelHistoryProvider;
  late TravelHistory travelHistory;

  late double calification;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    idTravelHistory = ModalRoute.of(context)?.settings.arguments as String;
    _travelHistoryProvider = new TravelHistoryProvider();

    print('ID DEL TRAVEL HISTORY: $idTravelHistory');
    getTravelHistory();
  }

  void calificate() async {
    if (calification == null) {
      utils.Snackbar.showSnackbar(
          context, key, 'Por favor califica a tu cliente');
      return;
    }
    if (calification == 0) {
      utils.Snackbar.showSnackbar(context, key, 'La calificacion minima es 1');
      return;
    }
    Map<String, dynamic> data = {'calificacionesCliente': calification};

    await _travelHistoryProvider.update(data, idTravelHistory);
    Navigator.pushNamedAndRemoveUntil(context, 'conductor/map', (route) => false);
  }

  void getTravelHistory() async {
    travelHistory = (await _travelHistoryProvider.getById(idTravelHistory))!;
    refresh();
  }
}
