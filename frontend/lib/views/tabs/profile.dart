import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:frontend/helpers/styles.dart';
import 'package:get/get.dart';
import 'package:frontend/controllers/booking-api-handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loading_overlay/loading_overlay.dart';

class User {
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
  final String hcp;
  final String hcpaddr;
  final String userclass;
  // final String createdat;

  User({
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
    required this.hcp,
    required this.hcpaddr,
    required this.userclass,
    // required this.createdat,
  });    

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
      hcp: json['hcp'],
      hcpaddr: json['hcp_addr'],
      userclass: json['user_class'],
      // createdat: json['created_at'],
    );
  }
}

void main(){
  runApp(const ProfileUi());
}

class ProfileUi extends StatefulWidget {
  const ProfileUi({super.key});

  @override
  State<StatefulWidget> createState() => ProfileUiState();
}
final apihandler = Get.put(ApiHandler());
ApiHandler apifind = Get.find<ApiHandler>();

Future<User> getProfile() async {
  var token = apifind.accesstoken;
  final response = await http.post(
    Uri.parse('${apihandler.url}/auth/getusers'),
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
    }
  );
  if(response.statusCode == 200){
    var data = jsonDecode(response.body);
    // List<User>userlist = [];
    // data.forEach((key, value) { //use foreach because the data is not iliterable
    //   User users = User(
    //     // id: value['id'], 
    //     username: value['user_name'], 
    //     firstname: value['first_name'], 
    //     middlename: value['middle_name'], 
    //     lastname: value['last_name'], 
    //     address: value['address'], 
    //     suffix: value['suffix'], 
    //     email: value['email'], 
    //     phone: value['phone'], 
    //     bio: value['bio'], 
    //     status: value['status'], 
    //     hcp: value['hcp'],
    //     hcpaddr: value['hcp_addr'],
    //     userclass: value['user_class'], 
    //     // createdat: value['created_at']
    //   );
    //   userlist.add(users);
    // });
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load');
  }
  // if(response.statusCode == 200){
  //   var data = jsonDecode(response.body);
  //   List<User>userlist = [];
  //   for(var u in data){
  //     User users = User(
  //       id: u['id'], 
  //       username: u['user_name'], 
  //       firstname: u['first_name'], 
  //       middlename: u['middle_name'], 
  //       lastname: u['last_name'], 
  //       address: u['address'], 
  //       suffix: u['suffix'], 
  //       email: u['email'], 
  //       phone: u['phone'], 
  //       bio: u['bio'], 
  //       status: u['status'], 
  //       hcp: u['hcp'],
  //       hcpaddr: u['hcp_addr'],
  //       userclass: u['user_class'], 
  //       // createdat: u['created_at']
  //     );
  //     userlist.add(users);
  //   }
  //   return userlist;
  // } else {
  //   throw Exception('Failed to load');
  // }
}

class ProfileUiState extends State<ProfileUi>{
  bool isLoading = false;
  late Future<User> userprofile;

  @override
  void initState() {
    super.initState();
    userprofile = getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LoadingOverlay(
          isLoading: isLoading,
          child: Center(
            child: FutureBuilder<User>(
              future: userprofile,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  // return ListView.builder(
                    // itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://images.unsplash.com/photo-1580981794240-a0c7e5d10b1a?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  snapshot.data!.username,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data!.email,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80"),
                                          fit: BoxFit.cover)),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(30),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Name",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 1,
                                      color: Colors.grey[300],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      snapshot.data!.username,
                                        style: TextStyle(
                                        fontSize: 18,
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text(snapshot.data!.email),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text(snapshot.data!.phone),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.location_on),
                            title: Text(snapshot.data!.address),
                          ),
                          TextButton(
                              child: Text("Edit Profile"),
                              onPressed: () {
                              // navigate to edit profile screen or perform other actions
                              },
                          )
                        ],
                      );
                    // },
                  // );
                } else if(snapshot.hasError){
                  return Align(
                    alignment: Alignment.center,
                    child: Text(
                      snapshot.error.toString(),
                      style: TextStyle(
                          fontFamily: 'Prompt',
                          fontSize: 15,
                          color: styles.black
                        ),
                    ),
                  );
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
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            )
          )
        ),
      )
    );
  }
}