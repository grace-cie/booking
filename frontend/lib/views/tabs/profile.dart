import 'package:flutter/material.dart';

void main(){
  runApp(const ProfileUi());
}

class ProfileUi extends StatefulWidget {
  const ProfileUi({super.key});

  @override
  State<StatefulWidget> createState() => ProfileUiState();
}

class ProfileUiState extends State<ProfileUi>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              
            }, 
            child: const Text(
              'Index 0: Home',
              // style: optionStyle,
            ),
          )
        ],
      ),
    );
  }
}