// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import '../storage/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ApiHandler extends FullLifeCycleController {
  var url = 'http://192.168.254.102:8000';
  

  var accesstoken = '';
  getToken(String token) async {
    accesstoken = token;
  }
    
  var username = '';
  loginUser()async{
    final response = await http.post(
      Uri.parse('$url/auth/user-profile'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accesstoken',
      }
    );
    Map<String, dynamic> map = json.decode(response.body);
    username = map['user_name'];
    print(username);
  }

  var emailsave = '';
  emailSave(String email) async {
    emailsave = email;
    MyStorage.setPref(email);
    // print(emailpref);
  }

  bool isloggedin = false;
  autologin() async {
    var emailpref = await MyStorage.getPref();
    var map = <String, dynamic>{};
    map['email'] = emailpref;
    final response = await http.post(
      Uri.parse('$url/auth/checkmail'),
      body: map
    );
    // print(map);
    // print(response.body);
    if(response.statusCode == 200){
      Map<String, dynamic> bodymap = json.decode(response.body);
      var newtoken = bodymap['token'];
      accesstoken = newtoken;
      isloggedin = true;
    } else {
      isloggedin = false;
    }
    
  }

  // var doctors = '';
  // loadDoctors()async{
  //   final response = await http.post(
  //     Uri.parse('$url/auth/doctors'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $accesstoken',
  //     }
  //   );
  //   Map<String, dynamic> map = json.decode(response.body);
  //   print(map);
  //   // doctors = map['user_'];
  //   // print('Doctors: $map');
  // }
}