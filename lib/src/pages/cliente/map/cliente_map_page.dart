import 'package:flutter/material.dart';

class ClienteMapPage extends StatefulWidget {
  const ClienteMapPage({super.key});

  @override
  State<ClienteMapPage> createState() => _ClienteMapPageState();
}

class _ClienteMapPageState extends State<ClienteMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:  Text ('MAPA DEL CLIENTE')),
    );
  }
}