import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/screenConstants.dart';
import 'package:dbapp/screens/wrapper.dart';
import 'package:dbapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/services.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  //form fields

  String error = '';
  bool loading = false;

  void saveData() async {
    var token = await _firebaseMessaging.getToken();
    setState(() {
      loading = true;
      userMap['token'] = token;
    });
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
        userMap['post'],
        userMap['token']);
    if (result.runtimeType == PlatformException) {
      setState(() {
        error = result.message.toString();
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
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return new Scaffold(
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
                                  Expanded(
                                      child: SizedBox(
                                          child: Padding(
                                    padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                                    child: Form(
                                      key: _formKey4,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: <Widget>[
                                          new Divider(
                                              height: 35.0,
                                              color: Colors.transparent),
                                          new Text(
                                            'Additional info',
                                            style: TextStyle(
                                              fontFamily: 'GoogleSans',
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          new Divider(
                                              height: 10.0,
                                              color: Colors.transparent),
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
                                          new Divider(
                                              height: 35.0,
                                              color: Colors.transparent),
                                          Container(
                                            child: MultiSelectFormField(
                                              fillColor: themeFlag
                                                  ? Colors.grey[700]
                                                  : Colors.transparent,
                                              autovalidate: false,
                                              titleText: 'Domains',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.length == 0) {
                                                  return 'Please select one or more options';
                                                }
                                              },
                                              dataSource: ScreenConstants
                                                  .registerFieldData,
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
                                          new Divider(
                                              height: 10,
                                              color: Colors.transparent),
                                          Container(
                                            child: MultiSelectFormField(
                                              fillColor: themeFlag
                                                  ? Colors.grey[700]
                                                  : Colors.transparent,
                                              autovalidate: false,
                                              titleText: 'Languages',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.length == 0) {
                                                  return 'Please select one or more options';
                                                }
                                              },
                                              dataSource: ScreenConstants
                                                  .registerLanguageData,
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
                                          new Divider(
                                              height: 10,
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
                                                labelText:
                                                    'Your LinkedIN Profile URL',
                                              ),
                                              onChanged: (val) {
                                                setState(
                                                    () => linkedinURL = val);
                                              }),
                                          new Divider(
                                              height: 10,
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
                                                labelText:
                                                    'Your Github Profile URL',
                                              ),
                                              onChanged: (val) {
                                                setState(() => githubURL = val);
                                              }),
                                          new Divider(
                                              height: 35.0,
                                              color: Colors.transparent),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  height: 40,
                                                  child: new MaterialButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      color: AppColors
                                                          .COLOR_TEAL_LIGHT,
                                                      onPressed: () async {
                                                        if (_formKey4
                                                            .currentState
                                                            .validate()) {
                                                          setState(() {
                                                            userMap['domains'] =
                                                                domains;
                                                            userMap['languages'] =
                                                                languages;
                                                            userMap['linkedInURL'] =
                                                                linkedinURL;
                                                            userMap['githubURL'] =
                                                                githubURL;
                                                            saveData();
                                                          });
                                                        }
                                                      },
                                                      child: Text('Next',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'GoogleSans',
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600))),
                                                ),
                                              ]),
                                          Text(error,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color:
                                                      AppColors.COLOR_ERROR_RED,
                                                  fontSize: 14.0)),
                                          new Divider(
                                              height: 18.0,
                                              color: Colors.transparent),
                                        ],
                                      ),
                                    ),
                                  )))
                                ]))))
              ]));
  }
}
