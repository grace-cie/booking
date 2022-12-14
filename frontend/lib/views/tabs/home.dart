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

class HomeUiState extends State<HomeUi>{
  ApiHandler apifind = Get.find<ApiHandler>();

  @override
  Widget build(BuildContext context) {
    var name = apifind.username;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.purple,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              
            }, 
            child: Text(
              'Index 1: Home $name',
              // style: optionStyle,
            ),
          )
        ],
      ),
    );
  }
}