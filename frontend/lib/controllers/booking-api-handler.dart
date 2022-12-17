import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;


class ApiHandler extends GetxController {
  var url = 'http://192.168.254.103:8000';

  var accesstoken = '';
    getToken(String token){
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
  emailSave(String email){
    emailsave = email;
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

