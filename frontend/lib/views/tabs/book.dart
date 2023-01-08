import 'package:flutter/material.dart';
import 'package:frontend/helpers/styles.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../../controllers/booking-api-handler.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';


class Appointments {
  final int id;
  final String apptrackid;
  final String doctor;
  final String patient;
  final String sched;
  final String findings;
  final String presc;
  final String notes;
  final String status;
  
  Appointments({
    required this.id,
    required this.apptrackid,
    required this.doctor,
    required this.patient,
    required this.sched,
    required this.findings,
    required this.presc,
    required this.notes,
    required this.status,
  });

  factory Appointments.fromJson(Map<String, dynamic> json) {
    return Appointments(
      id: json['id'],
      apptrackid: json['appointment_tracking_id'],
      doctor: json['doctor'],
      patient: json['patient'],
      sched: json['scheduled_view'],
      findings: json['findings'],
      presc: json['prescription'],
      notes: json['notes'],
      status: json['status'],
    );
  }
}

void main(){
  runApp(const BookUi());
}

class BookUi extends StatefulWidget {
  const BookUi({super.key});

  @override
  State<StatefulWidget> createState() => BookUiState();
}
final apihandler = Get.put(ApiHandler());
ApiHandler apifind = Get.find<ApiHandler>();

Future<List<Appointments>> getAppointments() async {
  var token = apifind.accesstoken;
  final response = await http.post(
    Uri.parse('${apihandler.url}/auth/my-appointments'),
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
    }
  );
  if(response.statusCode == 200){
    var data = jsonDecode(response.body);
    List<Appointments>appointmentslist = [];
    for(var a in data){
      Appointments apps = Appointments(
        id: a['id'], 
        apptrackid: a['appointment_tracking_id'], 
        doctor: a['doctor'], 
        patient: a['patient'], 
        sched: a['scheduled_view'], 
        findings: a['findings'], 
        presc: a['prescription'], 
        notes: a['notes'], 
        status: a['status'], 
      );
      appointmentslist.add(apps);
    }
    return appointmentslist;
  } else {
    throw Exception('Failed to load');
  }
}

class BookUiState extends State<BookUi>{
  bool isLoading = false;
  late Future<List<Appointments>> appointmentlist;

  @override
  void initState() {
    super.initState();
    appointmentlist = getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: styles.maincolor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: styles.maincolor,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'My Appointments',
              style: TextStyle(
                fontFamily: 'Prompt',
                color: styles.white
              ),
            ),
          ),
        ),
        body: LoadingOverlay(
          isLoading: isLoading,
          child: Center(
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: FutureBuilder<List<Appointments>>(
                future: appointmentlist,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          // height: 500
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: ListTile(
                                    isThreeLine: true,
                                    leading: Image.asset('assets/images/online.png', scale: 10,),
                                    title: Text(
                                      'Dr.${snapshot.data![index].doctor}',
                                      style: const TextStyle(
                                        color: styles.basecolor, 
                                        fontFamily: 'Prompt',
                                        fontSize: 14
                                      ),
                                    ),
                                    subtitle: Text(
                                      snapshot.data![index].sched,
                                      style: TextStyle(
                                        color: styles.black.withOpacity(0.6), 
                                        fontFamily: 'Prompt',
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              'TRACKING NUMBER : ${snapshot.data![index].apptrackid}',
                                              style: TextStyle(
                                                color: styles.black.withOpacity(0.6),
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold
                                              ),
                                              maxLines: 4
                                            ),
                                            const SizedBox(
                                              height: 0,
                                              width: 100,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    'Status : ',
                                                    style: styles.defaultytext,
                                                    maxLines: 4
                                                  ),
                                                  Text(
                                                    snapshot.data![index].status,
                                                    style: snapshot.data![index].status == 'cancelled'
                                                      ? styles.dangertext : styles.maintext,
                                                    maxLines: 4
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ) 
                                      )
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }, 
                      // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //   crossAxisCount: 1,
                      // ),
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
            ),
          ),
        ),
      ),
    );
  }
}