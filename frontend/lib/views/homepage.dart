import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'tabs/home.dart';
import 'tabs/profile.dart';
import 'tabs/book.dart';
import 'tabs/search.dart';



void main(){
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  
  static final List<Widget> _widgetOptions = <Widget>[
    
    const ProfileUi(),
    
    const HomeUi(),
    
    const BookUi(),
    
    const SearchDoctorUi()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: GNav(
        tabBorderRadius: 15, 
        gap: 8, // the tab button gap between icon and text 
        color: Colors.white60, // unselected icon color
        activeColor: Colors.white, // selected icon and text color
        iconSize: 24, // tab button icon size
        backgroundColor: const Color.fromARGB(255, 109, 140, 201),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15), 
        tabs: const [
          GButton(
            icon: Icons.home_rounded,
            text: 'Home',
            style: GnavStyle.oldSchool,
          ),
          GButton(
            icon: Icons.edit_calendar_outlined,
            text: 'Book Now',
          ),
          GButton(
            icon: Icons.search,
            text: 'Find Doctors',
          ),
          GButton(
            icon: Icons.account_circle_sharp,
            text: 'Profile',
          )
        ],
        onTabChange: (int i) {
          print(i);
          setState(() {
            _selectedIndex = i;
          });
        },
      ),
    );
  }
}