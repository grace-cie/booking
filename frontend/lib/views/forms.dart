import 'package:loading_overlay/loading_overlay.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../controllers/booking-api-handler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import './homepage.dart';

void main(){
  runApp(const MainForm());
}

class MainForm extends StatefulWidget {
  const MainForm({super.key});

  @override
  State<StatefulWidget> createState() => MainFormState();
}

class MainFormState extends State<MainForm>{
  final apihandler = Get.put(ApiHandler());
  bool isLoading = false;

  postTest(String email, String password)async{
    setState(() {
      isLoading = true;
    });
    var map = <String, dynamic>{};
    map['email'] = email;
    map['password'] = password;
    // map['email'] = 'rirei1415@mailinator.com';
    // map['password'] = '123456789';

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
        backgroundColor: const Color.fromARGB(255, 109, 140, 201),
        textColor: Colors.white,
      );
      print('error');
      print(map);
    } else {
      await Future.delayed(const Duration(seconds: 1)).then((_){
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
      });
        
      
    }
    print(map);

    // print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final _email = TextEditingController();
    final _password = TextEditingController();
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Login'),
      // ),
      body: LoadingOverlay(
        isLoading: isLoading,
        color:  const Color.fromARGB(255, 252, 252, 252),
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
                    controller: _email,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter Email'
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Email';
                      } else {

                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter your password'
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    onPressed: (){
                      // if(apistatuscode == '200'){
                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                      // } else {
                      //   print('not ok');
                      // }
                    }, 
                    child: const Text(
                      'Forgot password',
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    )
                  ),
                ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: (){
                      if(formKey.currentState!.validate()){
                        postTest(_email.text, _password.text);
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
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