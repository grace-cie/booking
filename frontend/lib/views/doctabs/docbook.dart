import 'package:flutter/material.dart';
import 'package:frontend/helpers/styles.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../../controllers/booking-api-handler.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'; 
import 'package:rounded_loading_button/rounded_loading_button.dart';


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
  runApp(const DocBookUi());
}

class DocBookUi extends StatefulWidget {
  const DocBookUi({super.key});

  @override
  State<StatefulWidget> createState() => DocBookUiState();
}
final RoundedLoadingButtonController cancelbutton = RoundedLoadingButtonController();
final RoundedLoadingButtonController completebutton = RoundedLoadingButtonController();
final apihandler = Get.put(ApiHandler());
ApiHandler apifind = Get.find<ApiHandler>();

Future<List<Appointments>> getAppointments() async {
  var token = apifind.accesstoken;
  final response = await http.post(
    Uri.parse('${apihandler.url}/auth/doc-appointments'),
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

class DocBookUiState extends State<DocBookUi>{
  bool isLoading = false;
  late Future<List<Appointments>> appointmentlist;

  @override
  void initState() {
    super.initState();
    appointmentlist = getAppointments();
  }

  cancelAppointment(context ,String id) async{
    var token = apifind.accesstoken;
    final response = await http.post(
      Uri.parse('${apihandler.url}/auth/cancel-appointment/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> mapp = await json.decode(response.body);
    var message = mapp['message'];
    if(response.statusCode == 200){
      cancelbutton.reset();
      Fluttertoast.showToast(
        msg: message,
        // backgroundColor: const Color.fromARGB(255, 109, 140, 201),
        textColor: Colors.white,
      );
      
      // Navigator.pop(context);
      await Future.delayed(const Duration(seconds: 1)).then((_){
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (
              BuildContext context
            ) => const DocBookUi()
          )
        ); 
      });

    } else {
      cancelbutton.reset();
      Fluttertoast.showToast(
        msg: message,
        textColor: Colors.white,
      );
    }
  }

  completeAppointment(context ,String id) async{
    var token = apifind.accesstoken;
    final response = await http.post(
      Uri.parse('${apihandler.url}/auth/complete-appointment/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> mapp = await json.decode(response.body);
    var message = mapp['message'];
    if(response.statusCode == 200){
      completebutton.reset();
      Fluttertoast.showToast(
        msg: message,
        // backgroundColor: const Color.fromARGB(255, 109, 140, 201),
        textColor: Colors.white,
      );
      
      // Navigator.pop(context);
      await Future.delayed(const Duration(seconds: 1)).then((_){
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (
              BuildContext context
            ) => const DocBookUi()
          )
        ); 
      });

    } else {
      completebutton.reset();
      Fluttertoast.showToast(
        msg: message,
        textColor: Colors.white,
      );
    }
  }

  addFpn(String id, String findings, String presc, String notes)async{
    var token = apifind.accesstoken;
    var map = <String, dynamic>{};
    map['findings'] = findings;
    map['prescription'] = presc;
    map['notes'] = notes;

    final response = await http.post(
      Uri.parse('${apihandler.url}/auth/add-fpn/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: map
    );

    Map<String, dynamic> mapp = await json.decode(response.body);
    var message = mapp['message'];

    if(response.statusCode == 200){
      Fluttertoast.showToast(
        msg: message,
        textColor: Colors.white,
      );
      // Navigator.of(context).pop(false);
    }else{
      Fluttertoast.showToast(
        msg: message,
        textColor: Colors.white,
      );
      completebutton.reset();
      throw Exception('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final FPNkey = GlobalKey<FormState>();
    final findingsctrl = TextEditingController();
    final prescctrl = TextEditingController();
    final notesctrl = TextEditingController();
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
              'Doctors Appointments',
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
                                    trailing: InkWell(
                                      onTap: () {
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
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          'Appointment Details',
                                                          style: TextStyle(
                                                            fontFamily: 'Prompt',
                                                            fontSize: 15,
                                                            color: styles.black
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            // SizedBox(height: 16),
                                                            // Container(
                                                            //   width: 60,
                                                            //   height: 60,
                                                            //   child: Image.asset('assets/images/examination.png', scale: 8,),
                                                            // ),
                                                            // SizedBox(height: 3),  
                                                            Text(
                                                              '${snapshot.data![index].patient}',
                                                              style: TextStyle(
                                                                fontFamily: 'Prompt',
                                                                color: styles.basecolor,
                                                                fontSize: 20
                                                              ),
                                                            ),
                                                            SizedBox(height: 3),
                                                            Text(
                                                              'Tracking ID : ${snapshot.data![index].apptrackid}',
                                                              style: TextStyle(
                                                                fontFamily: 'Prompt',
                                                                color: styles.basecolor
                                                              ),
                                                            ),
                                                            SizedBox(height: 3),
                                                            Text(
                                                              'Status : ${snapshot.data![index].status}',
                                                              style: TextStyle(
                                                                fontFamily: 'Prompt',
                                                                color: styles.basecolor
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    snapshot.data![index].status == 'cancelled' || snapshot.data![index].status == 'completed'
                                                    ? Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                      child: Card(
                                                        color: styles.maincolor,
                                                        child: ListTile(
                                                          // isThreeLine: true,
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => AlertDialog(
                                                                title: const Text(
                                                                  'Finding Details',
                                                                  style: TextStyle(fontFamily: 'Prompt'),
                                                                ),
                                                                content: Text(
                                                                  snapshot.data![index].findings == null
                                                                  ? 'No Findings Yet' 
                                                                  : snapshot.data![index].findings,
                                                                  style: TextStyle(fontFamily: 'Prompt', color: styles.grey),
                                                                ),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop(false);
                                                                    },
                                                                    child: const Text(
                                                                      'Ok',
                                                                      style: TextStyle(fontFamily: 'Prompt'),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );

                                                          },
                                                          leading: Image.asset('assets/images/hospital2.png', scale: 13,),
                                                          title: Text(
                                                            'Findings',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontFamily: 'Prompt',
                                                            ),
                                                          ),
                                                          subtitle: Text(
                                                            snapshot.data![index].findings == null
                                                            ? 'No Findings Yet' 
                                                            : snapshot.data![index].findings,
                                                            style: TextStyle(
                                                              fontFamily: 'Prompt'
                                                            ),
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      )
                                                    ) : Column(),
                                                    snapshot.data![index].status == 'cancelled' || snapshot.data![index].status == 'completed'
                                                    ? Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: Card(
                                                        color: styles.maincolor,
                                                        child: ListTile(
                                                          // isThreeLine: true,
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => AlertDialog(
                                                                title: const Text(
                                                                  'Prescription Details',
                                                                  style: TextStyle(fontFamily: 'Prompt'),
                                                                ),
                                                                content: Text(
                                                                  snapshot.data![index].presc == null
                                                                  ? 'No Prescription Added Yet' 
                                                                  : snapshot.data![index].presc,
                                                                  style: TextStyle(fontFamily: 'Prompt', color: styles.grey),
                                                                ),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop(false);
                                                                    },
                                                                    child: const Text(
                                                                      'Ok',
                                                                      style: TextStyle(fontFamily: 'Prompt'),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                          leading: Image.asset('assets/images/prescription.png', scale: 13,),
                                                          title: Text(
                                                            'Prescription',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontFamily: 'Prompt',
                                                            ),
                                                          ),
                                                          subtitle: Text(
                                                            snapshot.data![index].presc == null
                                                            ? 'No Prescription Added Yet' 
                                                            : snapshot.data![index].presc,
                                                            style: TextStyle(
                                                              fontFamily: 'Prompt'
                                                            ),
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      )
                                                    ) : Column(),
                                                    snapshot.data![index].status == 'cancelled' || snapshot.data![index].status == 'completed'
                                                    ? Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: Card(
                                                        color: styles.maincolor,
                                                        child: ListTile(
                                                          // isThreeLine: true,
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => AlertDialog(
                                                                title: const Text(
                                                                  'Note Details',
                                                                  style: TextStyle(fontFamily: 'Prompt'),
                                                                ),
                                                                content: Text(
                                                                  snapshot.data![index].notes == null
                                                                  ? 'No Notes Added Yet' 
                                                                  : snapshot.data![index].notes,
                                                                  style: TextStyle(fontFamily: 'Prompt', color: styles.grey),
                                                                ),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop(false);
                                                                    },
                                                                    child: const Text(
                                                                      'Ok',
                                                                      style: TextStyle(fontFamily: 'Prompt'),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                          leading: Image.asset('assets/images/notes.png', scale: 13,),
                                                          title: Text(
                                                            'Notes',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontFamily: 'Prompt',
                                                            ),
                                                          ),
                                                          subtitle: Text(
                                                            snapshot.data![index].notes == null 
                                                            ? 'No Notes Added Yet' 
                                                            : snapshot.data![index].notes,
                                                            style: TextStyle(
                                                              fontFamily: 'Prompt',
                                                            ),
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      )
                                                    ) : Column(),

                                                    //----- inputs
                                                    snapshot.data![index].status == 'cancelled' || snapshot.data![index].status == 'completed'
                                                    ? Column()
                                                    : Form(
                                                      key: FPNkey,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(10),
                                                            child: TextFormField(
                                                              controller: findingsctrl,
                                                              // obscureText: true,
                                                              decoration: const InputDecoration(
                                                                prefixIcon: Icon(Icons.find_in_page_rounded, color: styles.maincolor),
                                                                border: OutlineInputBorder(),
                                                                enabledBorder: styles.customborder,
                                                                focusedBorder: styles.customborder,
                                                                errorBorder: styles.customborder,
                                                                errorStyle: styles.customerr,
                                                                focusedErrorBorder: styles.customborder,
                                                                labelText: 'Add Findings',
                                                                labelStyle: TextStyle(
                                                                  color: styles.grey,
                                                                  fontFamily: 'Prompt'
                                                                )
                                                              ),
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return 'Add Findings';
                                                                } else if (value.length <= 2){
                                                                  return 'Must be more than 2 characters';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),

                                                          Padding(
                                                            padding: const EdgeInsets.all(10),
                                                            child: TextFormField(
                                                              controller: prescctrl,
                                                              // obscureText: true,
                                                              decoration: const InputDecoration(
                                                                prefixIcon: Icon(Icons.medication_rounded, color: styles.maincolor),
                                                                border: OutlineInputBorder(),
                                                                enabledBorder: styles.customborder,
                                                                focusedBorder: styles.customborder,
                                                                errorBorder: styles.customborder,
                                                                errorStyle: styles.customerr,
                                                                focusedErrorBorder: styles.customborder,
                                                                labelText: 'Add Prescription',
                                                                labelStyle: TextStyle(
                                                                  color: styles.grey,
                                                                  fontFamily: 'Prompt'
                                                                )
                                                              ),
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return 'Add Prescription';
                                                                } else if (value.length <= 2){
                                                                  return 'Must be more than 2 characters';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),

                                                          Padding(
                                                            padding: const EdgeInsets.all(10),
                                                            child: TextFormField(
                                                              controller: notesctrl,
                                                              // obscureText: true,
                                                              decoration: const InputDecoration(
                                                                prefixIcon: Icon(Icons.notes_rounded, color: styles.maincolor),
                                                                border: OutlineInputBorder(),
                                                                enabledBorder: styles.customborder,
                                                                focusedBorder: styles.customborder,
                                                                errorBorder: styles.customborder,
                                                                errorStyle: styles.customerr,
                                                                focusedErrorBorder: styles.customborder,
                                                                labelText: 'Add Notes',
                                                                labelStyle: TextStyle(
                                                                  color: styles.grey,
                                                                  fontFamily: 'Prompt'
                                                                )
                                                              ),
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return 'Add Notes';
                                                                } else if (value.length <= 2){
                                                                  return 'Must be more than 2 characters';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ),
                                                    

                                                    //----- inputs
                                                    snapshot.data![index].status == 'cancelled' || snapshot.data![index].status == 'completed'
                                                    ? Column()//return empty
                                                    : Padding(
                                                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              height: 50,
                                                              alignment: Alignment.bottomCenter,
                                                              decoration: BoxDecoration(
                                                                color: styles.red,
                                                                borderRadius: BorderRadius.circular(5)
                                                              ),
                                                              child: RoundedLoadingButton(
                                                                elevation: 0,
                                                                color: styles.red,
                                                                onPressed: () {
                                                                  cancelAppointment(context, snapshot.data![index].id.toString());
                                                                }, 
                                                                controller: cancelbutton,
                                                                child: const Text(
                                                                  'Cancel Appointment',
                                                                  style: TextStyle(
                                                                    color: styles.white,
                                                                    fontFamily: 'Prompt',
                                                                    fontSize: 12
                                                                  ),
                                                                )
                                                              ),
                                                            )
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              height: 50,
                                                              alignment: Alignment.bottomCenter,
                                                              decoration: BoxDecoration(
                                                                color: styles.green,
                                                                borderRadius: BorderRadius.circular(5)
                                                              ),
                                                              child: RoundedLoadingButton(
                                                                elevation: 0,
                                                                color: styles.green,
                                                                onPressed: () {
                                                                  if(FPNkey.currentState!.validate()){
                                                                    addFpn(snapshot.data![index].id.toString(), findingsctrl.text, prescctrl.text, notesctrl.text);
                                                                    completeAppointment(context, snapshot.data![index].id.toString());
                                                                  } else {
                                                                    completebutton.reset();
                                                                  }
                                                                }, 
                                                                controller: completebutton,
                                                                child: const Text(
                                                                  'Complete Appointment',
                                                                  style: TextStyle(
                                                                    color: styles.white,
                                                                    fontFamily: 'Prompt',
                                                                    fontSize: 12
                                                                  ),
                                                                )
                                                              ),
                                                            )
                                                          ),
                                                        ],
                                                      )
                                                    ),
                                                  ],
                                                ),
                                              )
                                            );
                                          },
                                        );
                                      },
                                      child: const Icon(Icons.remove_red_eye_outlined),
                                      
                                    ),
                                    leading: Image.asset('assets/images/online.png', scale: 10,),
                                    title: Text(
                                      '${snapshot.data![index].patient}',
                                      style: const TextStyle(
                                        color: styles.basecolor, 
                                        fontFamily: 'Prompt',
                                        fontSize: 14
                                      ),
                                    ),
                                    subtitle: Text(
                                      'At : ${snapshot.data![index].sched}',
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
                                                  snapshot.data![index].status == 'completed' ? Text(
                                                    snapshot.data![index].status,
                                                    style: styles.success,
                                                    maxLines: 4
                                                  ) : Container(),
                                                  snapshot.data![index].status == 'scheduled' ? Text(
                                                    snapshot.data![index].status,
                                                    style: styles.maintext,
                                                    maxLines: 4
                                                  ) : Container(),
                                                  snapshot.data![index].status == 'cancelled' ? Text(
                                                    snapshot.data![index].status,
                                                    style: styles.dangertext,
                                                    maxLines: 4
                                                  ) : Container(),
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
                    // return Text(snapshot.hasError.toString());
                    return 
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No Appointments Yet',
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