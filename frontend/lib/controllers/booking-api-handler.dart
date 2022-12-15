import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;


class ApiHandler extends GetxController {
  var url = 'http://192.168.254.103:8000';



  login(String name){
    // username = name;
    
  }


  var accesstoken = '';
  var username = '';
  getToken(String token) async {
    accesstoken = token;
    final response = await http.post(
      Uri.parse('$url/auth/user-profile'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );
    if(response.statusCode != 200){
      throw Exception('Failed');
    } else {
      Map<String, dynamic> map = json.decode(response.body);
      username = map['user_name'];
    }
    // result =  (response.body);
  }
}

