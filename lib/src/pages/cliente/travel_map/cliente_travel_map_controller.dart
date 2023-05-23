import 'dart:async';
import 'package:farefinder/src/api/environment.dart';
import 'package:farefinder/src/models/conductor.dart';
import 'package:farefinder/src/models/travel_info.dart';
import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:farefinder/src/providers/conductor_provider.dart';
import 'package:farefinder/src/providers/geofire_provider.dart';
import 'package:farefinder/src/providers/push_notifications_provider.dart';
import 'package:farefinder/src/providers/travel_info_provider.dart';
import 'package:farefinder/src/utils/my_progress_dialog.dart';
import 'package:farefinder/src/widget/bottom_sheet_cliente_info%20.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:farefinder/src/utils/snackbar.dart' as utils;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteTravelMapController {
  late BuildContext context;
  late Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition =
      CameraPosition(target: LatLng(10.4661443, -73.2600704), zoom: 14.0);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  late BitmapDescriptor markerDriver;
  late BitmapDescriptor fromMarker;
  late BitmapDescriptor toMarker;

  late GeofireProvider _geofireProvider;
  late AuthProvider _authProvider;
  late ConductorProvider _conductorProvider;
  late PushNotificationsProvider _pushNotificationsProvider;
  late TravelInfoProvider _travelInfoProvider;

  bool isConnect = false;
  late ProgressDialog _progressDialog;

  late StreamSubscription<DocumentSnapshot<Object?>> _statusSuscription;
  late StreamSubscription<DocumentSnapshot<Object?>> _conductorInfoSuscription;
  late StreamSubscription<DocumentSnapshot<Object?>> _streamLocationController;
  late StreamSubscription<DocumentSnapshot<Object?>> _streamTravelController;
  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  Conductor? conductor;
  late LatLng _conductorLatLng;
  TravelInfo? travelInfo;

  bool isRouteReady = false;
  bool isPickupTravel = false;
  bool isStartTravel = false;
  bool isFinishTravel = false;

  late String currentStatus = '';
  Color colorStatus = Colors.white;

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _geofireProvider = new GeofireProvider();
    _authProvider = new AuthProvider();
    _conductorProvider = new ConductorProvider();
    _travelInfoProvider = new TravelInfoProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Conectandose...');
    markerDriver = await createMarkerImageFromAsset('assets/img/uber_car.png');
    fromMarker = await createMarkerImageFromAsset('assets/img/map_pin_red.png');
    toMarker = await createMarkerImageFromAsset('assets/img/map_pin_blue.png');

    checkGPS();
  }

  void getconductorLocation(String idConductor) {
    Stream<DocumentSnapshot> stream =
        _geofireProvider.getLocationByIdStream(idConductor);
    _streamLocationController = stream.listen((DocumentSnapshot document) {
      GeoPoint geoPoint = document['position']['geopoint'];
      _conductorLatLng = new LatLng(geoPoint.latitude, geoPoint.longitude);
      addSimpleMarker('driver', _conductorLatLng.latitude,
          _conductorLatLng.longitude, 'Tu conductor', '', markerDriver);

      refresh();

      if (!isRouteReady) {
        isRouteReady = true;
        checkTravelStatus();
      }
    });
  }

  void pickupTravel() {
    if (!isPickupTravel) {
      isPickupTravel = true;
      LatLng from =
          LatLng(_conductorLatLng.latitude, _conductorLatLng.longitude);
      LatLng to = LatLng(travelInfo!.fromLat, travelInfo!.fromLng);
      addSimpleMarker('from', to.latitude, to.longitude, 'Lugar de recogida',
          '', fromMarker);
      setPolylines(from, to);
    }
  }

  void checkTravelStatus() async {
    Stream<DocumentSnapshot> stream =
        _travelInfoProvider.getByIdStream(_authProvider.getUser()!.uid);
    _streamTravelController = stream.listen((DocumentSnapshot document) {
      travelInfo = TravelInfo.fromJson(document.data() as Map<String, dynamic>);

      if (travelInfo!.status == 'accepted') {
        currentStatus = 'Viaje aceptado';
        colorStatus = Colors.white;
        pickupTravel();
      } else if (travelInfo!.status == 'started') {
        currentStatus = 'Viaje iniciado';
        colorStatus = Colors.amber;
        startTravel();
      } else if (travelInfo!.status == 'finished') {
        currentStatus = 'Viaje finalizado';
        colorStatus = Colors.cyan;
        finishTravel();
      }

      refresh();
    });
  }

  void openBottomSheet() {
    if (conductor == null) return;
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => BottomSheetClienteInfo(
              imageUrl: conductor!.image,
              username: conductor!.username,
              email: conductor!.email,
              plate: conductor!.plate,
            ));
  }

  void finishTravel() {
    if (!isFinishTravel) {
      isFinishTravel = true;
      Navigator.pushNamedAndRemoveUntil(
          context, 'cliente/travel/calificaciones', (route) => false,
          arguments: travelInfo!.idTravelHistory);
    }
  }

  void startTravel() {
    if (!isStartTravel) {
      isStartTravel = true;
      polylines = {};
      points = [];
      markers.removeWhere((key, markers) => markers.markerId.value == 'from');
      addSimpleMarker(
          'to', travelInfo!.toLat, travelInfo!.toLng, 'Destino', '', toMarker);
      LatLng from =
          new LatLng(_conductorLatLng!.latitude, _conductorLatLng!.longitude);
      LatLng to = new LatLng(travelInfo!.toLat, travelInfo!.toLng);
      setPolylines(from, to);
      refresh();
    }
  }

  void _getTravelInfo() async {
    travelInfo =
        await _travelInfoProvider.getById(_authProvider.getUser()!.uid);
    animateCameraToposition(travelInfo!.fromLat, travelInfo!.fromLng);
    getConductorInfo(travelInfo!.idConductor);
    getconductorLocation(travelInfo!.idConductor);
  }

  Future<void> setPolylines(LatLng from, LatLng to) async {
    PointLatLng pointFromLatLng = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointToLatLng = PointLatLng(to.latitude, to.longitude);

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

    // addMarker(
    //    'to', toLatLng.latitude, toLatLng.longitude, 'Destino', '', toMarker);

    refresh();
  }

  void getConductorInfo(String id) async {
    conductor = await _conductorProvider.getById(id);
    refresh();
  }

  void dispose() {
    _statusSuscription?.cancel();
    _conductorInfoSuscription?.cancel();
    _streamLocationController?.cancel();
    _streamTravelController?.cancel();
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(
        '[{"elementType": "geometry","stylers": [{ "color": "#ebe3cd"} ] },{"elementType": "labels.text.fill","stylers": [  { "color": "#523735"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#f5f1e6"}]}, {"featureType": "administrative","elementType": "geometry.stroke","stylers": [ {"color": "#c9b2a6" }]},{  "featureType": "administrative.land_parcel",  "elementType": "geometry.stroke", "stylers": [ {"color": "#dcd2be"}]},{"featureType": "administrative.land_parcel", "elementType": "labels.text.fill","stylers": [{"color": "#ae9e90"} ]},{"featureType": "landscape.natural","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "poi","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#93817c"}]},{"featureType": "poi.park","elementType": "geometry.fill","stylers": [{ "color": "#a5b076"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#447530"}]},{"featureType": "road","elementType": "geometry","stylers": [{"color": "#f5f1e6"}]},{"featureType": "road.arterial","elementType": "geometry","stylers": [{"color": "#fdfcf8"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#f8c967"}]},{"featureType": "road.highway","elementType": "geometry.stroke","stylers": [{"color": "#e9bc62"}]},{"featureType": "road.highway.controlled_access","elementType": "geometry","stylers": [{"color": "#e98d58"}]},{"featureType": "road.highway.controlled_access","elementType": "geometry.stroke","stylers": [{"color": "#db8555"}]},{"featureType": "road.local","elementType": "labels.text.fill","stylers": [{"color": "#806b63"}]},{"featureType": "transit.line","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "transit.line","elementType": "labels.text.fill","stylers": [{"color": "#8f7d77"}]},{"featureType": "transit.line","elementType": "labels.text.stroke","stylers": [{"color": "#ebe3cd"}]},{"featureType": "transit.station","elementType": "geometry","stylers": [ {"color": "#dfd2ae"}]},{"featureType": "water","elementType": "geometry.fill","stylers": [{"color": "#b9d3c2"}]},{"featureType": "water", "elementType": "labels.text.fill","stylers": [  {   "color": "#92998d" }]}]');
    _mapController.complete(controller);
    _getTravelInfo();
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      print('GPS activado');
    } else {
      print('GPS desactivado');
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        print('Activo el GPS');
      }
    }
  }

  Future animateCameraToposition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 0, target: LatLng(latitude, longitude), zoom: 17)));
    }
  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void addSimpleMarker(String markerId, double lat, double lng, String title,
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
