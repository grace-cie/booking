import 'package:flutter/material.dart';
import 'package:frontend/controllers/booking-api-handler.dart';
import 'package:get/get.dart';


void main(){
  runApp(const DocHomeUi());
}

class DocHomeUi extends StatefulWidget {
  const DocHomeUi({super.key});

  @override
  State<StatefulWidget> createState() => DocHomeUiState();
}
ApiHandler apifind = Get.find<ApiHandler>();

class DocHomeUiState extends State<DocHomeUi>{
  
  var username = apifind.username;
  @override
  Widget build(BuildContext context) {
    // getUserData();
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromRGBO(109, 85, 246, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome Dr.$username',
            style: const TextStyle(
              fontFamily: 'Prompt',
              color: Colors.white,
              fontSize: 40
            )
          )
        ],
      ),
    );
  }
}