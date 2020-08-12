import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/services/auth.dart';
import 'package:dbapp/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth=AuthService();
  final _formKey=GlobalKey<FormState>();
  bool loading=false;
  //form state
  String email='';
  String password='';
  String error='';


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColors.PROTEGE_CYAN,
      appBar: AppBar(
        backgroundColor: AppColors.COLOR_TEAL_DARK,
        elevation: 0.0,
        title:Text("Sign In"),
        actions: <Widget>[
          FlatButton.icon(
            icon:Icon(Icons.person),
            label:Text('Register'),
            onPressed: (){
              widget.toggleView();
            },
          )
        ],
      ),
      body: loading ? Loading() : Container(
        padding: EdgeInsets.symmetric(vertical:20.0,horizontal:50.0),
          child:Form(
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
                SizedBox(height:20.0),
                RaisedButton(
                  color:AppColors.PROTEGE_GREY,
                  child:Text(
                    'Sign In',
                    style: TextStyle(color:Colors.white),
                    ),
                    onPressed: () async{
                      if(_formKey.currentState.validate()){
                            setState(() {
                              loading=true;
                            });
                            dynamic result=await _auth.signin(email, password);
                            if(result == null){
                                setState(() {
                                  error='Couldnt sign you in.';
                                  loading=false;
                                });
                            }
                        }
                    },
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
          )
          )

      );
  }
}