import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class ApiHandler extends GetxController {
  var url = 'http://192.168.254.103:8000';

  var username = '';
  login(String name){
    username = name;
  }
}

