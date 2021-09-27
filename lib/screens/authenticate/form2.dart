import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/services.dart';
import 'package:dbapp/screens/authenticate/form3.dart';
import 'package:provider/provider.dart';

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
  final _formKey2 = GlobalKey<FormState>();

  String error = '';
  bool loading = false;

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
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    bool themeFlag = _themeNotifier.darkTheme;

    return new Scaffold(
      backgroundColor: themeFlag ? AppColors.COLOR_DARK : Colors.white,
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
                                    icon: Icon(
                                      Icons.arrow_back,
                                      size: 32,
                                      color: themeFlag
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                SizedBox(height: 25),
                                Expanded(
                                    child: SizedBox(
                                        child: Padding(
                                  padding: EdgeInsets.fromLTRB(51, 0, 51, 0),
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
                                            color: themeFlag
                                                ? Colors.white
                                                : Colors.black,
                                            fontFamily: 'Quicksand',
                                            fontSize: 23,
                                            fontWeight: FontWeight.w700,
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
                                            decoration: InputDecoration(
                                              labelStyle: TextStyle(
                                                  color: themeFlag
                                                      ? Colors.white
                                                      : Color(0xff777777),
                                                  fontFamily: 'Quicksand',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: themeFlag
                                                        ? Colors.white
                                                        : Color(0xff777777)),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: themeFlag
                                                        ? Colors.white
                                                        : Color(0xff80B9E8)),
                                              ),
                                              border: UnderlineInputBorder(),
                                              icon: Icon(
                                                Icons.person,
                                                size: 24,
                                                color: themeFlag
                                                    ? Colors.white
                                                    : Color(0xff777777),
                                              ),
                                              labelText: 'Full Name',
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
                                            decoration: InputDecoration(
                                                labelStyle: TextStyle(
                                                    color: themeFlag
                                                        ? Colors.white
                                                        : Color(0xff777777),
                                                    fontFamily: 'Quicksand',
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: themeFlag
                                                          ? Colors.white
                                                          : Color(0xff777777)),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: themeFlag
                                                          ? Colors.white
                                                          : Color(0xff80B9E8)),
                                                ),
                                                border: UnderlineInputBorder(),
                                                icon: Icon(
                                                  Icons.phone,
                                                  size: 24,
                                                  color: themeFlag
                                                      ? Colors.white
                                                      : Color(0xff777777),
                                                ),
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
                                            decoration: InputDecoration(
                                              labelStyle: TextStyle(
                                                  color: themeFlag
                                                      ? Colors.white
                                                      : Color(0xff777777),
                                                  fontFamily: 'Quicksand',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: themeFlag
                                                        ? Colors.white
                                                        : Color(0xff777777)),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: themeFlag
                                                        ? Colors.white
                                                        : Color(0xff80B9E8)),
                                              ),
                                              border: UnderlineInputBorder(),
                                              icon: Icon(
                                                Icons.email,
                                                size: 24,
                                                color: themeFlag
                                                    ? Colors.white
                                                    : Color(0xff777777),
                                              ),
                                              labelText: 'Email id',
                                            ),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Required';
                                              }
                                              return null;
                                            },
                                            onChanged: (val) {
                                              setState(() => email =
                                                  val.replaceAll(" ", ""));
                                            }),
                                        TextFormField(
                                            style:
                                                TextStyle(color: Colors.grey),
                                            decoration: InputDecoration(
                                              labelStyle: TextStyle(
                                                  color: themeFlag
                                                      ? Colors.white
                                                      : Color(0xff777777),
                                                  fontFamily: 'Quicksand',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: themeFlag
                                                        ? Colors.white
                                                        : Color(0xff777777)),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: themeFlag
                                                        ? Colors.white
                                                        : Color(0xff80B9E8)),
                                              ),
                                              border: UnderlineInputBorder(),
                                              icon: Icon(
                                                Icons.security,
                                                size: 24,
                                                color: themeFlag
                                                    ? Colors.white
                                                    : Color(0xff777777),
                                              ),
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
                                            height: 80.0,
                                            color: Colors.transparent),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                height: 34,
                                                width: 140,
                                                child: new MaterialButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    color: AppColors
                                                        .COLOR_TURQUOISE,
                                                    onPressed: () async {
                                                      if (_formKey2.currentState
                                                          .validate()) {
                                                        setState(() {
                                                          userMap['name'] =
                                                              name;
                                                          userMap['phoneNo'] =
                                                              phoneNo;
                                                          userMap['email'] =
                                                              email;
                                                          userMap['password'] =
                                                              password;
                                                        });
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    RegisterForm3(
                                                                        userMap,
                                                                        themeFlag)));
                                                      }
                                                    },
                                                    child: Text('Next',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Quicksand',
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700))),
                                              ),
                                            ]),
                                        new Divider(
                                            height: 18.0,
                                            color: Colors.transparent),
                                      ])),
                                )))
                              ]))))
            ]),
    );
  }
}
