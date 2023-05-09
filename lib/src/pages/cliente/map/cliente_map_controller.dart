import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farefinder/src/providers/auth_provider.dart';
import 'package:farefinder/src/providers/client_provider.dart';
import 'package:farefinder/src/providers/conductor_provider.dart';
import 'package:farefinder/src/providers/geofire_provider.dart';
import 'package:farefinder/src/utils/my_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import '../../../models/client.dart';
import 'package:location/location.dart' as location;
import 'package:farefinder/src/utils/snackbar.dart' as utils;

class ClienteMapController {
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

  late GeofireProvider _geofireProvider;
  late AuthProvider _authProvider;
  late ConductorProvider _conductorProvider;
  late ClientProvider _clientProvider;

  bool isConnect = false;
  late ProgressDialog _progressDialog;

  late StreamSubscription<DocumentSnapshot<Object?>> _statusSuscription;
  late StreamSubscription<DocumentSnapshot<Object?>> _clientInfoSubscription;
  Client? cliente;

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _geofireProvider = new GeofireProvider();
    _authProvider = new AuthProvider();
    _clientProvider = new ClientProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Conectandose...');
    markerDriver = await createMarkerImageFromAsset('assets/img/uber_car.png');
    checkGPS();
    getClienteInfo();
  }

  void getClienteInfo() {
    Stream<DocumentSnapshot> clientstream =
        _clientProvider.getByIdStream(_authProvider.getUser()!.uid);
    _clientInfoSubscription = clientstream.listen((DocumentSnapshot document) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      if (data != null) {
        cliente = Client.fromJson(data);
      }
      refresh();
    });
  }

  void openDrawer() {
    key.currentState?.openDrawer();
  }

  void dispose() {
    _positionStream?.cancel();
    _statusSuscription?.cancel();
    _clientInfoSubscription?.cancel();
  }

  void singOut() async {
    await _authProvider.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(
        '[{"elementType": "geometry","stylers": [{ "color": "#ebe3cd"} ] },{"elementType": "labels.text.fill","stylers": [  { "color": "#523735"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#f5f1e6"}]}, {"featureType": "administrative","elementType": "geometry.stroke","stylers": [ {"color": "#c9b2a6" }]},{  "featureType": "administrative.land_parcel",  "elementType": "geometry.stroke", "stylers": [ {"color": "#dcd2be"}]},{"featureType": "administrative.land_parcel", "elementType": "labels.text.fill","stylers": [{"color": "#ae9e90"} ]},{"featureType": "landscape.natural","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "poi","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#93817c"}]},{"featureType": "poi.park","elementType": "geometry.fill","stylers": [{ "color": "#a5b076"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#447530"}]},{"featureType": "road","elementType": "geometry","stylers": [{"color": "#f5f1e6"}]},{"featureType": "road.arterial","elementType": "geometry","stylers": [{"color": "#fdfcf8"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#f8c967"}]},{"featureType": "road.highway","elementType": "geometry.stroke","stylers": [{"color": "#e9bc62"}]},{"featureType": "road.highway.controlled_access","elementType": "geometry","stylers": [{"color": "#e98d58"}]},{"featureType": "road.highway.controlled_access","elementType": "geometry.stroke","stylers": [{"color": "#db8555"}]},{"featureType": "road.local","elementType": "labels.text.fill","stylers": [{"color": "#806b63"}]},{"featureType": "transit.line","elementType": "geometry","stylers": [{"color": "#dfd2ae"}]},{"featureType": "transit.line","elementType": "labels.text.fill","stylers": [{"color": "#8f7d77"}]},{"featureType": "transit.line","elementType": "labels.text.stroke","stylers": [{"color": "#ebe3cd"}]},{"featureType": "transit.station","elementType": "geometry","stylers": [ {"color": "#dfd2ae"}]},{"featureType": "water","elementType": "geometry.fill","stylers": [{"color": "#b9d3c2"}]},{"featureType": "water", "elementType": "labels.text.fill","stylers": [  {   "color": "#92998d" }]}]');
    _mapController.complete(controller);
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition(); //una unica vez
      centerPosition();
      getNearbyDrivers();
    } catch (error) {
      print('Error en la localizacion: $error');
    }
  }

  void getNearbyDrivers() {
    Stream<List<DocumentSnapshot>> stream = _geofireProvider.getNearbyDrivers(
        _position!.latitude, _position!.longitude, 10);

    stream.listen((List<DocumentSnapshot> documentList) {
      
     for (DocumentSnapshot d in documentList) {
        print('DOCUMENT: $d');
      }


      for (MarkerId m in markers.keys) {
        bool remove = true;

        for (DocumentSnapshot d in documentList) {
          if (m.value == d.id) {
            remove = false;
          }
        }

        if (remove) {
          markers.remove(m);
          refresh();
        }
      }
      for (DocumentSnapshot d in documentList) {
        GeoPoint point = d['position']['geopoint'];
        addMarker(d.id, point.latitude, point.longitude, 'Conductor disponible',
            '', markerDriver);
      }
      refresh();
    });
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
}
