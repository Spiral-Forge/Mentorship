import 'package:chatApp/config/constants.dart';
import 'package:chatApp/services/database.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';


enum SingingCharacter { login, suggestion, complaint, other }
var feedbackopt;

class MyFeedback extends StatefulWidget {

  @override
  _MyFeedbackState createState() => _MyFeedbackState();
}

class _MyFeedbackState extends State<MyFeedback> {

  final TextEditingController textController = new TextEditingController();

  final AuthMethods _auth=new AuthMethods();
  final DatabaseMethods databaseMethods=new DatabaseMethods();
  //final FirebaseAuth _authUser = FirebaseAuth.instance;
  // Future<FirebaseUser> getCurrentUser(){
  //   return _authUser.currentUser();
  // }

  Map <int,String> feedbackOption = {
    1:"Login Problem",
    2:"Suggestions",
    3:"Complaints",
    4:"Other issues",
  };
  String userID=Constants.myID;

  // @override
  // void initState(){
  //   super.initState();
  // //print("my id is "+Constants.myID);
  //   // setState((){
  //   //      userID: Constants.myID;
  //   // });
  //   // getCurrentUser().then((user){
  //   //   uid = user.uid;
  //   //   setState((){
  //   //      uid: uid;
  //   //   });
  //   // });
  // }

  submitFeedback(){
    if(textController.text.isNotEmpty){
      Map<String, dynamic> feedbackMap = {
        "type": feedbackOption[feedbackopt],
        "description": textController.text,
        'submittedBy': userID,
      };
       databaseMethods.addFeedback(feedbackMap).then((value) {
         if(value!=null){
           //show toast saying thanks
         }else{
           //show toasts saying some error occured
         }
        setState(() {
          textController.text="";
        });
       });
    }
   
  }
  //  @override
  // Widget build(BuildContext context) {
  //   return Container(child: Text("feedback screen"),);
  // }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Feedback"), backgroundColor: Colors.teal),
      body: Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
          
        Text(
          "Select type of feedback",style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            ),
        ),

        SizedBox(height: 25.0),
        BuildCheckBox(),
        SizedBox(height: 20.0),
        buildFeedbackForm(),
        SizedBox(height:20.0),
        Spacer(),
        Row(
          children:<Widget>[
            Expanded(
              child: FlatButton(
                onPressed: (){
                  submitFeedback();
                },
                color: Colors.teal,
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "SUBMIT",
                  style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                ),
              )
            )
          ]
        )
      ],
    ),
  ),
    );
  }



buildFeedbackForm(){
  return Container(
    height: 200.0,
    child: Stack(
      children:<Widget>[
        TextField(
          controller: textController,
          maxLines: 10,
          decoration: InputDecoration(
            hintText: "Please breifly describe the issue",
            hintStyle: TextStyle(
              fontSize:13.0,
              color: Color(0xffc5c5c5),

               ),
               border: OutlineInputBorder(
                 borderSide: BorderSide(color: Color(0xffe5e5e5)),

               )
            ),
          ),
      ]
    )
  );
}
}

class BuildCheckBox extends StatefulWidget {
  BuildCheckBox({Key key}) : super(key: key);

  @override
  _BuildCheckBoxState createState() => _BuildCheckBoxState();
}

class _BuildCheckBoxState extends State<BuildCheckBox> {
  SingingCharacter _character = SingingCharacter.login;

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Login Problem'),
          leading: Radio(
            value: SingingCharacter.login,
            groupValue: _character,
            onChanged: (SingingCharacter value) {
              setState(() {
                _character = value;
                feedbackopt=1;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Suggestions'),
          leading: Radio(
            value: SingingCharacter.suggestion,
            groupValue: _character,
            onChanged: (SingingCharacter value) {
              setState(() {
                _character = value;
                feedbackopt=2;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Complaints'),
          leading: Radio(
            value: SingingCharacter.complaint,
            groupValue: _character,
            onChanged: (SingingCharacter value) {
              setState(() {
                _character = value;
                feedbackopt=3;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Other issues'),
          leading: Radio(
            value: SingingCharacter.other,
            groupValue: _character,
            onChanged: (SingingCharacter value) {
              setState(() {
                _character = value;
                feedbackopt=4;
              });
            },
          ),
        ),
      ],
    );
 }
}
