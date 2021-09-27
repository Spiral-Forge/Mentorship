import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/home/home.dart';
import 'package:dbapp/services/auth.dart';
import 'package:dbapp/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:toast/toast.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  String email = '';
  String password = '';
  String error = '';
  TextEditingController resetPasswordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000));
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeInOut);
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    final bg = Color(0xff303030);
    return Scaffold(
        backgroundColor: themeFlag ? bg : Colors.white,
        body: loading
            ? Loading()
            : Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: _iconAnimation.value * 200,
                            height: _iconAnimation.value * 210,
                            decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: themeFlag
                                        ? new AssetImage(
                                            'assets/images/Protege_white_text.png')
                                        : new AssetImage(
                                            'assets/images/Protege no bg.png')))),
                        new Divider(height: 35.0, color: Colors.transparent),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              TextFormField(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: textInputDecorations.copyWith(
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20),
                                      labelText: "Enter Email",
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          borderSide: BorderSide(
                                            width: 1.5,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          borderSide: BorderSide(
                                              color:
                                                  AppColors.COLOR_TURQUOISE))),
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter an email' : null,
                                  onChanged: (val) {
                                    setState(
                                        () => email = val.replaceAll(" ", ""));
                                  }),
                              SizedBox(height: 20.0),
                              TextField(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: textInputDecorations.copyWith(
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20),
                                      labelText: "Enter Password",
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          borderSide: BorderSide(
                                            width: 1.5,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          borderSide: BorderSide(
                                              color:
                                                  AppColors.COLOR_TURQUOISE))),
                                  obscureText: true,
                                  onChanged: (val) {
                                    setState(() => password = val);
                                  }),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        var width =
                                            MediaQuery.of(context).size.width;
                                        return Container(
                                          padding: EdgeInsets.all(20.0),
                                          child: AlertDialog(
                                            insetPadding: EdgeInsets.zero,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            backgroundColor:
                                                themeFlag ? bg : Colors.white,
                                            // shape: RoundedRectangleBorder(
                                            //     borderRadius: BorderRadius.all(
                                            //         Radius.circular(0))),
                                            contentPadding:
                                                EdgeInsets.all(15.0),
                                            title: Container(
                                              width: 366 > width * 0.9
                                                  ? width * 0.9
                                                  : 366,
                                              child: Center(
                                                child: Text(
                                                  'Enter your email',
                                                  style: TextStyle(
                                                    color: themeFlag
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 27,
                                                    fontFamily: 'Quicksand',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            content: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller:
                                                        resetPasswordController,
                                                    decoration: InputDecoration(
                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: themeFlag
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black),
                                                        ),
                                                        hintStyle: TextStyle(
                                                          color: themeFlag
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                        hintText:
                                                            "Email address"),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          padding:
                                                              EdgeInsets.all(0),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Quicksand',
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: AppColors
                                                                .COLOR_TURQUOISE,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          padding:
                                                              EdgeInsets.all(0),
                                                        ),
                                                        onPressed: () async {
                                                          if (resetPasswordController
                                                              .text.isEmpty) {
                                                            Toast.show(
                                                                "Email can't be empty.",
                                                                context,
                                                                duration: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity: Toast
                                                                    .BOTTOM);
                                                          } else {
                                                            var rv = await _auth
                                                                .resetPassword(
                                                                    resetPasswordController
                                                                        .text);
                                                            if (rv != null) {
                                                              Toast.show(
                                                                  "Incorrect email. Please try again.",
                                                                  context,
                                                                  duration: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity: Toast
                                                                      .BOTTOM);
                                                              resetPasswordController
                                                                  .text = "";
                                                            } else {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Toast.show(
                                                                  "Password reset link has been sent to your email.",
                                                                  context,
                                                                  duration: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity: Toast
                                                                      .BOTTOM);
                                                            }
                                                          }
                                                        },
                                                        child: Text(
                                                          'Send Reset Link',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Quicksand',
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: AppColors
                                                                .COLOR_TURQUOISE,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  alignment: Alignment.bottomRight,
                                  child: Text("Forgot password?",
                                      style: TextStyle(
                                          color: AppColors.COLOR_TURQUOISE,
                                          fontSize: 15.0,
                                          fontFamily: 'Quicksand',
                                          fontWeight: FontWeight.w500,
                                          decoration:
                                              TextDecoration.underline)),
                                ),
                              ),
                              SizedBox(height: 45.0),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                child: MaterialButton(
                                  minWidth: 140,
                                  height: 34,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: AppColors.COLOR_TURQUOISE,
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Quicksand'),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      var token =
                                          await _firebaseMessaging.getToken();
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic result = await _auth.signin(
                                          email, password, token);
                                      if (result.runtimeType ==
                                          PlatformException) {
                                        setState(() {
                                          error = result.message.toString();
                                          loading = false;
                                        });
                                      } else {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Home(),
                                          ),
                                          (route) => false,
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('New Here? ',
                                      style: TextStyle(
                                          color: themeFlag
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 14.5,
                                          fontFamily: 'Quicksand',
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(height: 5.0),
                                  InkWell(
                                    onTap: () {
                                      widget.toggleView();
                                    },
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 12),
                                      child: Text("Register Now",
                                          style: TextStyle(
                                              color: AppColors.COLOR_TURQUOISE,
                                              fontSize: 14.5,
                                              fontFamily: 'Quicksand',
                                              fontWeight: FontWeight.w500,
                                              decoration:
                                                  TextDecoration.underline)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Text(error,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppColors.COLOR_ERROR_RED,
                                      fontSize: 14.0))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )));
  }
}
