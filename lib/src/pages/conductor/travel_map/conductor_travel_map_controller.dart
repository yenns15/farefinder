import 'dart:async';
import 'dart:ffi';
import 'package:farefinder/src/api/environment.dart';
import 'package:farefinder/src/models/client.dart';
import 'package:farefinder/src/models/conductor.dart';
import 'package:farefinder/src/models/travel_info.dart';
import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:farefinder/src/providers/client_provider.dart';
import 'package:farefinder/src/providers/conductor_provider.dart';
import 'package:farefinder/src/providers/geofire_provider.dart';
import 'package:farefinder/src/providers/prices_provider.dart';
import 'package:farefinder/src/providers/push_notifications_provider.dart';
import 'package:farefinder/src/providers/travel_info_provider.dart';
import 'package:farefinder/src/utils/my_progress_dialog.dart';
import 'package:farefinder/src/widget/bottom_sheet_conductor_info.dart';
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
import 'package:farefinder/src/models/prices.dart';

class ConductorTravelMapController {
  late BuildContext context;
  late Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition =
      CameraPosition(target: LatLng(10.4661443, -73.2600704), zoom: 14.0);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Position? _position;
  late StreamSubscription<Position> _positionStream;

  late BitmapDescriptor markerDriver;
  late BitmapDescriptor fromMarker;
  late BitmapDescriptor toMarker;

  late GeofireProvider _geofireProvider;
  late AuthProvider _authProvider;
  late ConductorProvider _conductorProvider;
  late PushNotificationsProvider _pushNotificationsProvider;
  late TravelInfoProvider _travelInfoProvider;
  late PricesProvider _pricesProvider;
  late ClientProvider _clientProvider;

  bool isConnect = false;
  late ProgressDialog _progressDialog;

  late StreamSubscription<DocumentSnapshot<Object?>> _statusSuscription;
  late StreamSubscription<DocumentSnapshot<Object?>> _conductorInfoSuscription;

  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  Conductor? conductor;
  Client? _client;

  late String _idTravel;
  TravelInfo? travelInfo;

  String currentStatus = 'INICIAR VIAJE';
  Color colorStatus = Colors.amber;

  double _distanceBetween = 0.0;
  late Timer _timer;
  int seconds = 0;
  double mt = 0;
  double km = 0;

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _idTravel = ModalRoute.of(context)?.settings.arguments as String;
    _geofireProvider = new GeofireProvider();
    _authProvider = new AuthProvider();
    _conductorProvider = new ConductorProvider();
    _travelInfoProvider = new TravelInfoProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();
    _pricesProvider = new PricesProvider();
    _clientProvider = new ClientProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Conectandose...');
    markerDriver = await createMarkerImageFromAsset('assets/img/uber_car.png');
    fromMarker = await createMarkerImageFromAsset('assets/img/map_pin_red.png');
    toMarker = await createMarkerImageFromAsset('assets/img/map_pin_blue.png');

    checkGPS();

