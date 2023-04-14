import 'package:flutter/material.dart';

class ButtonApp extends StatelessWidget {
  Color color;
  Color textColor;
  String text;
  Function onPressed;

  ButtonApp({
    this.color = Colors.black,
    this.textColor = Colors.white,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
