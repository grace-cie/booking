import 'package:flutter/material.dart';

void main(){
  runApp(const HomeUi());
}

class HomeUi extends StatefulWidget {
  const HomeUi({super.key});

  @override
  State<StatefulWidget> createState() => HomeUiState();
}

class HomeUiState extends State<HomeUi>{
  @override
  Widget build(BuildContext context) {
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
            child: const Text(
              'Index 1: Book Appointment',
              // style: optionStyle,
            ),
          )
        ],
      ),
    );
  }
}