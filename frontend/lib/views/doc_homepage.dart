import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/views/doctabs/docbook.dart';
import 'package:frontend/views/doctabs/dochome.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import './tabs/home.dart';
import './tabs/book.dart';
import './tabs/search.dart';
import './tabs/profile.dart';
import '../helpers/styles.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:frontend/controllers/booking-api-handler.dart';


void main() {
  runApp(const DocHomepage());
}

class DocHomepage extends StatefulWidget {
  const DocHomepage({super.key});

  @override
  DocHomepageState createState() => DocHomepageState();
}

final apihandler = Get.put(ApiHandler());
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


class DocHomepageState extends State<DocHomepage> {

  Future<bool> _onWillPop() async {
    return (
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Hold on!',
            style: TextStyle(fontFamily: 'Prompt'),
          ),
          content: const Text(
            'Are you sure do you want to Logout?',
            style: TextStyle(fontFamily: 'Prompt', color: styles.grey),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                'NO',
                style: TextStyle(fontFamily: 'Prompt'),
              ),
            ),
            TextButton(
              onPressed: () {
                logout();
                Navigator.of(context).pop(true);
              },
              // onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              child: const Text(
                'LOGOUT',
                style: TextStyle(color: styles.red, fontFamily: 'Prompt'),
              ),
            ),
          ],
        ),
      )
    ) ?? false;
  }

  static var currentIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(25, 20, 48, 1));
  static const baseColor = Color.fromRGBO(109, 85, 246, 1);

  static final List<Widget> _widgetOptions = <Widget>[
    const DocHomeUi(),

    const DocBookUi(),

    // const SearchDoctorUi(),
    
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
          // extendBodyBehindAppBar: false,
          // resizeToAvoidBottomInset: true,
          // extendBody: true,
          // appBar: AppBar(
          //   title: Text(DocHomepage.title),
          // ),
          body: Center(
            child: _widgetOptions.elementAt(currentIndex),
          ),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: currentIndex,
            onTap: (i) => setState(() => currentIndex = i),
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
                icon: Stack(
                  children: <Widget>[
                    const Icon(Icons.edit_calendar_outlined),
                    Positioned(  // draw a red marble
                      top: 0,
                      bottom: 1,
                      left: 0,
                      child: Stack(
                        children: const [
                          Icon(Icons.brightness_1, size: 15, 
                            color: Colors.redAccent,
                          ),
                          Positioned(
                            top: 2,
                            left: 6,
                            child: Text(
                              '1',
                              style: TextStyle(
                                fontFamily: 'Prompt',
                                color: styles.white,
                                fontSize: 7
                              ),
                            )
                          )
                        ],
                      )
                      
                    )
                  ]
                ),
                title: const Text(
                  "Appointments",
                  style: optionStyle,
                ),
                selectedColor: baseColor
              ),

              // SalomonBottomBarItem(
              //   icon: const Icon(Icons.person_search_rounded),
              //   title: const Text(
              //     "Find Doctors",
              //     style: optionStyle,
              //   ),
              //   selectedColor: baseColor
              // ),

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