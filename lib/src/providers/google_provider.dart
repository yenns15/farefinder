import 'dart:convert';
import 'dart:async';
import 'package:farefinder/src/api/environment.dart';
import 'package:farefinder/src/models/directions.dart';
import 'package:http/http.dart' as http;

class GoogleProvider {
  Future<dynamic> getGoogleMapsDirections(
      double fromLat, double fromLng, double toLat, double toLng) async {
    Uri uri = Uri.https('maps.googleapis.com', 'maps/api/directions/json', {
      'key': Environment.API_KEY_MAPS,
      'origin': '$fromLat,$fromLng',
      'destination': '$toLat,$toLng',
      'traffic_model': 'best_guess',
      'departure_time': DateTime.now().microsecondsSinceEpoch.toString(),
      'mode': 'driving',
      'transit_routing_preferences': 'less_driving'
    });
    print('URL: $uri');
    final response = await http.get(uri);
    final decodedData = json.decode(response.body);
    final leg = new Direction.fromJsonMap(decodedData['routes'][0]['legs'][0]);

    return leg;
  }
}
