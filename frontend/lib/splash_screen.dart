import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/helpers/styles.dart';
import 'package:frontend/views/forms.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({required Key key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>{
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => MainForm()))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight, 
            colors: [
              Color.fromRGBO(109, 85, 246, 1),
              Color.fromRGBO(26, 26, 56, 1)
            ]
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/images/stethoscope.png',
                  height: 250.0,
                  width: 250.0,
                ),
                SizedBox(height: 50),
                Text(
                  'DocConnect',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: styles.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0,
                    fontFamily: 'Prompt'
                  ),
                )
              ],
            ),
            CircularProgressIndicator(
              color: styles.white,
            )
          ],
        ),
      ),
    );
  }
}