import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  RoundButton(
      {required this.colour, required this.text, required this.onPressed});
  final Color colour;
  final Text text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: text,
        ),
      ),
    );
  }
}
