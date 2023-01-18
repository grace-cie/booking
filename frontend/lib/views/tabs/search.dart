import 'dart:async';
import 'package:frontend/views/tabs/book.dart';

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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:strings/strings.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';


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
  final String hcp;
  final String hcpaddr;
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
    required this.hcp,
    required this.hcpaddr,
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
      hcp: json['hcp'],
      hcpaddr: json['hcp_addr'],
      userclass: json['user_class'],
      createdat: json['created_at'],
    );
  }
}

class ProfileOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => styles.maincolor;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      
      // make sure that the overlay content is not cut off
      child: FadeTransition(
        opacity: animation,
          child: SafeArea(
          child: _buildOverlayContent(context),
        ),
      )
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'This is a nice overlay',
            style: TextStyle(color: Colors.white, fontSize: 10.0),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Dismiss'),
          )
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

void main(){
  runApp(const SearchDoctorUi());
}

class SearchDoctorUi extends StatefulWidget {
  const SearchDoctorUi({super.key});

  @override
  State<StatefulWidget> createState() => SearchDoctorUiState();
}
final RoundedLoadingButtonController bookbutton = RoundedLoadingButtonController();
final apihandler = Get.put(ApiHandler());
ApiHandler apifind = Get.find<ApiHandler>();
var datenow = DateTime.now();
var yearnow = DateFormat('yyyy').format(datenow);
var mthnow = DateFormat('MM').format(datenow);
var today = datenow.day;
var lastday = DateTime(datenow.year, datenow.month + 1, 0).day;
DateFormat formatter = DateFormat('yyyy-MM-dd');
DateFormat timeformatter = DateFormat('HH:mm:ss');
DateFormat timeformatjm = DateFormat('jm');

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
        hcp: u['hcp'],
        hcpaddr: u['hcp_addr'],
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

void bookDoctor(context ,String doctorId, String scheduledIn, String status) async {
  var token = apifind.accesstoken;
  var map = <String, dynamic>{};
    map['doctor_id'] = doctorId;
    map['scheduled_in'] = scheduledIn;
    map['status'] = status;
  final response = await http.post(
    Uri.parse('${apihandler.url}/auth/book-doctor'),
    headers: {
      'Authorization': 'Bearer $token',
    },
    body: map
  );
  Map<String, dynamic> mapp = await json.decode(response.body);
  var message = mapp['message'];
  if(response.statusCode == 200){
    bookbutton.reset();
    Fluttertoast.showToast(
      msg: message,
      // backgroundColor: const Color.fromARGB(255, 109, 140, 201),
      textColor: Colors.white,
    );
    Navigator.pop(context);
  } else {
    bookbutton.reset();
    Fluttertoast.showToast(
      msg: message,
      // backgroundColor: const Color.fromARGB(255, 109, 140, 201),
      textColor: Colors.white,
    );
  }
}

class SearchDoctorUiState extends State<SearchDoctorUi>{
  bool isLoading = false;
  late Future<List<Doctor>> doctorlist;

