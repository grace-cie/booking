// @dart=2.9
import 'package:flutter/material.dart';
import './views/forms.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainForm(),
    );
  }
}