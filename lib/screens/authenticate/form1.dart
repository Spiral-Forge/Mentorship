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
import 'package:dbapp/screens/authenticate/form2.dart';

int _radioValue = -1;
int visibleCard = 1;

String post = '';

Map<String, dynamic> userMap = {
  'name': '',
  'phoneNo': '',
  'email': '',
  'password': '',
  'year': 'First',
  'branch': 'CSE-1',
  'rollNo': '',
  'linkedInURL': '',
  'githubURL': '',
  'domains': [],
  'languages': [],
  'hosteller': '',
  'post': ''
};

class RegisterForm1 extends StatefulWidget {
  //taken from parent props:
  final Function toggleView;
  RegisterForm1({this.toggleView});
  @override
  _RegisterForm1State createState() => _RegisterForm1State();
}

class _RegisterForm1State extends State<RegisterForm1> {
  final AuthService _auth = AuthService();
  final _formKey1 = GlobalKey<FormState>();

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

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      post = _radioValue == 0 ? 'Mentor' : 'Mentee';
    });
  }

  void initState() {
    super.initState();
    setState(() {
      final Map<String, dynamic> userMap = {
        'name': '',
        'phoneNo': '',
        'email': '',
        'password': '',
        'year': 'First',
        'branch': 'CSE-1',
        'rollNo': '',
        'linkedInURL': '',
        'githubURL': '',
        'domains': [],
        'languages': [],
        'hosteller': '',
        'post': ''
      };
      _radioValue = -1;
      post = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: AppColors.PROTEGE_CYAN,
      appBar: AppBar(
          backgroundColor: AppColors.COLOR_TEAL_DARK,
          elevation: 0.0,
          title: Text("Register"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Sign In'),
              onPressed: () {
                widget.toggleView();
              },
            )
          ]),
      body: loading
          ? Loading()
          : Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                margin: EdgeInsets.all(8),
                child: new Container(
                    padding: EdgeInsets.all(15),
                    child: Form(
                      key: _formKey1,
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          new Text(
                              'Do you want to register as a mentor or a mentee?'),
                          new Divider(height: 5.0, color: Colors.transparent),
                          new Row(
                            children: <Widget>[
                              new Radio(
                                  value: 0,
                                  groupValue: _radioValue,
                                  onChanged: _handleRadioValueChange),
                              new Text('Mentor'),
                              new Radio(
                                  value: 1,
                                  groupValue: _radioValue,
                                  onChanged: _handleRadioValueChange),
                              new Text('Mentee'),
                            ],
                          ),
                          new Container(
                              padding:
                                  const EdgeInsets.only(left: 175.0, top: 20.0),
                              child: new RaisedButton(
                                child: const Text('Next'),
                                onPressed: () {
                                  print(_radioValue);
                                  // It returns true if the form is valid, otherwise returns false
                                  if (_formKey1.currentState.validate() &&
                                      _radioValue != -1) {
                                    setState(() {
                                      userMap['post'] = post;
                                      print(userMap);
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterForm2(userMap)));
                                    // If the form is valid, display a Snackbar.
                                    // Scaffold.of(context).showSnackBar(
                                    //     SnackBar(content: Text('Data is in processing.')));
                                  } else {
                                    Scaffold.of(context).showSnackBar(
                                        SnackBar(content: Text('Error')));
                                  }
                                },
                              )),
                        ],
                      ),
                    )),
              ),
            ),
    );
  }
}
