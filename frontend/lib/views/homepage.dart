import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import './tabs/home.dart';
import './tabs/book.dart';
import './tabs/search.dart';
import './tabs/profile.dart';
// import '../helpers/styles.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:frontend/controllers/booking-api-handler.dart';


void main() {
  runApp(const Homepage());
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  HomepageState createState() => HomepageState();
}

ApiHandler apifind = Get.find<ApiHandler>();

logout() async {
  final response = await http.post(
    Uri.parse('${apihandler.url}/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${apifind.accesstoken}',
    }
  );
}


class HomepageState extends State<Homepage> {

  Future<bool> _onWillPop() async {
    return (
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to exit an App'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              
              onPressed: () {
                logout();
                Navigator.of(context).pop(true);
              },
              // onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              child: const Text('Yes'),
            ),
          ],
        ),
      )
    ) ?? false;
  }

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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: MaterialApp(
        restorationScopeId: "root",
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
                  "Appointments",
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
      ),
    );
  }
}