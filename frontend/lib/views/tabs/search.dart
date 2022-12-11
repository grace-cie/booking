import 'package:flutter/material.dart';

void main(){
  runApp(const SearchDoctorUi());
}

class SearchDoctorUi extends StatefulWidget {
  const SearchDoctorUi({super.key});

  @override
  State<StatefulWidget> createState() => SearchDoctorUiState();
}

class SearchDoctorUiState extends State<SearchDoctorUi>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.yellow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              
            }, 
            child: const Text(
              'Index 3: Profile',
              // style: optionStyle,
            ),
          )
        ],
      ),
    );
  }
}