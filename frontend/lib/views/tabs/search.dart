import 'package:flutter/cupertino.dart';

import '../../helpers/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/controllers/booking-api-handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';






class Doctor {
  // final int userId;
  final int id;
  final String username;
  final String firstname;
  final String middlename;
  final String lastname;
  final String address;
  final String suffix;
  final String email;
  final String phone;
  final String bio;
  final String status;
  final String userclass;
  final String createdat;

  Doctor({
    // required this.userId,
    required this.id,
    required this.username,
    required this.firstname,
    required this.middlename,
    required this.lastname,
    required this.address,
    required this.suffix,
    required this.email,
    required this.phone,
    required this.bio,
    required this.status,
    required this.userclass,
    required this.createdat,
  });    

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      // userId: json['userId'],
      id: json['id'],
      username: json['user_name'],
      firstname: json['first_name'],
      middlename: json['middle_name'],
      lastname: json['last_name'],
      address: json['address'],
      suffix: json['suffix'],
      email: json['email'],
      phone: json['phone'],
      bio: json['bio'],
      status: json['status'],
      userclass: json['user_class'],
      createdat: json['created_at'],
    );
  }
  
  // void add(List doctorslist) {}
}

void main(){
  runApp(const SearchDoctorUi());
}

class SearchDoctorUi extends StatefulWidget {
  const SearchDoctorUi({super.key});

  @override
  State<StatefulWidget> createState() => SearchDoctorUiState();
}

final apihandler = Get.put(ApiHandler());
ApiHandler apifind = Get.find<ApiHandler>();

Future<List<Doctor>> getDoctors() async {
  var token = apifind.accesstoken;
  final response = await http.post(
    Uri.parse('${apihandler.url}/auth/doctors'),
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
    }
  );
  if(response.statusCode == 200){
    var data = jsonDecode(response.body);
    List<Doctor>doctorslist = [];
    for(var u in data){
      Doctor doctors = Doctor(
        id: u['id'], 
        username: u['user_name'], 
        firstname: u['first_name'], 
        middlename: u['middle_name'], 
        lastname: u['last_name'], 
        address: u['address'], 
        suffix: u['suffix'], 
        email: u['email'], 
        phone: u['phone'], 
        bio: u['bio'], 
        status: u['status'], 
        userclass: u['user_class'], 
        createdat: u['created_at']
      );
      doctorslist.add(doctors);
    }
    return doctorslist;
  } else {
    throw Exception('Failed to load');
  }
}

class SearchDoctorUiState extends State<SearchDoctorUi>{
  bool isLoading = false;
  late Future<List<Doctor>> doctorlist;
  // static const maincolor = Color.fromRGBO(109, 85, 246, 1);
  // static const basecolor = Color.fromRGBO(26, 26, 56, 1);
  // static const grey = Color.fromRGBO(113, 114, 133, 1);
  // static const white = Color.fromRGBO(255, 255, 255, 1);
  // static const red = Color.fromARGB(255, 182, 26, 26);
  // static const yellow = Color.fromARGB(255, 239, 246, 35);
  // static const blue = Color.fromARGB(255, 0, 108, 248);
  // static const customerr = TextStyle(fontFamily: 'Prompt', fontWeight: FontWeight.w100);
  // static const customborder =  OutlineInputBorder(
  //   borderSide: BorderSide(
  //     width: 1,
  //     color: grey
  //   )
  // );

  @override
  void initState() {
    super.initState();
    doctorlist = getDoctors();
  }
  // cicularLoad(){
  //   isLoading = true;
  // }

