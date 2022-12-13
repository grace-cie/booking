import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class ApiHandler extends GetxController {
  var url = 'http://192.168.254.103:8000';
  var passid = '';
  var urlres = '';

  var finalstatus = '';
  var statuscode = '';

  exeApiStatusCode(){
    return finalstatus = statuscode;
  }
}

