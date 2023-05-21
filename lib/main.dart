import 'package:farefinder/src/pages/cliente/map/cliente_map_page.dart';
import 'package:farefinder/src/pages/cliente/register/cliente_register_page.dart';
import 'package:farefinder/src/pages/cliente/travel_info/cliente_travel_info_page.dart';
import 'package:farefinder/src/pages/cliente/travel_map/cliente_travel_map_page.dart';
import 'package:farefinder/src/pages/cliente/travel_request/cliente_travel_request_page.dart';
import 'package:farefinder/src/pages/conductor/map/conductor_map_page.dart';
import 'package:farefinder/src/pages/conductor/register/conductor_register_page.dart';
import 'package:farefinder/src/pages/conductor/travel_calificaciones/conductor_travel_calificaciones_page.dart';
import 'package:farefinder/src/pages/conductor/travel_request/conductor_travel_request_page.dart';
import 'package:farefinder/src/pages/conductor/travel_map/conductor_travel_map_page.dart';
import 'package:farefinder/src/pages/home/home_page.dart';
import 'package:farefinder/src/pages/login/login_page.dart';
import 'package:farefinder/src/providers/push_notifications_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:farefinder/src/utils/colors.dart' as utils;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetPlatform.isWeb
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyCTjfv2QB_gQJ6R9u5HoMJUsuWFTXu1iww",
              authDomain: "farefinder-ab34b.firebaseapp.com",
              projectId: "farefinder-ab34b",
              storageBucket: "farefinder-ab34b.appspot.com",
              messagingSenderId: "907384138389",
              appId: "1:907384138389:web:19f90443291d0fbc50099c"))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    PushNotificationsProvider pushNotificationsProvider =
        new PushNotificationsProvider();
    pushNotificationsProvider.initPushNotifications();
    pushNotificationsProvider.message.listen((data) {
      print('-------------NOTIFICACION NUEVA-------------');
      print(data);

      navigatorKey.currentState?.pushNamed('conductor/travel/request',arguments: data );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farefinder',
      navigatorKey: navigatorKey,
      initialRoute: 'home',
      theme: ThemeData(
        fontFamily: 'NimbusSans',
        appBarTheme: AppBarTheme(
          elevation: 0
        ),
        // primaryColor: utils.colors.farefinder
      ),
      routes: {
        'home': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => LoginPage(),
        'cliente/register': (BuildContext context) => ClienteRegisterPage(),
        'conductor/register': (BuildContext context) => ConductorRegisterPage(),
        'conductor/map': (BuildContext context) => ConductorMapPage(),
        'conductor/travel/request': (BuildContext context) => ConductorTravelRequestPage(),
        'conductor/travel/map': (BuildContext context) =>  ConductorTravelMapPage(),
        'conductor/travel/calificaciones': (BuildContext context) =>  ConductorTravelCalificacionesPage(),
        'cliente/map': (BuildContext context) => ClienteMapPage(),
        'cliente/travel/info': (BuildContext context) =>  ClienteTravelInfoPage(),
        'cliente/travel/request': (BuildContext context) => ClienteTravelRequestPage(),
        'cliente/travel/map': (BuildContext context) => ClienteTravelMapPage()
      },
    );
  }
}
