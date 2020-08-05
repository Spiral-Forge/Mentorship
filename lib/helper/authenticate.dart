import 'package:chatApp/views/signin.dart';
import 'package:chatApp/views/signup.dart';
import 'package:flutter/material.dart';
class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn=true;

  void switchScreen(){
    setState(() {
      showSignIn=!showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    return showSignIn ? SignIn(switchScreen) : SignUp(switchScreen); 
  }
}