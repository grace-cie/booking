import 'package:flutter/material.dart';

void main(){
  runApp(const BookUi());
}

class BookUi extends StatefulWidget {
  const BookUi({super.key});

  @override
  State<StatefulWidget> createState() => BookUiState();
}

class BookUiState extends State<BookUi>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              
            }, 
            child: const Text(
              'Index 2: Search',
              // style: optionStyle,
            ),
          )
        ],
      ),
    );
  }
}