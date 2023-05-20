import 'package:flutter/material.dart';

class BottomSheetConductorInfo extends StatefulWidget {
  final String imageUrl;
  final String username;
  final String email;
  

  const BottomSheetConductorInfo({
    required this.imageUrl,
    required this.username,
    required this.email,
    
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetConductorInfo> createState() =>
      _BottomSheetConductorInfoState();
}

class _BottomSheetConductorInfoState extends State<BottomSheetConductorInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      margin: EdgeInsets.all(30),
      child: Column(
        children: [
          Text(
            'Tu Cliente',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 15,),
          CircleAvatar(
            backgroundImage: AssetImage(widget.imageUrl),
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
              'Correo',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.email ?? '',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.email),
          ),
          
          
        ],
      ),
    );
  }
}

