import 'package:flutter/material.dart';
import 'package:chat_app/components/rounded_button.dart';
import 'package:chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';



class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  String email = "aa";
  String password = "aa";
  final _auth = FirebaseAuth.instance;
  bool isSpinning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isSpinning,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kInputFieldDecoration.copyWith(hintText: 'Enter your email')
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                 password = value;
                },
                decoration: kInputFieldDecoration.copyWith(hintText: 'Enter your password')
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: "Register", colour: Colors.blueAccent, onPressed: ()
              async{
                setState(() {
                  isSpinning = true;
                });
             try {
               final newUser = await _auth.createUserWithEmailAndPassword(
                   email: email, password: password);
               if (newUser != null) {
                 Navigator.pushNamed(context, 'chat_screen');
               }
               setState(() {
                 isSpinning = false;
               });
             }
             catch(e){
                  print("Exception has occured$e");
                }

              } ),
            ],
          ),
        ),
      ),
    );
  }
}
