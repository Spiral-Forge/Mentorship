import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/screenConstants.dart';
import 'package:dbapp/screens/authenticate/signin.dart';
import 'package:dbapp/screens/home/home.dart';
import 'package:dbapp/services/auth.dart';
import 'package:dbapp/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/services.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:dbapp/screens/authenticate/form3.dart';

String name = '';
String phoneNo = '';
String email = '';
String password = '';

class RegisterForm2 extends StatefulWidget {
  //taken from parent props:
  Map<String, dynamic> userMap;
  Function toggleView;
  RegisterForm2(this.userMap, {this.toggleView});

  @override
  _RegisterForm2State createState() => _RegisterForm2State(userMap);
}

class _RegisterForm2State extends State<RegisterForm2> {
  final Map<String, dynamic> userMap;
  _RegisterForm2State(this.userMap);

  final AuthService _auth = AuthService();
  final _formKey2 = GlobalKey<FormState>();

  //form fields

  String error = '';
  bool loading = false;

  // void saveData() async {
  //   dynamic result = await _auth.register(
  //       name,
  //       phoneNo,
  //       email,
  //       password,
  //       year,
  //       branch,
  //       rollNo,
  //       linkedInURL,
  //       githubURL,
  //       domains,
  //       languages,
  //       hosteller,
  //       post);
  //   if (result == null) {
  //     setState(() {
  //       error = 'some error message';
  //       loading = false;
  //     });
  //   }
  // }

  void initState() {
    super.initState();
    setState(() {
      name = '';
      phoneNo = '';
      email = '';
      password = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppColors.COLOR_TEAL_LIGHT,
      //   elevation: 0.0,
      //   title: Text("Register"),
      // ),
      body: loading
          ? Loading()
          : Column(children: [
              Expanded(
                  child: Container(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 32),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(32, 32, 0, 0),
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                SizedBox(height: 25),
                                // Card(
                                //   child:
                                Expanded(
                                    child: SizedBox(
                                        // height: 120.0,
                                        child: Padding(
                                  padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                                  child: Form(
                                      key: _formKey2,
                                      child:
                                          ListView(shrinkWrap: true, children: <
                                              Widget>[
                                        new Divider(
                                            height: 35.0,
                                            color: Colors.transparent),
                                        new Text(
                                          'Create your account',
                                          style: TextStyle(
                                            fontFamily: 'GoogleSans',
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        new Divider(
                                            height: 35.0,
                                            color: Colors.transparent),
                                        new TextFormField(
                                            keyboardType: TextInputType.text,
                                            style:
                                                TextStyle(color: Colors.grey),
                                            decoration: const InputDecoration(
                                              labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'GoogleSans'),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue),
                                              ),
                                              border: UnderlineInputBorder(),
                                              icon: const Icon(Icons.person),
                                              hintText: 'Enter your full name',
                                              hintStyle:
                                                  TextStyle(fontSize: 12),
                                              labelText: 'Name',
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Required';
                                              }
                                              return null;
                                            },
                                            onChanged: (val) {
                                              setState(() => name = val);
                                            }),
                                        TextFormField(
                                            keyboardType: TextInputType.phone,
                                            style:
                                                TextStyle(color: Colors.grey),
                                            decoration: const InputDecoration(
                                                labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'GoogleSans',
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blue),
                                                ),
                                                border: UnderlineInputBorder(),
                                                icon: const Icon(Icons.phone),
                                                hintText:
                                                    'Enter a phone number',
                                                hintStyle:
                                                    TextStyle(fontSize: 12),
                                                labelText: 'Phone'),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Required';
                                              } else if (value.length != 10) {
                                                return 'Incorrect';
                                              }
                                              return null;
                                            },
                                            onChanged: (val) {
                                              setState(() => phoneNo = val);
                                            }),
                                        TextFormField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style:
                                                TextStyle(color: Colors.grey),
                                            decoration: const InputDecoration(
                                              labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'GoogleSans'),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue),
                                              ),
                                              border: UnderlineInputBorder(),
                                              icon: const Icon(Icons.email),
                                              hintText: 'Enter your email id',
                                              hintStyle:
                                                  TextStyle(fontSize: 12),
                                              labelText: 'Email id',
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Required';
                                              }
                                              return null;
                                            },
                                            onChanged: (val) {
                                              setState(() => email = val);
                                            }),
                                        TextFormField(
                                            style:
                                                TextStyle(color: Colors.grey),
                                            decoration: const InputDecoration(
                                              labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'GoogleSans'),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue),
                                              ),
                                              border: UnderlineInputBorder(),
                                              icon: const Icon(Icons.security),
                                              hintText: 'Enter your password',
                                              hintStyle:
                                                  TextStyle(fontSize: 12),
                                              labelText: 'Password',
                                            ),
                                            validator: (value) {
                                              if (value.length < 6) {
                                                return 'Enter a password 6+ chars long';
                                              }
                                              return null;
                                            },
                                            obscureText: true,
                                            onChanged: (val) {
                                              setState(() => password = val);
                                            }),
                                        new Divider(
                                            height: 35.0,
                                            color: Colors.transparent),
                                        new Container(
                                          padding: EdgeInsets.fromLTRB(
                                              120, 5, 120, 5),
                                          child: RaisedButton(
                                              color: AppColors.COLOR_TEAL_LIGHT,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                    color: AppColors
                                                        .COLOR_TEAL_LIGHT,
                                                  )),
                                              child: Text("Next",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'GoogleSans'),
                                                  textAlign: TextAlign.center),
                                              onPressed: () async {
                                                if (_formKey2.currentState
                                                    .validate()) {
                                                  setState(() {
                                                    userMap['name'] = name;
                                                    userMap['phoneNo'] =
                                                        phoneNo;
                                                    userMap['email'] = email;
                                                    userMap['password'] =
                                                        password;
                                                  });
                                                  print(userMap);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              RegisterForm3(
                                                                  userMap)));
                                                  // If the form is valid, display a Snackbar.
                                                  // Scaffold.of(context).showSnackBar(
                                                  //     SnackBar(content: Text('Data is in processing.')));
                                                }
                                              }),
                                        ),
                                        new Divider(
                                            height: 18.0,
                                            color: Colors.transparent),
                                      ])),
                                )
                                        // new Container(
                                        ))
                              ]))))
            ]),
      //),
    );
  }
}
