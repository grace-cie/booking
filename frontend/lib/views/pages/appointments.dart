// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:frontend/views/pages/dummypage.dart';
// import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
// // import './tabs/home.dart';
// // import './tabs/book.dart';
// // import './tabs/search.dart';
// // import './tabs/profile.dart';
// // import '../helpers/styles.dart';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
// import 'package:frontend/controllers/booking-api-handler.dart';


// void main() {
//   runApp(const Appointments());
// }

// class Appointments extends StatefulWidget {
//   const Appointments({super.key});

//   @override
//   AppointmentsState createState() => AppointmentsState();
// }

// ApiHandler apifind = Get.find<ApiHandler>();

// // logout() async {
// //   final response = await http.post(
// //     Uri.parse('${apihandler.url}/auth/logout'),
// //       headers: {
// //         'Content-Type': 'application/json',
// //         'Accept': 'application/json',
// //         'Authorization': 'Bearer ${apifind.accesstoken}',
// //     }
// //   );
// // }


// class AppointmentsState extends State<Appointments> {

//   // Future<bool> _onWillPop() async {
//   //   return (
//   //     await showDialog(
//   //       context: context,
//   //       builder: (context) => AlertDialog(
//   //         title: const Text('Are you sure?'),
//   //         content: const Text('Do you want to exit an App'),
//   //         actions: <Widget>[
//   //           TextButton(
//   //             onPressed: () {
//   //               Navigator.of(context).pop(false);
//   //             },
//   //             child: const Text('No'),
//   //           ),
//   //           TextButton(
              
//   //             onPressed: () {
//   //               logout();
//   //               Navigator.of(context).pop(true);
//   //             },
//   //             // onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
//   //             child: const Text('Yes'),
//   //           ),
//   //         ],
//   //       ),
//   //     )
//   //   ) ?? false;
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return  MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         home: Scaffold(
//           // appBar: AppBar(
//           //   title: Text(Appointments.title),
//           // ),
//           body: Center(
//             child: Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: (){
//                       Navigator.push(
//                         context, 
//                         MaterialPageRoute(
//                           builder: (
//                             BuildContext context
//                           ) => const DummyPage()
//                         )
//                       );
//                   }, 
//                   child: Text('trransfer')
//                 )
//               ],
//             ),
            
            
//           ),
//           bottomNavigationBar: null,
//         ),
//       );
//   }
// }