  @override
  Widget build(BuildContext context) {
    // apihandler.loadDoctors();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: styles.maincolor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50), 
          child: AppBar(
            backgroundColor:styles.maincolor,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Doctors',
              style: TextStyle(
                fontFamily: 'Prompt',
                color: styles.white,
              ),
            ),
          )
        ),
        body: LoadingOverlay(
          isLoading: isLoading, 
          child:Center(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: FutureBuilder<List<Doctor>>(
                future: doctorlist,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return GridView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 0,
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: ListTile(
                                    isThreeLine: true,
                                    trailing: InkWell(
                                      onTap: () {
                                        Fluttertoast.showToast(
                                          msg: 'Add to favorites',
                                          // backgroundColor: const Color.fromARGB(255, 109, 140, 201),
                                          textColor: Colors.white,
                                        );
                                      },
                                      child: const Icon(Icons.favorite_border),
                                    ),
                                    leading: Image.asset('assets/images/doctor2.png', scale: 13,),
                                    title: Text(
                                      snapshot.data![index].username,
                                      style: const TextStyle(
                                        color: styles.basecolor, 
                                        fontFamily: 'Prompt',
                                        fontSize: 14
                                      ),
                                    ),
                                    subtitle: Text(
                                      snapshot.data![index].userclass,
                                      style: TextStyle(
                                        color: styles.black.withOpacity(0.6), 
                                        fontFamily: 'Prompt',
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                        child: Text(
                                          snapshot.data![index].bio,
                                          style: TextStyle(
                                            color: styles.black.withOpacity(0.6),
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold
                                          ),
                                          maxLines: 4
                                        ),
                                      )  
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: SizedBox(
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: (){
                                                  Fluttertoast.showToast(
                                                    msg: 'Profile Button',
                                                    // backgroundColor: const Color.fromARGB(255, 109, 140, 201),
                                                    textColor: Colors.white,
                                                  );
                                                },
                                                splashColor: styles.grey,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Row(
                                                      children: const [
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                          child: Icon(Icons.account_box_rounded, 
                                                          size: 20,
                                                          color: styles.maincolor,
                                                        ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                                          child: Text(
                                                            'Profile',
                                                            style: TextStyle(
                                                              fontFamily: 'Prompt',
                                                              color: styles.basecolor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: (){
                                                  showBarModalBottomSheet(
                                                    isDismissible: true,
                                                    context: context, 
                                                    builder: (BuildContext context) {
                                                      return Container(
                                                        height: 500,
                                                        color: Colors.amber,
                                                        child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            // mainAxisSize: MainAxisSize.min,
                                                            children: <Widget>[
                                                              Row(
                                                                children: <Widget>[
                                                                  ElevatedButton(
                                                                    child: const Text('Close BottomSheet'),
                                                                    onPressed: () => Navigator.pop(context),
                                                                  ),
                                                                ],
                                                              )
                                                              // const Text('Modal BottomSheet'),
                                                              
                                                            ],
                                                          ),
                                                        // child: Center(
                                                          
                                                        // ),
                                                      );
                                                    },
                                                    // isScrollControlled: true
                                                  );
                                                  // Fluttertoast.showToast(
                                                  //   msg: 'Book Button',
                                                  //   // backgroundColor: const Color.fromARGB(255, 109, 140, 201),
                                                  //   textColor: Colors.white,
                                                  // );
                                                },
                                                splashColor: styles.grey,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Row(
                                                      children: const [
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                                          child: Icon(Icons.calendar_month_rounded, 
                                                          size: 20,
                                                          color: styles.maincolor,
                                                        ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                                          child: Text(
                                                            'Book',
                                                            style: TextStyle(
                                                              fontFamily: 'Prompt',
                                                              color: styles.basecolor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        )
                                      ],
                                    )
                                  )
                                )
                              ],
                            ),
                            // title: Text(snapshot.data![index].username),
                            // subtitle: Text(snapshot.data![index].email),
                            // trailing: Text(snapshot.data![index].userclass),
                          ),
                        );
                        
                      }, 
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                    );
                  } else if(snapshot.hasError) {
                    return Text(snapshot.hasError.toString());
                  } else {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Padding(padding: EdgeInsets.fromLTRB(0, 300, 0, 0)),
                          SizedBox(
                            width: 100.0,
                            height: 100.0,
                              child: LoadingIndicator(
                              indicatorType: Indicator.ballPulseSync,
                              colors: [styles.red, styles.yellow, styles.blue], 
                              // strokeWidth: , 
                              // backgroundColor: Color.fromARGB(0, 0, 0, 0),
                              // pathBackgroundColor: Color.fromARGB(0, 0, 0, 0)
                            )
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            )
          ), 
        ),
      )
    ); 
  }
}