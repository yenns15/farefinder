import 'package:flutter/material.dart';

class BottomSheetClienteInfo extends StatefulWidget {
  final String imageUrl;
  final String username;
  final String email;
  final String plate;

  const BottomSheetClienteInfo({
    required this.imageUrl,
    required this.username,
    required this.email,
    required this.plate,
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetClienteInfo> createState() => _BottomSheetClienteInfoState();
}

class _BottomSheetClienteInfoState extends State<BottomSheetClienteInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      margin: EdgeInsets.all(30),
      child: Column(
        children: [
          Text(
            'Tu Conductor',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 15,
          ),
          CircleAvatar(
            backgroundImage: AssetImage('assets/img/profile.jpg'),
            radius: 50,
          ),
          ListTile(
            title: Text(
              'Nombre',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.username ?? '',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text(
              'correo',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.email ?? '',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.email),
          ),
          ListTile(
            title: Text(
              'Placa del vehiculo',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.plate ?? '',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.directions_car_rounded),
          ),
        ],
      ),
    );
  }
}
