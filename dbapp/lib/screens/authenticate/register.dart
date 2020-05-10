import 'package:dbapp/screens/home/home.dart';
import 'package:dbapp/services/auth.dart';
import 'package:dbapp/shared/constants.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

   //taken from parent props:
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth=AuthService();
  final _formKey=GlobalKey<FormState>();

 
  //form fields
  String email='';
  String password='';
  String error='';
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0.0,
        title:Text("appbar"),
        actions: <Widget>[
          FlatButton.icon(
            icon:Icon(Icons.person),
            label:Text('Sign In'),
            onPressed: (){
               widget.toggleView();
            },
          )
        ]
      ),
      body:Container(
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
                    validator: (val) => val.length<6 ? 'Enter an password 6+ chars long' :null,
                    obscureText: true,
                    onChanged: (val){
                      setState(()=>password=val);
                    }
                  ),
                  SizedBox(height:20.0),
                  RaisedButton(
                    color:Colors.green,
                    child:Text(
                      'Sign up',
                      style: TextStyle(color:Colors.white),
                      ),
                      onPressed: () async{
                        if(_formKey.currentState.validate()){
                            dynamic result=await _auth.register(email, password);
                            if(result == null){
                                setState(() {
                                  error='some error message';
                                });
                            }
                        }
                      },
                  ),
                  SizedBox(height:20.0),
                  Text(
                    error,
                    style:TextStyle(
                      color:Colors.red,
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