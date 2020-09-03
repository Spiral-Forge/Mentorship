import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/screenConstants.dart';
import 'package:dbapp/screens/authenticate/signin.dart';
import 'package:dbapp/screens/home/home.dart';
import 'package:dbapp/screens/wrapper.dart';
import 'package:dbapp/services/auth.dart';
import 'package:dbapp/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/services.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

List domains;
List languages;
String linkedinURL = '';
String githubURL = '';

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class RegisterForm4 extends StatefulWidget {
  //taken from parent props:
  Map<String, dynamic> userMap;
  Function toggleView;
  RegisterForm4(this.userMap, {this.toggleView});

  @override
  _RegisterForm4State createState() => _RegisterForm4State(userMap);
}

class _RegisterForm4State extends State<RegisterForm4> {
  final Map<String, dynamic> userMap;
  _RegisterForm4State(this.userMap);

  final AuthService _auth = AuthService();
  final _formKey4 = GlobalKey<FormState>();

  //form fields

  String error = '';
  bool loading = false;

  void saveData() async {
    dynamic result = await _auth.register(
        userMap['name'],
        userMap['phoneNo'],
        userMap['email'],
        userMap['password'],
        userMap['year'],
        userMap['branch'],
        userMap['rollNo'],
        userMap['linkedInURL'],
        userMap['githubURL'],
        userMap['domains'],
        userMap['languages'],
        userMap['hosteller'],
        userMap['post']);
    if (result == null) {
      setState(() {
        error = 'some error message';
        loading = false;
      });
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Wrapper(),
        ),
        (route) => false,
      );
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Wrapper()));
    }
  }

  void initState() {
    super.initState();
    domains = [];
    languages = [];
    linkedinURL = '';
    githubURL = '';
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.COLOR_TEAL_DARK,
        elevation: 0.0,
        title: Text("Register"),
      ),
      body: loading
          ? Loading()
          : Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                margin: EdgeInsets.all(8),
                child: new Container(
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: _formKey4,
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        new Divider(height: 35.0, color: Colors.transparent),
                        new Text(
                          'Additional info',
                          style: TextStyle(
                            fontFamily: 'GoogleSans',
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        new Divider(height: 35.0, color: Colors.transparent),
                        new Text(
                          userMap['post'] == 'Mentor'
                              ? "Tell us about your domain knowledge"
                              : "What skills do you want to be mentored with?",
                          style: TextStyle(
                            fontFamily: 'GoogleSans',
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // new Divider(height: 12, color: Colors.transparent),
                        Container(
                          padding: EdgeInsets.all(6),
                          child: MultiSelectFormField(
                            autovalidate: false,
                            titleText: 'Domains',
                            validator: (value) {
                              if (value == null || value.length == 0) {
                                return 'Please select one or more options';
                              }
                            },
                            dataSource: ScreenConstants.registerFieldData,
                            textField: 'display',
                            valueField: 'value',
                            okButtonLabel: 'OK',
                            cancelButtonLabel: 'CANCEL',
                            hintText: 'Choose one or more',
                            initialValue: domains,
                            onSaved: (value) {
                              if (value == null) return;
                              setState(() {
                                domains = value;
                              });
                            },
                          ),
                        ),
                        new Divider(height: 0, color: Colors.transparent),
                        Container(
                          padding: EdgeInsets.all(6),
                          child: MultiSelectFormField(
                            autovalidate: false,
                            titleText: 'Languages',
                            validator: (value) {
                              if (value == null || value.length == 0) {
                                return 'Please select one or more options';
                              }
                            },
                            dataSource: ScreenConstants.registerLanguageData,
                            textField: 'display',
                            valueField: 'value',
                            okButtonLabel: 'OK',
                            cancelButtonLabel: 'CANCEL',
                            hintText: 'Choose one or more',
                            initialValue: languages,
                            onSaved: (value) {
                              if (value == null) return;
                              setState(() {
                                languages = value;
                              });
                            },
                          ),
                        ),
                        new Divider(height: 10, color: Colors.transparent),
                        Text(
                          'Your Linkedin Profile URL',
                          style: TextStyle(
                            fontFamily: 'GoogleSans',
                            fontSize: 13,
                          ),
                        ),
                        TextFormField(
                            style: TextStyle(color: Colors.grey),
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              border: UnderlineInputBorder(),
                            ),
                            // validator: (val) {
                            //   if (val.length == 0) {
                            //     return 'Required';
                            //   }
                            //   return '';
                            // },
                            onChanged: (val) {
                              setState(() => linkedinURL = val);
                            }),
                        new Divider(height: 10, color: Colors.transparent),
                        Text(
                          'Your GitHub Profile URL',
                          style: TextStyle(
                            fontFamily: 'GoogleSans',
                            fontSize: 13,
                          ),
                        ),
                        TextFormField(
                            style: TextStyle(color: Colors.grey),
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              border: UnderlineInputBorder(),
                            ),
                            // validator: (val) {
                            //   if (val.length == 0) {
                            //     return 'Required';
                            //   }
                            //   return '';
                            // },
                            onChanged: (val) {
                              setState(() => githubURL = val);
                            }),
                        new Divider(height: 35.0, color: Colors.transparent),
                        new Container(
                          padding: EdgeInsets.fromLTRB(120, 5, 120, 5),
                          child: RaisedButton(
                              color: AppColors.COLOR_TEAL_LIGHT,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                    color: AppColors.COLOR_TEAL_LIGHT,
                                  )),
                              child: Text("Next",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'GoogleSans'),
                                  textAlign: TextAlign.center),
                              onPressed: () {
                                if (_formKey4.currentState.validate()) {
                                  setState(() {
                                    userMap['domains'] = domains;
                                    userMap['languages'] = languages;

                                    userMap['linkedInURL'] = linkedinURL;
                                    userMap['githubURL'] = githubURL;
                                    print(userMap);
                                    saveData();
                                  });
                                  // If the form is valid, display a Snackbar.
                                  // Scaffold.of(context).showSnackBar(
                                  //     SnackBar(content: Text('Data is in processing.')));
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
