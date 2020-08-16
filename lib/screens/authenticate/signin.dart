import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/authenticate/form1.dart';
import 'package:dbapp/services/auth.dart';
import 'package:dbapp/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin{
  final AuthService _auth=AuthService();
  final _formKey=GlobalKey<FormState>();
  bool loading=false;
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;

  //form state
  String email='';
  String password='';
  String error='';
  TextEditingController resetPasswordController=new TextEditingController();


   @override
  void initState(){
    super.initState();
    _iconAnimationController=new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 1000)
      );
      _iconAnimation=new CurvedAnimation(
        parent: _iconAnimationController,
         curve: Curves.easeInOut
      );
      _iconAnimation.addListener(()=>this.setState((){}));
      _iconAnimationController.forward();

  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.COLOR_TEAL_DARK,
        elevation: 0.0,
        title:Text("Sign In"),
        actions: <Widget>[
          FlatButton.icon(
            icon:Icon(Icons.person,color: Colors.white,),
            label:Text('Register',style:TextStyle(color:Colors.white)),
            onPressed: (){
              Navigator.push( context, new MaterialPageRoute( builder: (BuildContext context) => RegisterForm1()));
            },
          )
        ],
      ),
      body: loading ? Loading() : Container(
        padding: EdgeInsets.symmetric(vertical:20.0,horizontal:50.0),
          child:Center(
            child: SingleChildScrollView(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: _iconAnimation.value*200,
                    height:_iconAnimation.value*210,
                    decoration: new BoxDecoration(
                    //shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage('assets/images/logo.jpeg')
                      )
                  )),
                  Form(
                    key:_formKey, 
                              child: Column(
                      children: <Widget>[
                        SizedBox(height:20.0),
                        TextFormField(
                          decoration: textInputDecorations.copyWith(
                               labelText: "Enter Email",
                          ),
                          validator: (val) => val.isEmpty ? 'Enter an email' :null,
                          onChanged: (val){
                            setState(()=>email=val);
                          }
                        ),
                        SizedBox(height:20.0),
                        TextFormField(
                          decoration: textInputDecorations.copyWith(
                               labelText: "Enter Password",
                          ),
                          obscureText: true,
                          onChanged: (val){
                            setState(()=>password=val);
                          }
                        ),
                        SizedBox(height:25.0),
                        Container(
                          width:150,
                          height:50,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: const Color(0xFF565656))
                            ),
                            color:AppColors.PROTEGE_GREY,
                            child:Text(
                              'Sign In',
                              style: GoogleFonts.lato(textStyle:TextStyle(color:Colors.white,fontSize: 20)),
                              ),
                              onPressed: () async{
                                if(_formKey.currentState.validate()){
                                      setState(() {
                                        loading=true;
                                      });
                                      dynamic result=await _auth.signin(email, password);
                                      if(result == null){
                                          setState(() {
                                            error="Either email or password is incorrect. Try again.";
                                            loading=false;
                                          });
                                      }
                                  }
                              },
                          ),
                        ),
                        SizedBox(height:20.0),
                          GestureDetector(
                            onTap: (){
                               showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      padding: EdgeInsets.all(20.0),
                                      child: AlertDialog(
                                        shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                        contentPadding: EdgeInsets.all(15.0),
                                        title: Text('Enter your email',style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    // color: AppColors.PROTEGE_GREY,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                )),
                                        content: TextField(
                                          controller: resetPasswordController,
                                          decoration: InputDecoration(hintText: "Email address"),
                                        ),
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: new Text('CANCEL',style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    // color: AppColors.PROTEGE_GREY,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                )),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          new FlatButton(
                                            child: new Text('SEND RESET LINK',style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    // color: AppColors.PROTEGE_GREY,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                )),
                                            onPressed: () async {
                                              if(resetPasswordController.text.isEmpty){
                                                print("coming here");
                                                Toast.show("Email can't be empty.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                                              }else{
                                                var rv=await _auth.resetPassword(resetPasswordController.text);
                                                if(rv!=null){
                                                  Toast.show("Incorrect email. Please try again.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                                                  resetPasswordController.text="";
                                                }else{
                                                  Navigator.of(context).pop();
                                                  Toast.show("Password reset link has been sent to your email.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                                                }
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Text(
                              "Forgot password? Reset here",
                              style:TextStyle(
                                color:AppColors.PROTEGE_GREY,
                                fontSize: 19.0
                              )
                            ),
                          ),

                        SizedBox(height:20.0),
                          Text(
                            error,
                            style:TextStyle(
                              color:AppColors.COLOR_ERROR_RED,
                              fontSize: 14.0
                            )
                          )

                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          )

      );
  }
}