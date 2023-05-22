import 'package:farefinder/src/widget/button_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ConductorTravelCalificacionesPage extends StatefulWidget {
  const ConductorTravelCalificacionesPage({super.key});

  @override
  State<ConductorTravelCalificacionesPage> createState() =>
      _ConductorTravelCalificacionesPageState();
}

class _ConductorTravelCalificacionesPageState
    extends State<ConductorTravelCalificacionesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _bannerPriceInfo(),
          _listTileTravelInfo(
              'Desde', 'direccion de recogida', Icons.location_on),
          _listTileTravelInfo(
              'Hasta', 'direccion de destino', Icons.directions_subway),
          SizedBox(height: 30),
          Expanded(
            child: Column(
              children: [
                _textCalificateYourDriver(),
                SizedBox(height: 15),
                _ratingBar(),
              ],
            ),
          ),
          _buttonCalificate(),
        ],
      ),
    );
  }

  Widget  _buttonCalificate() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          primary: Colors.amber, 
        ),
        child: Text(
          'CALIFICAR',
          style: TextStyle(
            color: Colors.black, 
          ),
        ),
      ),
    );
  }

  Widget _ratingBar() {
    return Center(
      child: RatingBar.builder(
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        itemCount: 5,
        initialRating: 0,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemPadding: EdgeInsets.symmetric(horizontal: 4),
        unratedColor: Colors.grey[300],
        onRatingUpdate: (rating) {
          print('RATING: $rating');
        },
      ),
    );
  }

  Widget _textCalificateYourDriver() {
    return Text(
      'CALIFICA A TU CLIENTE',
      style: TextStyle(
          color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Widget _listTileTravelInfo(String title, String value, IconData icon) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          maxLines: 1,
        ),
        subtitle: Text(
          value,
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
          maxLines: 2,
        ),
        leading: Icon(
          icon,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _bannerPriceInfo() {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        height: 280,
        width: double.infinity,
        color: Colors.amber,
        child: SafeArea(
          child: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.grey[800], size: 100),
              SizedBox(height: 20),
              Text(
                'TU VIAJE HA FINALIZADO',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Text(
                'Valor del viaje',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '0\$',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
