import 'package:flutter/material.dart';

const formfield=InputDecoration(
    filled: true,
    fillColor: Color(0xff2A2C36),
    hintText: '',
    hintStyle: TextStyle(
      fontSize: 15.0,
      fontFamily: 'Nunito-Regular',
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: Color(0xff2A2C36), width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: Colors.red, width: 2.0),
    ),
);

const kfontfamily='Nunito-Regular';