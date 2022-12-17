import 'package:flutter/material.dart';
import 'package:frontend/controllers/booking-api-handler.dart';
import 'package:get/get.dart';


void main(){
  runApp(const HomeUi());
}

class HomeUi extends StatefulWidget {
  const HomeUi({super.key});

  @override
  State<StatefulWidget> createState() => HomeUiState();
}
ApiHandler apifind = Get.find<ApiHandler>();

class HomeUiState extends State<HomeUi>{
  
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
            'Welcome $username',
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