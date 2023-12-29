import 'package:flutter/material.dart';

const kTempStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 130.0,
  color: Colors.greenAccent,
);

const kMessageStyle1 = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 20.0,
  color: Color(0xFFC2C2CC),
);

const kMessageStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 50.0,
  color: Color(0xFFC2C2CC),
);

const kButtonStyle = TextStyle(
  fontSize: 30.0,
  fontFamily: 'Spartan MB',
  color: Colors.greenAccent,
);

const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  icon: Icon(
    Icons.add_location,
    size: 40.0,
    color: Colors.greenAccent,
  ),
  hintText: 'Enter city name',
  hintStyle: TextStyle(
    color: Color(0xFF0A0E21),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide.none,
  ),
);