  @override
  void initState() {
    super.initState();
    doctorlist = getDoctors();
  }

  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(ProfileOverlay());
  }



  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController datecont = TextEditingController();
    TextEditingController timecont = TextEditingController();
    TextEditingController validtime = TextEditingController();
    
    
    // apihandler.loadDoctors();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: styles.maincolor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50), 
          child: AppBar(
            backgroundColor:styles.maincolor,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Popular Doctors',
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
                                                onTap: () => _showOverlay(context),
                                                // onTap: () {
                                                //   Future.delayed(const Duration(seconds: 2)).then((_){
                                                //     Navigator.push(
                                                //       context, 
                                                //       MaterialPageRoute(
                                                //         builder: (
                                                //           BuildContext context
                                                //         ) => const BookUi()
                                                //       )
                                                //     );
                                                //   });
                                                // },
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
                                                    shape: const Border(
                                                      top: BorderSide(
                                                        color: Colors.transparent,
                                                        // width: 0.0,
                                                      ),
                                                      bottom: BorderSide(
                                                        color: Colors.transparent,
                                                        width: 0.0,
                                                      ),
                                                    ),
                                                    isDismissible: true,
                                                    context: context, 
                                                    builder: (BuildContext context) {
                                                      return SingleChildScrollView(
                                                        child: Container(
                                                          height: 500,
                                                          color: styles.white,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: <Widget>[
                                                              Row(
                                                                children: <Widget>[
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                                      child: SizedBox(
                                                                        height: 455,
                                                                        width: 300,
                                                                        child: Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                                              child: Card(
                                                                                elevation: 0,
                                                                                child: ListTile(
                                                                                  leading: Image.asset('assets/images/doctor2.png', scale: 8,),
                                                                                  title: Text(
                                                                                    'About Doctor ${capitalize(snapshot.data![index].firstname)}',
                                                                                    style: const TextStyle(
                                                                                      fontFamily: 'Prompt',
                                                                                      fontSize: 13,
                                                                                      color: styles.basecolor
                                                                                    ),
                                                                                  ),
                                                                                  subtitle: Text(
                                                                                    'Dr. ${capitalize(snapshot.data![index].lastname)} is an experienced specialist who is constantly working on improving her skills.',
                                                                                    style: const TextStyle(
                                                                                      fontFamily: 'Prompt',
                                                                                      fontWeight: FontWeight.w100,
                                                                                      fontSize: 11,
                                                                                      color: styles.grey
                                                                                    ),
                                                                                    maxLines: 4
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                                              child: Card(
                                                                                elevation: 0,
                                                                                child: ListTile(
                                                                                  leading: Image.asset('assets/images/hospital.png', scale: 8,),
                                                                                  title: Text(
                                                                                    snapshot.data![index].hcp,
                                                                                    style: const TextStyle(
                                                                                      fontFamily: 'Prompt',
                                                                                      fontSize: 13,
                                                                                      color: styles.basecolor
                                                                                    ),
                                                                                  ),
                                                                                  subtitle: Text(
                                                                                    snapshot.data![index].hcpaddr,
                                                                                    style: const TextStyle(
                                                                                      fontFamily: 'Prompt',
                                                                                      fontWeight: FontWeight.w100,
                                                                                      fontSize: 11,
                                                                                      color: styles.grey
                                                                                    ),
                                                                                    maxLines: 4
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const Padding(
                                                                              padding: EdgeInsets.fromLTRB(0, 10, 210, 0),
                                                                              child: Text(
                                                                                'Make an Appointment :',
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Prompt',
                                                                                  color: styles.darkergrey
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Form(
                                                                              key: formKey,
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: TextFormField(
                                                                                            controller: datecont,
                                                                                            onTap: () async {
                                                                                              DatePicker.showDatePicker(
                                                                                                  context,
                                                                                                  showTitleActions: true,
                                                                                                  minTime: DateTime(int.parse(yearnow), int.parse(mthnow), today),
                                                                                                  maxTime: DateTime(int.parse(yearnow), int.parse(mthnow), lastday),
                                                                                                  theme: const DatePickerTheme(
                                                                                                    headerColor: styles.white,
                                                                                                    backgroundColor: styles.white,
                                                                                                    itemStyle: TextStyle(
                                                                                                        color: styles.black,
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                        fontSize: 18
                                                                                                    ),
                                                                                                    doneStyle: TextStyle(
                                                                                                      color: styles.black, 
                                                                                                      fontSize: 16,
                                                                                                      fontFamily: 'Prompt'
                                                                                                    ),
                                                                                                    cancelStyle: TextStyle(
                                                                                                      color: styles.red, 
                                                                                                      fontSize: 16,
                                                                                                      fontFamily: 'Prompt'
                                                                                                    ),
                                                                                                  ),
                                                                                                  onChanged: (date) {
                                                                                                  // print('change ${formatter.format(date)}');
                                                                                                }, onConfirm: (date) {
                                                                                                  print('confirm ${formatter.format(date)}');  
                                                                                                  datecont.text = formatter.format(date);
                                                                                                }, currentTime: DateTime.now(), locale: LocaleType.en
                                                                                              );
                                                                                            },
                                                                                            validator: (value) {
                                                                                              if (value == null || value.isEmpty) {
                                                                                                return 'Please Select Date';
                                                                                              }
                                                                                              return null;
                                                                                            },
                                                                                            readOnly: true,
                                                                                            decoration: const InputDecoration(
                                                                                              prefixIcon: Icon(Icons.calendar_month_outlined, color: styles.maincolor),
                                                                                              border: OutlineInputBorder(),
                                                                                              enabledBorder: styles.customborder,
                                                                                              focusedBorder: styles.customborder,
                                                                                              errorBorder: styles.customborder,
                                                                                              errorStyle: styles.customerr,
                                                                                              focusedErrorBorder: styles.customborder,
                                                                                              labelText: 'Select Prefered Date',
                                                                                              labelStyle: TextStyle(
                                                                                                color: styles.grey,
                                                                                                fontFamily: 'Prompt'
                                                                                              )
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: TextFormField(
                                                                                            controller: timecont,
                                                                                            onTap: () {
                                                                                              DatePicker.showTime12hPicker(
                                                                                                context,
                                                                                                showTitleActions: true,
                                                                                                // minTime: DateTime(int.parse(yearnow), int.parse(mthnow), today),
                                                                                                // maxTime: DateTime(int.parse(yearnow), int.parse(mthnow), lastday),
                                                                                                theme: const DatePickerTheme(
                                                                                                  headerColor: styles.white,
                                                                                                  backgroundColor: styles.white,
                                                                                                  itemStyle: TextStyle(
                                                                                                      color: styles.black,
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                      fontSize: 18
                                                                                                  ),
                                                                                                  doneStyle: TextStyle(
                                                                                                    color: styles.black, 
                                                                                                    fontSize: 16,
                                                                                                    fontFamily: 'Prompt'
                                                                                                  ),
                                                                                                  cancelStyle: TextStyle(
                                                                                                    color: styles.red, 
                                                                                                    fontSize: 16,
                                                                                                    fontFamily: 'Prompt'
                                                                                                  ),
                                                                                                ),
                                                                                                onChanged: (time) {
                                                                                                  // print('change ${timeformatter.format(time)}');
                                                                                                }, onConfirm: (time) {
                                                                                                  print('confirm ${timeformatter.format(time)}');
                                                                                                  print('confirm ${timeformatjm.format(time)}');
                                                                                                  validtime.text = timeformatter.format(time);
                                                                                                  timecont.text = timeformatjm.format(time);
                                                                                                }, currentTime: DateTime.now(), locale: LocaleType.en
                                                                                              );
                                                                                            },
                                                                                            validator: (value) {
                                                                                              if (value == null || value.isEmpty) {
                                                                                                return 'Please Select Time';
                                                                                              }
                                                                                              return null;
                                                                                            },
                                                                                            readOnly: true,
                                                                                            decoration: const InputDecoration(
                                                                                              prefixIcon: Icon(Icons.access_time_rounded, color: styles.maincolor),
                                                                                              border: OutlineInputBorder(),
                                                                                              enabledBorder: styles.customborder,
                                                                                              focusedBorder: styles.customborder,
                                                                                              errorBorder: styles.customborder,
                                                                                              errorStyle: styles.customerr,
                                                                                              focusedErrorBorder: styles.customborder,
                                                                                              labelText: 'Select Prefered Time',
                                                                                              labelStyle: TextStyle(
                                                                                                color: styles.grey,
                                                                                                fontFamily: 'Prompt'
                                                                                              )
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: Container(
                                                                                            height: 50,
                                                                                            alignment: Alignment.bottomCenter,
                                                                                            decoration: BoxDecoration(
                                                                                              color: styles.maincolor,
                                                                                              borderRadius: BorderRadius.circular(5)
                                                                                            ),
                                                                                            child: RoundedLoadingButton(
                                                                                              elevation: 0,
                                                                                              color: styles.maincolor,
                                                                                              onPressed: () {
                                                                                                if(formKey.currentState!.validate()){
                                                                                                  var merged = '${datecont.text} ${validtime.text}';
                                                                                                  var status = 'scheduled';
                                                                                                  bookDoctor(context , snapshot.data![index].id.toString(), merged, status);
                                                                                                  Timer(const Duration(seconds: 20), (){});
                                                                                                } else {
                                                                                                  bookbutton.reset();
                                                                                                }
                                                                                              }, 
                                                                                              controller: bookbutton,
                                                                                              child: const Text(
                                                                                                'Book Now',
                                                                                                style: TextStyle(
                                                                                                  color: styles.white,
                                                                                                  fontFamily: 'Prompt',
                                                                                                  fontSize: 18
                                                                                                ),
                                                                                              )
                                                                                            ),
                                                                                          )
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  )
                                                                                ],
                                                                              )
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    )
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      );
                                                    },
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