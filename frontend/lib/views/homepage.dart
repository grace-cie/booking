import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import './tabs/home.dart';
import './tabs/book.dart';
import './tabs/search.dart';
import './tabs/profile.dart';
// import '../helpers/styles.dart';


void main() {
  runApp(const Homepage());
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  // static final title = 'salomon_bottom_bar';

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {

  var _currentIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(25, 20, 48, 1));
  static const baseColor = Color.fromRGBO(109, 85, 246, 1);

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeUi(),

    const BookUi(),

    const SearchDoctorUi(),
    
    const ProfileUi()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text(Homepage.title),
        // ),
        body: Center(
          child: _widgetOptions.elementAt(_currentIndex),
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home_rounded),
              title: const Text(
                "Home",
                style: optionStyle,
              ),
              selectedColor: baseColor
            ),

            SalomonBottomBarItem(
              icon: const Icon(Icons.edit_calendar_outlined),
              title: const Text(
                "Book Now",
                style: optionStyle,
              ),
              selectedColor: baseColor
            ),

            SalomonBottomBarItem(
              icon: const Icon(Icons.search),
              title: const Text(
                "Find Doctors",
                style: optionStyle,
              ),
              selectedColor: baseColor
            ),

            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text(
                "Profile",
                style: optionStyle,
              ),
              selectedColor: baseColor
            ),
          ],
        ),
      ),
    );
  }
}