    getConductorInfo();
  }

  void getClientInfo() async {
    _client = await _clientProvider.getById(_idTravel);
  }

  Future<double> calculatePrice() async {
    Prices prices = await _pricesProvider.getAll();

    if (seconds < 60) seconds = 60;
    if (km == 0) km = 0.1;
    int min = seconds ~/ 60;

    print('==== MIN TOTALES=====');
    print(min.toString());

    print('==== KM TOTALES=====');
    print(km.toString());

    double priceMin = min * prices.min;
    double priceKm = km * prices.km;

    double total = priceMin + priceKm;

    if (total < prices.minValue) {
      total = prices.minValue;
    }

    print('====  TOTALES=====');
    print(total.toString());
    return total;
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds = timer.tick;
      refresh();
    });
  }

  void isCloseToPickupPosition(LatLng from, LatLng to) {
    _distanceBetween = Geolocator.distanceBetween(
        from.latitude, from.longitude, to.latitude, to.longitude);
    print('----------------Distancia:$_distanceBetween----------');
  }

  void updateStatus() {
    if (travelInfo!.status == 'accepted') {
      startTravel();
    } else if (travelInfo!.status == 'started') {
      finishTravel();
    }
  }

  void startTravel() async {
    if (_distanceBetween <= 300) {
      Map<String, dynamic> data = {'status': 'started'};
      await _travelInfoProvider.update(data, _idTravel);
      travelInfo!.status = 'started';
      currentStatus = 'Finalizar viaje';
      colorStatus = Colors.cyan;
      polylines = {};
      points = [];
      //markers.remove(markers['from']);
      markers.removeWhere((key, markers) => markers.markerId.value == 'from');
      addSimpleMarker(
          'to', travelInfo!.toLat, travelInfo!.toLng, 'Destino', '', toMarker);
      LatLng from = new LatLng(_position!.latitude, _position!.longitude);
      LatLng to = new LatLng(travelInfo!.toLat, travelInfo!.toLng);
      setPolylines(from, to);
      startTimer();
      refresh();
    } else {
      utils.Snackbar.showSnackbar(
          context, key, 'Debes estar cerca a la posicion del cliente');
    }

    refresh();
  }

  void finishTravel() async {
    _timer?.cancel();
    double total = await calculatePrice();
    Map<String, dynamic> data = {'status': 'finished'};
    await _travelInfoProvider.update(data, _idTravel);
    travelInfo!.status = 'finished';
    Navigator.pushNamedAndRemoveUntil(
        context, 'conductor/travel/calificaciones', (route) => false);
    refresh();
  }

  void _getTravelInfo() async {
    travelInfo = await _travelInfoProvider.getById(_idTravel);
    LatLng from = LatLng(_position!.latitude, _position!.longitude);
    LatLng to = LatLng(travelInfo!.fromLat, travelInfo!.fromLng);
    addSimpleMarker(
        'from', to.latitude, to.longitude, 'Lugar de recogida', '', fromMarker);
    setPolylines(from, to);
    getClientInfo();
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

  void getConductorInfo() {
    Stream<DocumentSnapshot> conductorstream =
        _conductorProvider.getByIdStream(_authProvider.getUser()!.uid);
    _conductorInfoSuscription =
        conductorstream.listen((DocumentSnapshot document) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      if (data != null) {
        conductor = Conductor.fromJson(data);
      }
      refresh();
    });
  }

  void dispose() {
    _timer?.cancel();
    _positionStream?.cancel();
    _statusSuscription?.cancel();
    _conductorInfoSuscription?.cancel();
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(
        '[{"elementType": "geometry","stylers": [{ "color": "#ebe3cd"} ] },{"elementType": "labels.text.fill","stylers": [  { "color": "#523735"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#f5f1e6"}]}, {"featureType": "administrative","elementType": "geometry.stroke","stylers": [ {"color": "#c9b2a6" }]},{  "featureType": "administrative.land_parcel",  "elementType": "geometry.stroke", "stylers": [ {"color": "#dcd2be"}]},{"featureType": "administrative.land_parcel", "elementType": "labels.text.fill","stylers": [{"color": "#ae9e90"} ]},{"featureType": "landscape.natural","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "poi","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#93817c"}]},{"featureType": "poi.park","elementType": "geometry.fill","stylers": [{ "color": "#a5b076"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#447530"}]},{"featureType": "road","elementType": "geometry","stylers": [{"color": "#f5f1e6"}]},{"featureType": "road.arterial","elementType": "geometry","stylers": [{"color": "#fdfcf8"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#f8c967"}]},{"featureType": "road.highway","elementType": "geometry.stroke","stylers": [{"color": "#e9bc62"}]},{"featureType": "road.highway.controlled_access","elementType": "geometry","stylers": [{"color": "#e98d58"}]},{"featureType": "road.highway.controlled_access","elementType": "geometry.stroke","stylers": [{"color": "#db8555"}]},{"featureType": "road.local","elementType": "labels.text.fill","stylers": [{"color": "#806b63"}]},{"featureType": "transit.line","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "transit.line","elementType": "labels.text.fill","stylers": [{"color": "#8f7d77"}]},{"featureType": "transit.line","elementType": "labels.text.stroke","stylers": [{"color": "#ebe3cd"}]},{"featureType": "transit.station","elementType": "geometry","stylers": [ {"color": "#dfd2ae"}]},{"featureType": "water","elementType": "geometry.fill","stylers": [{"color": "#b9d3c2"}]},{"featureType": "water", "elementType": "labels.text.fill","stylers": [  {   "color": "#92998d" }]}]');
    _mapController.complete(controller);
  }

  void saveLocation() async {
    await _geofireProvider.createWorking(_authProvider.getUser()!.uid,
        _position!.latitude, _position!.longitude);
    _progressDialog.hide();
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      _getTravelInfo();
      centerPosition();
      saveLocation();
      addMarker('conductor', _position!.latitude, _position!.longitude,
          'Tu posicion', '', markerDriver);
      refresh();

      _positionStream = Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.best, distanceFilter: 1)
          .listen((Position position) {
        if (travelInfo!.status == 'started') {
          mt = mt +
              Geolocator.distanceBetween(
                  _position!.latitude,
                  _position!.longitude,
                  position!.latitude,
                  position!.longitude);
          km = mt / 1000;
        }
        _position = position;
        addMarker('conductor', _position!.latitude, _position!.longitude,
            'Tu posicion', '', markerDriver);
        animateCameraToposition(_position!.latitude, _position!.longitude);
        if (travelInfo?.fromLat != null && travelInfo?.fromLng != null) {
          LatLng from = new LatLng(_position!.latitude, _position!.longitude);
          LatLng to = new LatLng(travelInfo!.fromLat, travelInfo!.fromLng);
          isCloseToPickupPosition(from, to);
        }
        saveLocation();
        refresh();
      });
    } catch (error) {
      print('Error en la localizacion: $error');
    }
  }

  void openBottomSheet() {
    if (_client == null) return;
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => BottomSheetConductorInfo(
              imageUrl: '',
              username: _client!.username,
              email: _client!.email,
            ));
  }

  void centerPosition() {
    if (_position != null) {
      animateCameraToposition(_position!.latitude, _position!.longitude);
    } else {
      utils.Snackbar.showSnackbar(context, key, 'Activa el GPS');
    }
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      print('GPS activado');
      updateLocation();
    } else {
      print('GPS desactivado');
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();

        print('Activo el GPS');
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
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

  void addMarker(String markerId, double lat, double lng, String title,
      String content, BitmapDescriptor iconMaker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: iconMaker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title, snippet: content),
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: Offset(0.5, 0.5),
      rotation: _position!.heading,
    );
    markers[id] = marker;
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
