import 'package:dbapp/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:dbapp/screens/authenticate/form2.dart';
import 'package:provider/provider.dart';
import 'package:dbapp/blocs/values.dart';

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
  // final AuthService _auth = AuthService();
  final _formKey1 = GlobalKey<FormState>();

  String error = '';
  bool loading = false;

  void initState() {
    super.initState();
    setState(() {
      post = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return new Scaffold(
        body: loading
            ? Loading()
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: new Container(
                    padding: EdgeInsets.only(top: 60.0),
                    child: Form(
                        key: _formKey1,
                        child: ListView(shrinkWrap: true, children: <Widget>[
                          new Divider(height: 35.0, color: Colors.transparent),
                          Container(
                              width: 20,
                              height: 150,
                              decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                      image: new AssetImage(
                                          'assets/images/Protege no bg.png')))),
                          new Divider(height: 55.0, color: Colors.transparent),
                          new Text(
                            'Hey,' + '\n' + 'register yourself as',
                            style: TextStyle(
                              fontFamily: 'GoogleSans',
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          new Divider(height: 32.0, color: Colors.transparent),
                          Column(children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userMap['post'] = 'Mentor';
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterForm2(userMap)));
                              },
                              child: Container(
                                  // height: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 55),
                                  child: Material(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColors.COLOR_TEAL_LIGHT,
                                      child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        child: Text('Mentor',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'GoogleSans'),
                                            textAlign: TextAlign.center),
                                      ))),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  userMap['post'] = 'Mentee';
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterForm2(userMap)));
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 55),
                                  child: Material(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColors.COLOR_TEAL_LIGHT,
                                      child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        child: Text('Mentee',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'GoogleSans'),
                                            textAlign: TextAlign.center),
                                      ))),
                            ),
                            SizedBox(height: 12.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Already registered? ',
                                    style: TextStyle(
                                        fontFamily: 'GoogleSans',
                                        fontSize: 14.0,
                                        color: themeFlag
                                            ? const Color(0xFF959595)
                                            : AppColors.PROTEGE_GREY)),
                                SizedBox(height: 5.0),
                                InkWell(
                                  onTap: () {
                                    widget.toggleView();
                                  },
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    margin: EdgeInsets.symmetric(vertical: 12),
                                    child: Text("Sign In Here",
                                        style: TextStyle(
                                            color: AppColors.COLOR_TEAL_LIGHT,
                                            fontSize: 14.0,
                                            fontFamily: 'GoogleSans',
                                            decoration:
                                                TextDecoration.underline)),
                                  ),
                                ),
                              ],
                            )
                          ])
                        ])))));
  }
}
