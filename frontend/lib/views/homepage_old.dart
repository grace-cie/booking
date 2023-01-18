import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'dart:io';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'tabs/home.dart';
import 'tabs/profile.dart';
import 'tabs/book.dart';
import 'tabs/search.dart';



void main(){
  runApp(const HomePageOld());
}

class HomePageOld extends StatefulWidget {
  const HomePageOld({super.key});

  @override
  State<StatefulWidget> createState() => HomePageOldState();
}


class HomePageOldState extends State<HomePageOld>{
  Future<bool> _onWillPop() async {
    return (
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to exit an App'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => SystemNavigator.pop(), // <-- SEE HERE
              child: const Text('Yes'),
            ),
          ],
        ),
      )
    ) ?? false;
  }
  
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  
  static final List<Widget> _widgetOptions = <Widget>[

    const HomeUi(),

    const BookUi(),

    const SearchDoctorUi(),
    
    const ProfileUi()
    
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
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
      ),
    );
  }
}