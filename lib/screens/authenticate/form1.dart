import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:dbapp/screens/authenticate/form2.dart';
import 'package:hexcolor/hexcolor.dart';

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
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  @override
  _RegisterForm1State createState() => _RegisterForm1State();
}

class _RegisterForm1State extends State<RegisterForm1> {
  final AuthService _auth = AuthService();
  final _formKey1 = GlobalKey<FormState>();

  //form fields

  String error = '';
  bool loading = false;

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
      // appBar: AppBar(
      //     backgroundColor: AppColors.COLOR_TEAL_LIGHT,
      //     elevation: 0.0,
      //     title: Text("Register"),
      //     actions: <Widget>[
      //       FlatButton.icon(
      //         icon: Icon(Icons.person, color: Colors.white),
      //         label: Text('Sign In', style: TextStyle(color: Colors.white)),
      //         onPressed: () {
      //           widget.toggleView();
      //         },
      //       )
      //     ]),
      body: loading
          ? Loading()
          : SizedBox(
               height: MediaQuery.of(context).size.height,
               width: MediaQuery.of(context).size.width,
                // child: Card(
                  child:
                   new Container(
                      padding: EdgeInsets.only(top:60.0),
                      child: Form(
                        key: _formKey1,
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            new Divider(height: 35.0, color: Colors.transparent),
                            Container(
                                width: 20,
                                height: 150,
                                decoration: new BoxDecoration(
                                    //shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        // fit: BoxFit.fill,
                                        image: new AssetImage(
                                            'assets/images/Protege no bg.png')))),
                            new Divider(height: 35.0, color: Colors.transparent),
                            new Text(
                              'Hey,' + '\n' + 'register yourself as',
                              style: TextStyle(
                                fontFamily: 'GoogleSans',
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            new Divider(height: 55.0, color: Colors.transparent),
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                      setState(() {
                                        // _handleRadioValueChange(0);
                                        userMap['post'] = 'Mentor';
                                        print(userMap);
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterForm2(
                                                      userMap)));
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
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'GoogleSans'),
                                                    textAlign: TextAlign.center),
                                              ))),
                                ),
                                SizedBox(height: 10),
                                GestureDetector(
                                    onTap: () {
                                        setState(() {
                                          // _handleRadioValueChange(1);
                                          userMap['post'] = 'Mentee';
                                          print(userMap);
                                        });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterForm2(
                                                        userMap)));
                                      },
                                      child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 55),
                                      // padding: EdgeInsets.fromLTRB(18, 5, 18, 5),
                                      // height: 40,
                                      child: Material(
                                          borderRadius: BorderRadius.circular(20),
                                          color: AppColors.COLOR_TEAL_LIGHT,
                                              child: Container(
                                                height: 40,
                                                alignment: Alignment.center,
                                                child: Text('Mentee',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'GoogleSans'),
                                                    textAlign: TextAlign.center),
                                              ))),
                                ),

                                SizedBox(height: 12.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                        'Already registered? ',
                                        style: TextStyle(
                                            color: AppColors.PROTEGE_GREY,
                                            fontSize: 15.0
                                        )),
                                    //   ],
                                    // )
                                    SizedBox(height: 5.0),
                                    InkWell(
                                      onTap: () {
                                        widget.toggleView(); //Navigator.pushReplacement( context, new MaterialPageRoute( builder: (BuildContext context) => RegisterForm1()));
                                      },

                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        margin: EdgeInsets.symmetric(vertical: 12),
                                        child: Text("Sign In Here",
                                            style: TextStyle(
                                              // color: Hexcolor('#d6a495'),
                                                color: AppColors.COLOR_TEAL_LIGHT,
                                                fontSize: 15.0,
                                                decoration:
                                                TextDecoration.underline)),
                                      ),
                                    ),
                                  ],
                                )

                                // new Divider(
                                //     height: 35.0, color: Colors.transparent
                                // ),
                                // GestureDetector(
                                //   onTap:  ()=> widget.toggleView(),
                                //   child: Text("Already registered? Sign In Here",
                                //     style: TextStyle(
                                //         fontSize: 15.0,
                                //         decoration:
                                //             TextDecoration.underline)
                                //       ),
                                // ),
                                // new Divider(
                                //     height: 35.0, color: Colors.transparent
                                // ),
                                //
                                  
                              ],
                            )
                          ],
                        ),
                      ),
                ),
          ),
    );
  }
}
