import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Login'),
      // ),
      body: Container(
        // height: 150.0,
        // width: 190.0,
        padding: const EdgeInsets.only(top: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
        ),
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                  hintText: 'Enter user name'
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your password'
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const MainApp()));
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
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
    );
  }
}