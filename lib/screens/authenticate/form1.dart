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
  'year': '',
  'branch': '',
  'rollNo': '',
  'linkedInURL': '',
  'githubURL': '',
  'domains': [],
  'languages': [],
  'hosteller': '',
  'post': '',
  'cohort': ''
};

class RegisterForm1 extends StatefulWidget {
  //taken from parent props:
  final Function toggleView;
  RegisterForm1({this.toggleView});
  @override
  _RegisterForm1State createState() => _RegisterForm1State();
}

class _RegisterForm1State extends State<RegisterForm1> {
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
        backgroundColor: themeFlag ? AppColors.COLOR_DARK : Colors.white,
        body: loading
            ? Loading()
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(children: [
                  Positioned(
                    right: 0,
                    child: Image(
                      image:
                          AssetImage('assets/images/lightUpperRightPlant.png'),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: MediaQuery.of(context).size.height * 0.65,
                    child: Image(
                      image: AssetImage('assets/images/lightDownLeft.png'),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Image(
                      image:
                          AssetImage('assets/images/lightDownRightPlant.png'),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 60.0),
                      child: Form(
                          key: _formKey1,
                          child: ListView(shrinkWrap: true, children: <Widget>[
                            new Divider(
                                height: 35.0, color: Colors.transparent),
                            Container(
                                width: 20,
                                height: 150,
                                decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                        image: themeFlag
                                            ? new AssetImage(
                                                'assets/images/Protege_white_text.png')
                                            : new AssetImage(
                                                'assets/images/Protege no bg.png')))),
                            new Divider(
                                height: 55.0, color: Colors.transparent),
                            new Text(
                              'Hey,' + '\n' + 'register yourself as',
                              style: TextStyle(
                                color: themeFlag ? Colors.white : Colors.black,
                                fontFamily: 'Quicksand',
                                fontSize: 27,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            new Divider(
                                height: 32.0, color: Colors.transparent),
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 55),
                                    child: Material(
                                        borderRadius: BorderRadius.circular(24),
                                        color: AppColors.COLOR_TURQUOISE,
                                        child: Container(
                                          width: 245,
                                          height: 29,
                                          alignment: Alignment.center,
                                          child: Text('Mentor',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Quicksand'),
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 55),
                                    child: Material(
                                        borderRadius: BorderRadius.circular(20),
                                        color: AppColors.COLOR_TURQUOISE,
                                        child: Container(
                                          width: 245,
                                          height: 29,
                                          alignment: Alignment.center,
                                          child: Text('Mentee',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Quicksand'),
                                              textAlign: TextAlign.center),
                                        ))),
                              ),
                              SizedBox(height: 30.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Already registered? ',
                                      style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: themeFlag
                                              ? Colors.white
                                              : AppColors.PROTEGE_GREY)),
                                  SizedBox(height: 5.0),
                                  InkWell(
                                    onTap: () {
                                      widget.toggleView();
                                    },
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 12),
                                      child: Text("Sign In Here",
                                          style: TextStyle(
                                              color: AppColors.COLOR_TURQUOISE,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              fontFamily: 'Quicksand',
                                              decoration:
                                                  TextDecoration.underline)),
                                    ),
                                  ),
                                ],
                              )
                            ])
                          ]))),
                ])));
  }
}
