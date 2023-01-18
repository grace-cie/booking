import 'package:shared_preferences/shared_preferences.dart';

class MyStorage {
  static setPref(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }



  static getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
    // print(res);
  }
}