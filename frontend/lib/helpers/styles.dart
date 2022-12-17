import 'package:flutter/material.dart';

// ignore: camel_case_types
class styles {
  static const maincolor = Color.fromRGBO(109, 85, 246, 1);
  static const basecolor = Color.fromRGBO(26, 26, 56, 1);
  static const grey = Color.fromRGBO(113, 114, 133, 1);
  static const white = Color.fromRGBO(255, 255, 255, 1);
  static const red = Color.fromARGB(255, 182, 26, 26);
  static const yellow = Color.fromARGB(255, 239, 246, 35);
  static const blue = Color.fromARGB(255, 0, 108, 248);
  static const black = Color.fromARGB(255, 0, 0, 0);
  static const customerr = TextStyle(fontFamily: 'Prompt', fontWeight: FontWeight.w100);
  static const customborder =  OutlineInputBorder(
    borderSide: BorderSide(
      width: 1,
      color: grey
    )
  );
}