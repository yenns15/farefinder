import 'package:farefinder/src/pages/cliente/editar/cliente_editar_controller.dart';
import 'package:farefinder/src/widget/button_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:farefinder/src/utils/colors.dart' as utils;

class ClienteEditarPage extends StatefulWidget {
  const ClienteEditarPage({Key? key}) : super(key: key);

  @override
  _ClienteEditarPageState createState() => _ClienteEditarPageState();
}

class _ClienteEditarPageState extends State<ClienteEditarPage> {
  ClienteEditarController _con = ClienteEditarController();

  @override
  void initState() {
    super.initState();
    print('INIT STATE');

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context,refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 7, 7, 7),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom,
            
        child: SingleChildScrollView(
          child: Column(
            children: [
              _bannerApp(),
              _textLogin(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              _textFieldUsername(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.4),
              _buttonRegister(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonRegister() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width *
          0.8, // Ajusta el ancho del botón según tus necesidades
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Container(
        color: utils.colors.farefinder,
        child: ElevatedButton(
          onPressed: _con.register,
          child: Text(
            'Actualizar',
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
          ),
        ),
      ),
    );
  }

  Widget _textFieldUsername() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        controller: _con.usernameController,
        decoration: InputDecoration(
          hintText: 'Yenns Noya',
          labelText: 'Nombre de usuario',
          suffixIcon: Icon(
            Icons.person_outlined,
            color: utils.colors.farefinder,
          ),
        ),
      ),
    );
  }

  Widget _textLogin() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'EDITAR PERFIL',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
      ),
    );
  }

  Widget _bannerApp(){
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        color: utils.colors.farefinder,
        height: MediaQuery.of(context).size.height * 0.15,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: _con.getImageFromGallery,
              child: CircleAvatar(
              backgroundImage: _con.imageFile != null 
               ? FileImage(_con.imageFile!)
               : AssetImage('assets/img/profile.jpg') as ImageProvider,
                radius: 50,
                ),




            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text(
                'Nuestro servicio tu destino',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void refresh(){
    setState(() {
      
    });
  }
}
