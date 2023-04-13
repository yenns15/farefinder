import 'package:farefinder/pages/home/home_page.dart';
import 'package:farefinder/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:farefinder/utils/colors.dart' as utils;

void main() {
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
          primaryColor: utils.colors.farefinder),
      routes: {
        'home': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => LoginPage(),
      },
    );
  }
}
