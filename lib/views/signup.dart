
import 'package:chatApp/common/widgets.dart';
import 'package:chatApp/helper/Storage.dart';
import 'package:chatApp/services/auth.dart';
import 'package:chatApp/services/database.dart';
import 'package:chatApp/views/bottomNavigationScreen.dart';
import 'package:flutter/material.dart';

import 'chatRoomScreen.dart';

class SignUp extends StatefulWidget {
   final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading=false;
  final formKey=GlobalKey<FormState>();
  DatabaseMethods databaseMethods=new DatabaseMethods();
  AuthMethods authMethods=new AuthMethods();
  TextEditingController nameController=new TextEditingController();
  TextEditingController emailController=new TextEditingController();
  TextEditingController passwordController=new TextEditingController();

  signUp(){
    if(formKey.currentState.validate()){
      setState(() {
        isLoading=true;
      });
      authMethods.signUp(emailController.text, passwordController.text).then((val){
        print(val);
        if(val!=null){
          Map<String,String> userMap={
            "name":nameController.text,
            "email":emailController.text
          };
          StorageHelperFunctions.saveUserLoggedIn(true);
          StorageHelperFunctions.saveUserEmail(emailController.text);
          StorageHelperFunctions.saveUserName(nameController.text);

          databaseMethods.uploadUserInfo(userMap).then((userData) async {
            print("printing user id "+userData.documentID);
            await StorageHelperFunctions.saveUserID(userData.documentID);
            Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context)=>BottomNavigationScreen()
          ));
          });
          
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context)=>SignUp(widget.toggle)
          ));
        }
      }); 
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context,"signup"),
      body:isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) :
       SingleChildScrollView(
        child: Container(
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
                          return "Username cant be empty";
                        }else{
                          return null;
                        }
                      },
                      controller: nameController,
                      style:simpleTextFieldStyle(),
                      decoration:textFieldInputDecoration("Name")
                    ),
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
                  ],
                ),
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
                  signUp();
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
                  
                  child:Text("Sign Up",style:simpleTextFieldStyle())
                ),
              ),
              SizedBox(
                height:8
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Text("have an acc? ",style:simpleTextFieldStyle()),
                GestureDetector(
                  onTap: () {
                    widget.toggle();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical:8),
                    child: Text("Sign In",style:simpleTextFieldStyle())),
                )
              ],
              ),
              SizedBox(
                height:250
              )
            ],),
          ),
      ),
       )
    );
  }
}