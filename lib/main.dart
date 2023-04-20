import 'package:farefinder/src/pages/cliente/map/cliente_map_page.dart';
import 'package:farefinder/src/pages/cliente/register/cliente_register_page.dart';
import 'package:farefinder/src/pages/conductor/map/conductor_map_page.dart';
import 'package:farefinder/src/pages/conductor/register/conductor_register_page.dart';
import 'package:farefinder/src/pages/home/home_page.dart';
import 'package:farefinder/src/pages/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:farefinder/src/utils/colors.dart' as utils;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

   runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farefinder',
      initialRoute: 'home',
      theme: ThemeData(
        fontFamily: 'NimbusSans',
        appBarTheme: AppBarTheme(elevation: 0),
        // primaryColor: utils.colors.farefinder
      ),
      routes: {
        'home': (BuildContext context) => HomePage(),
        'login': (BuildContext context) =>  LoginPage(),
        'cliente/register': (BuildContext context) => ClienteRegisterPage(),
        'conductor/register': (BuildContext context) => ConductorRegisterPage(),
        'conductor/map': (BuildContext context) => ConductorMapPage(),
        'cliente/map': (BuildContext context) => ClienteMapPage()
      },
    );
  }
}
