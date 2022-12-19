import 'dart:convert';

import 'package:frontend/views/tabs/home.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../controllers/booking-api-handler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import './homepage.dart';

// import 'package:localstorage/localstorage.dart';
import '../storage/storage.dart';




void main(){
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainForm(),
    )
  );
}

class AuthRes{
  final String JwtToken;

  const AuthRes({
    required this.JwtToken,
  });

  Map<String, dynamic> toJson() => {
    "JwtToken" : JwtToken,
  };

  factory AuthRes.fromJson(Map<String, dynamic> json){
    return AuthRes(JwtToken: json['JwtToken']);
  }
}

class MainForm extends StatefulWidget {
  const MainForm({super.key});
  

  @override
  State<StatefulWidget> createState() => MainFormState();
}
// final apihandler = Get.lazyPut(() => ApiHandler(), fenix: true);

class MainFormState extends State<MainForm>{
  final apihandler = Get.put(ApiHandler());
  bool isLoading = false;
  static const maincolor = Color.fromRGBO(109, 85, 246, 1);
  static const basecolor = Color.fromRGBO(26, 26, 56, 1);
  static const grey = Color.fromRGBO(113, 114, 133, 1);
  static const white = Color.fromRGBO(255, 255, 255, 1);
  static const customerr = TextStyle(fontFamily: 'Prompt', fontWeight: FontWeight.w100);
  static const customborder =  OutlineInputBorder(
    borderSide: BorderSide(
      width: 1,
      color: grey
    )
  );

  // autoLogin(){
  //   apihandler.autologin();
  //   if(apifind.isloggedin){
  //     Navigator.push(
  //       context, 
  //       MaterialPageRoute(
  //         builder: (
  //           BuildContext context
  //         ) => const Homepage()
  //       )
  //     );
  //   }
  // }

  Future<AuthRes> postTest(String email, String password)async{
    apihandler.emailSave(email);
    setState(() {
      isLoading = true;
    });
    var map = <String, dynamic>{};
    map['email'] = email;
    map['password'] = password;
    // map['email'] = 'rirei1415@mailinator.com';
    // map['password'] = '12345678';

    final response = await http.post(
      Uri.parse('${apihandler.url}/auth/login'),
      body: map
    );

    if(response.statusCode != 200){
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: 'Wrong Credentials',
        // backgroundColor: const Color.fromARGB(255, 109, 140, 201),
        textColor: Colors.white,
      );
      print('error');
      print(map);

      throw Exception('Failed');
    } else {
      Map<String, dynamic> map = json.decode(response.body);
      var tokin = map["access_token"];
      apihandler.getToken(tokin);
      apihandler.loginUser();

      await Future.delayed(const Duration(seconds: 2)).then((_){
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (
              BuildContext context
            ) => const Homepage()
          )
        );
      });
      return AuthRes.fromJson(tokin);
    }
  }
  
  String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }

  // test(){
  //   MyStorage.getPref();
  //   // print(store);
  // }

  @override
  Widget build(BuildContext context) {
    ApiHandler apifind = Get.find<ApiHandler>();
    final formKey = GlobalKey<FormState>();
    final _email = TextEditingController(text: apifind.emailsave);
    final _password = TextEditingController();
    
    // autoLogin();
    return Scaffold(
      backgroundColor: white,
      // appBar: AppBar(
      //   title: const Text('Login'),
      // ),
      body: LoadingOverlay(
        isLoading: isLoading,
        color: white,
        opacity: 0.5,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 40),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset('assets/images/medical-team.png',
                  width: 180.0, 
                  height: 180.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _email,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail, color: maincolor),
                      enabledBorder: customborder,
                      focusedBorder: customborder,
                      errorBorder: customborder,
                      errorStyle: customerr,
                      focusedErrorBorder: customborder,
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: grey,
                        fontFamily: 'Prompt'
                      )
                    ),
                    validator: (value) => validateEmail(value)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_rounded, color: maincolor),
                      border: OutlineInputBorder(),
                      enabledBorder: customborder,
                      focusedBorder: customborder,
                      errorBorder: customborder,
                      errorStyle: customerr,
                      focusedErrorBorder: customborder,
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: grey,
                        fontFamily: 'Prompt'
                      )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      } else if (value.length <= 5){
                        return 'Password must be more than 5 characters';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    onPressed: (){
                      // test();
                      // if(apistatuscode == '200'){
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                      // } else {
                      //   print('not ok');
                      // }
                    }, 
                    child: const Text(
                      'Forgot password',
                      style: TextStyle(
                        color: basecolor, 
                        fontSize: 18,
                        fontWeight: FontWeight.w100,
                        fontFamily: 'Prompt'
                      ),
                    )
                  ),
                ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                    color: maincolor, borderRadius: BorderRadius.circular(40),
                  ),
                  child: TextButton(
                    onPressed: (){
                      if(formKey.currentState!.validate()){
                        postTest(_email.text, _password.text);
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: white,
                        fontSize: 25,
                        fontFamily: 'Prompt'
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 130,
                ),
                const Text('New User? Create Account')
              ],
            ),
          ),
        )
      )
    );
  }
}