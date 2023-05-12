import 'dart:async';

import 'package:farefinder/src/api/environment.dart';
import 'package:farefinder/src/models/directions.dart';
import 'package:farefinder/src/providers/google_provider.dart';
import 'package:farefinder/src/providers/prices_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:farefinder/src/models/prices.dart';

class ClienteTravelInfoController {
  late BuildContext context;
  late GoogleProvider _googleProvider;
   PricesProvider? _pricesProvider;

  late Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition =
      CameraPosition(target: LatLng(10.4661443, -73.2600704), zoom: 14.0);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  late String from;
  late String to;
  late LatLng fromLatLng;
  late LatLng toLatLng;

  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  late BitmapDescriptor fromMarker;
  late BitmapDescriptor toMarker;

  late Direction _directions;
  late String min;
  late String km;

  late double minTotal;
  late double maxTotal;

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];

    _googleProvider = new GoogleProvider();
    _pricesProvider = new PricesProvider();

    fromMarker = await createMarkerImageFromAsset('assets/img/map_pin_red.png');
    toMarker = await createMarkerImageFromAsset('assets/img/map_pin_blue.png');

    animateCameraToposition(fromLatLng.latitude, fromLatLng.longitude);
    getGoogleMapsDirections(fromLatLng, toLatLng);
  }

  void getGoogleMapsDirections(LatLng from, LatLng to) async {
    _directions = await _googleProvider.getGoogleMapsDirections(
        from.latitude, from.longitude, to.latitude, to.longitude);
    min = _directions.duration.text;
    km = _directions.distance.text;

    print('KM: $km');
    print('MIN: $min');

    calculatePrice();

    refresh();
  }

  void calculatePrice() async {
    Prices prices = await _pricesProvider!.getAll();
    double kmValue = double.parse(km!.split(" ")[0]) * prices.km;
    double minValue = double.parse(min!.split(" ")[0]) * prices.min;
    double total = kmValue + minValue;

    minTotal = total - 1.094;
    maxTotal = total + 1.178;

    refresh();
  }

  Future<void> setPolylines() async {
    PointLatLng pointFromLatLng =
        PointLatLng(fromLatLng.latitude, fromLatLng.longitude);
    PointLatLng pointToLatLng =
        PointLatLng(toLatLng.latitude, toLatLng.longitude);

    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS, pointFromLatLng, pointToLatLng);

    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }
    //aca podemos cambiar el color de la ruta
    Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
        color: Colors.green,
        points: points,
        width: 6);

    polylines.add(polyline);

    addMarker('from', fromLatLng.latitude, fromLatLng.longitude,
        'Lugar de recogida', '', fromMarker);
    addMarker(
        'to', toLatLng.latitude, toLatLng.longitude, 'Destino', '', toMarker);

    refresh();
  }

  Future animateCameraToposition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 0, target: LatLng(latitude, longitude), zoom: 15)));
    }
  }

  void onMapCreated(GoogleMapController controller) async {
    controller.setMapStyle(
        '[{"elementType": "geometry","stylers": [{ "color": "#ebe3cd"} ] },{"elementType": "labels.text.fill","stylers": [  { "color": "#523735"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#f5f1e6"}]}, {"featureType": "administrative","elementType": "geometry.stroke","stylers": [ {"color": "#c9b2a6" }]},{  "featureType": "administrative.land_parcel",  "elementType": "geometry.stroke", "stylers": [ {"color": "#dcd2be"}]},{"featureType": "administrative.land_parcel", "elementType": "labels.text.fill","stylers": [{"color": "#ae9e90"} ]},{"featureType": "landscape.natural","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "poi","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#93817c"}]},{"featureType": "poi.park","elementType": "geometry.fill","stylers": [{ "color": "#a5b076"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#447530"}]},{"featureType": "road","elementType": "geometry","stylers": [{"color": "#f5f1e6"}]},{"featureType": "road.arterial","elementType": "geometry","stylers": [{"color": "#fdfcf8"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#f8c967"}]},{"featureType": "road.highway","elementType": "geometry.stroke","stylers": [{"color": "#e9bc62"}]},{"featureType": "road.highway.controlled_access","elementType": "geometry","stylers": [{"color": "#e98d58"}]},{"featureType": "road.highway.controlled_access","elementType": "geometry.stroke","stylers": [{"color": "#db8555"}]},{"featureType": "road.local","elementType": "labels.text.fill","stylers": [{"color": "#806b63"}]},{"featureType": "transit.line","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "transit.line","elementType": "labels.text.fill","stylers": [{"color": "#8f7d77"}]},{"featureType": "transit.line","elementType": "labels.text.stroke","stylers": [{"color": "#ebe3cd"}]},{"featureType": "transit.station","elementType": "geometry","stylers": [ {"color": "#dfd2ae"}]},{"featureType": "water","elementType": "geometry.fill","stylers": [{"color": "#b9d3c2"}]},{"featureType": "water", "elementType": "labels.text.fill","stylers": [  {   "color": "#92998d" }]}]');
    _mapController.complete(controller);
    await setPolylines();
  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void addMarker(String markerId, double lat, double lng, String title,
      String content, BitmapDescriptor iconMaker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: iconMaker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title, snippet: content),
    );
    markers[id] = marker;
  }
}
