import 'package:chatApp/common/widgets.dart';
import 'package:chatApp/helper/Storage.dart';
import 'package:chatApp/services/auth.dart';
import 'package:chatApp/services/database.dart';
import 'package:chatApp/views/bottomNavigationScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatRoomScreen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  
  bool isLoading=false;
  final formKey=GlobalKey<FormState>();
  AuthMethods authMethods=new AuthMethods();
  TextEditingController emailController=new TextEditingController();
  TextEditingController passwordController=new TextEditingController();
  signIn(){
    if(formKey.currentState.validate()){
      setState(() {
        isLoading=true;
      });
      authMethods.signInWithEmailAndPassword(emailController.text, passwordController.text).then((val) async {
        print(val);
        if(val!=null){
          QuerySnapshot userInfoSnapshot =await DatabaseMethods().getUserInfo(emailController.text);
            await StorageHelperFunctions.saveUserLoggedIn(true);
            await StorageHelperFunctions.saveUserName(userInfoSnapshot.documents[0].data["name"]);
            await StorageHelperFunctions.saveUserEmail(userInfoSnapshot.documents[0].data["email"]);
            //print("id recieved is "+userInfoSnapshot.documents[0].documentID);
            await StorageHelperFunctions.saveUserID(userInfoSnapshot.documents[0].documentID);
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context)=>BottomNavigationScreen()
          ));
        }else{
          print("cant sign u in");
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context)=>SignIn(widget.toggle)
          ));
        }
      }); 
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context,"signin"),
      body:isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : 
      Container(
        alignment: Alignment.bottomCenter,
              child: Container(
          padding:EdgeInsets.symmetric(horizontal:30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (val){
                      if(val.isEmpty){
                        return "email cant be empty";
                        // add regex expression!!
                      }else{
                        return null;
                      }
                    },
                    controller: emailController,
                    style:simpleTextFieldStyle(),
                    decoration:textFieldInputDecoration("Email")
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (val){
                      if(val.isEmpty){
                        return "password cant be empty";
                        // add regex expression!!
                      }else{
                        return null;
                      }
                    },
                    controller: passwordController,
                    style:simpleTextFieldStyle(),
                    decoration:textFieldInputDecoration("Password")
                  ),
                  SizedBox(
                    height:8
                  ),
                  Container(
                    padding:EdgeInsets.symmetric(horizontal:16,vertical:16),
                    alignment: Alignment.centerRight,
                    child:Text("Forgot password?",style:simpleTextFieldStyle())
                  ),
                  SizedBox(
                    height:8
                  ),
                  GestureDetector(
                    onTap: (){
                        signIn();
                      },
                    child: Container(
                      alignment: Alignment.center,
                      padding:EdgeInsets.symmetric(vertical:16),
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(30),
                        gradient: LinearGradient(colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                          ])
                      ),
                      
                      child:Text("Sign In",style:simpleTextFieldStyle())
                    ),
                  ),
                  SizedBox(
                    height:8
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    Text("dont have an acc? ",style:simpleTextFieldStyle()),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical:8),
                        child: Text("Register now",style:simpleTextFieldStyle())),
                    )
                  ],
                  ),
                  SizedBox(
                    height:250
                  ),
                ],
              ),
            )
          ],),
        ),
      )
    );
  }
}