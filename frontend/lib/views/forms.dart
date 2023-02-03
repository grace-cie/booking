import 'dart:convert';

import 'package:frontend/helpers/styles.dart';
import 'package:frontend/views/doc_homepage.dart';
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
  bool isRegister = false;
  bool isDoctor = false;
  String userClassVal = '';
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
      var userclass = map["userclass"];
      apihandler.getToken(tokin);
      apihandler.loginUser();

      if(userclass == 'patient'){
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
      } else {
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
              ) => const DocHomepage()
            )
          );
        });
      }

      
      return AuthRes.fromJson(tokin);
    }
  }

  registerUser(
    String email, String password,
    String username, String firstname,
    String middlename, String lastname,
    String suffix, String hci,
    String hciaddr, String bio,
    String addrr, String phone,
    String userclass, String conpassword,
  )async{
    setState(() {
      isLoading = true;
    });
    var map = <String, dynamic>{};
    map['username'] = username;
    map['firstname'] = firstname;
    map['middlename'] = middlename;
    map['lastname'] = lastname;
    map['address'] = addrr;
    map['suffix'] = suffix;
    map['userclass'] = userclass;
    map['bio'] = bio;
    map['email'] = email;
    map['phone'] = phone;
    map['health_care_provider'] = hci;
    map['health_care_provider_address'] = hciaddr;
    map['password'] = password;
    map['password_confirmation'] = conpassword;

    final response = await http.post(
      Uri.parse('${apihandler.url}/auth/register-user'),
      body: map
    );

    Map<String, dynamic> mapp = await json.decode(response.body);
    var message = mapp['message'];
    if(response.statusCode == 200){
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: message,
        textColor: Colors.white,
      );
      setState(() {
        isRegister = !isRegister;
      });
    }else{
      Fluttertoast.showToast(
        msg: message,
        textColor: Colors.white,
      );
      throw Exception('Failed');
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
    //------- register -------//
    final _username = TextEditingController();
    final _firstname = TextEditingController();
    final _middlename = TextEditingController();
    final _lastname = TextEditingController();
    final _suffix = TextEditingController();
    //------- register doctor -------//
    final _hci = TextEditingController();
    final _hciaddr = TextEditingController();
    final _bio = TextEditingController();
    final _addrr = TextEditingController();
    final _phone = TextEditingController();
    final _conpassword = TextEditingController();
    
    // autoLogin();
    return Scaffold(
      backgroundColor: white,
      // appBar: AppBar(
      //   title: const Text('Login'),
      // ),
      body: LoadingOverlay(
        isLoading: isLoading,
        color: styles.maincolor,
        opacity: 0.5,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 40),
            child: Column(
              children: [
                !isRegister
                ? Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,60),
                  child: Image.asset('assets/images/medical-team.png',
                  width: 180.0, 
                  height: 180.0),
                ) : Column(),

                isRegister
                ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Are you a Doctor?',
                        style: TextStyle(
                          color: grey,
                          fontFamily: 'Prompt'
                        ),
                      ),
                      Checkbox(
                        value: isDoctor,
                        checkColor: styles.white,
                        activeColor: styles.maincolor,
                        onChanged: (bool? value){
                          setState(() {
                            isDoctor = !isDoctor;
                          });
                        }
                      )
                    ],
                  ),
                ) : Column(),
                //--------->  Patient
                isRegister
                ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _username,
                    // obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person, color: maincolor),
                      border: OutlineInputBorder(),
                      enabledBorder: customborder,
                      focusedBorder: customborder,
                      errorBorder: customborder,
                      errorStyle: customerr,
                      focusedErrorBorder: customborder,
                      labelText: 'User Name',
                      labelStyle: TextStyle(
                        color: grey,
                        fontFamily: 'Prompt'
                      )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please User Name';
                      } else if (value.length <= 2){
                        return 'User Name must be more than 2 characters';
                      }
                      return null;
                    },
                  ),
                ) : Column(),

                isRegister
                ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstname,
                          // obscureText: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_pin, color: maincolor),
                            border: OutlineInputBorder(),
                            enabledBorder: customborder,
                            focusedBorder: customborder,
                            errorBorder: customborder,
                            errorStyle: customerr,
                            focusedErrorBorder: customborder,
                            labelText: 'First Name',
                            labelStyle: TextStyle(
                              color: grey,
                              fontFamily: 'Prompt'
                            )
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter your First Name';
                            } else if (value.length <= 2){
                              return 'First Name must be more than 2 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _middlename,
                          // obscureText: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_pin, color: maincolor),
                            border: OutlineInputBorder(),
                            enabledBorder: customborder,
                            focusedBorder: customborder,
                            errorBorder: customborder,
                            errorStyle: customerr,
                            focusedErrorBorder: customborder,
                            labelText: 'Middle Name',
                            labelStyle: TextStyle(
                              color: grey,
                              fontFamily: 'Prompt'
                            )
                          ),
                        ),
                      ) 
                    ],
                  ),
                ) : Column(),

                isRegister
                ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _lastname,
                          // obscureText: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_pin, color: maincolor),
                            border: OutlineInputBorder(),
                            enabledBorder: customborder,
                            focusedBorder: customborder,
                            errorBorder: customborder,
                            errorStyle: customerr,
                            focusedErrorBorder: customborder,
                            labelText: 'Last Name',
                            labelStyle: TextStyle(
                              color: grey,
                              fontFamily: 'Prompt'
                            )
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter your Last Name';
                            } else if (value.length <= 2){
                              return 'Last Name must be more than 2 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _suffix,
                          // obscureText: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_pin, color: maincolor),
                            border: OutlineInputBorder(),
                            enabledBorder: customborder,
                            focusedBorder: customborder,
                            errorBorder: customborder,
                            errorStyle: customerr,
                            focusedErrorBorder: customborder,
                            labelText: 'Suffix',
                            labelStyle: TextStyle(
                              color: grey,
                              fontFamily: 'Prompt'
                            )
                          ),
                        ),
                      ) 
                    ],
                  ),
                ) : Column(),
                //----------> Patient

                //----------> Doctor
                isRegister && isDoctor
                ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _hci,
                    // obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.health_and_safety_sharp, color: maincolor),
                      border: OutlineInputBorder(),
                      enabledBorder: customborder,
                      focusedBorder: customborder,
                      errorBorder: customborder,
                      errorStyle: customerr,
                      focusedErrorBorder: customborder,
                      labelText: 'Health Care Provider',
                      labelStyle: TextStyle(
                        color: grey,
                        fontFamily: 'Prompt'
                      )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your Health Care Provider';
                      } else if (value.length <= 5){
                        return 'Health Care Provider must be more than 5 characters';
                      }
                      return null;
                    },
                  ),
                ) : Column(),

                isRegister && isDoctor
                ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _hciaddr,
                    // obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_city_sharp, color: maincolor),
                      border: OutlineInputBorder(),
                      enabledBorder: customborder,
                      focusedBorder: customborder,
                      errorBorder: customborder,
                      errorStyle: customerr,
                      focusedErrorBorder: customborder,
                      labelText: 'Health Care Provider Address',
                      labelStyle: TextStyle(
                        color: grey,
                        fontFamily: 'Prompt'
                      )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your Health Care Provider Address';
                      } else if (value.length <= 5){
                        return 'Health Care Provider Address must be more than 5 characters';
                      }
                      return null;
                    },
                  ),
                ) : Column(),

                isRegister && isDoctor
                ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    maxLines: 10,
                    controller: _bio,
                    // obscureText: true,
                    decoration: const InputDecoration(
                      // prefixIcon: Icon(
                      //   Icons.lock_rounded, 
                      //   color: maincolor,
                      //   padd
                      // ),
                      border: OutlineInputBorder(),
                      enabledBorder: customborder,
                      focusedBorder: customborder,
                      errorBorder: customborder,
                      errorStyle: customerr,
                      focusedErrorBorder: customborder,
                      labelText: 'Tell us About your Career',
                      alignLabelWithHint: true,
                      labelStyle: TextStyle(
                        color: grey,
                        fontFamily: 'Prompt'
                      )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tell us About your Career';
                      } else if (value.length <= 5){
                        return 'Password must be more than 5 characters';
                      }
                      return null;
                    },
                  ),
                ) : Column(),

                isRegister
                ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _addrr,
                    // obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.location_on, color: maincolor),
                      border: OutlineInputBorder(),
                      enabledBorder: customborder,
                      focusedBorder: customborder,
                      errorBorder: customborder,
                      errorStyle: customerr,
                      focusedErrorBorder: customborder,
                      labelText: 'Address',
                      labelStyle: TextStyle(
                        color: grey,
                        fontFamily: 'Prompt'
                      )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your Address';
                      } else if (value.length <= 5){
                        return 'Address must be more than 5 characters';
                      }
                      return null;
                    },
                  ),
                ) : Column(),
                //----------> Doctor



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
                isRegister
                ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    controller: _phone,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone_android_outlined, color: maincolor),
                      enabledBorder: customborder,
                      focusedBorder: customborder,
                      errorBorder: customborder,
                      errorStyle: customerr,
                      focusedErrorBorder: customborder,
                      labelText: 'Phone',
                      labelStyle: TextStyle(
                        color: grey,
                        fontFamily: 'Prompt'
                      )
                    ),
                      validator: (value) {
                        final phoneRegex = r'^09\d{9}$';
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        } else if (!RegExp(phoneRegex).hasMatch(value)) {
                          return 'A valid phone number format is "09XXXXXXXXX"';
                        }
                        return null;
                      },
                  ),
                ) : Column(),
                
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

                isRegister
                ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _conpassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_rounded, color: maincolor),
                      border: OutlineInputBorder(),
                      enabledBorder: customborder,
                      focusedBorder: customborder,
                      errorBorder: customborder,
                      errorStyle: customerr,
                      focusedErrorBorder: customborder,
                      labelText: 'Confirm Password',
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
                      } else if (value != _password.text){
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ) : Column(),
                !isRegister 
                ? Padding(
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
                ) : Column(),
                !isRegister
                ? Container(
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
                )
                : Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                    color: maincolor, borderRadius: BorderRadius.circular(40),
                  ),
                  child: TextButton(
                    onPressed: (){
                      if(formKey.currentState!.validate()){
                        if(isDoctor){
                          setState(() {
                            userClassVal = 'doctor';
                          });
                        } else {
                          setState(() {
                            userClassVal = 'patient';
                          });
                        }
                        registerUser(
                          _email.text, _password.text, 
                          _username.text, _firstname.text, 
                          _middlename.text, _lastname.text, 
                          _suffix.text, _hci.text,
                          _hciaddr.text, _bio.text, 
                          _addrr.text, _phone.text, 
                          userClassVal, _conpassword.text);
                      }
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: white,
                        fontSize: 25,
                        fontFamily: 'Prompt'
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                !isRegister
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('New User? '),
                    // isRegister ? const Text('this is register') :  const Text('this is login'),
                    
                    InkWell(
                      onTap: () {
                        setState(() {
                          isRegister = !isRegister;
                        });
                      },
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: styles.basecolor,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ), 
                  ],
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already Have an Account? '),
                    // isRegister ? const Text('this is register') :  const Text('this is login'),
                    
                    InkWell(
                      onTap: () {
                        setState(() {
                          isRegister = !isRegister;
                        });
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: styles.basecolor,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ), 
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),           
              ],
            ),
          ),
        )
      )
    );
  }
}