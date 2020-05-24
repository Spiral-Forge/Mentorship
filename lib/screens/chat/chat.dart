import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:dbapp/services/auth.dart';
import 'package:dbapp/screens/chat/chatscreen.dart';
import 'package:dbapp/screens/sidebarScreens/about.dart';
import 'package:dbapp/screens/sidebarScreens/faqs.dart';
import 'package:dbapp/screens/sidebarScreens/feedback.dart';
import 'package:dbapp/screens/sidebarScreens/guidelines.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/database.dart';
import '../../services/database.dart';
import 'package:dbapp/shared/loading.dart';

// void main(){
//   runApp(new FriendlyChatApp());
// }

class FriendlyChatApp extends StatefulWidget{
  
  @override
  _FriendlyChatAppState createState() => _FriendlyChatAppState();
}

class _FriendlyChatAppState extends State<FriendlyChatApp> {
  DataBaseService dataBaseService = new DataBaseService();
  QuerySnapshot searchResultSnapshot;
  bool loading=true;
  String chatroomid="";
  String uid="";
  String peerName;
  String myname;

  final String peerId = "S03TGDOFDMYayaQ9bAGmWxG10sj1";

  
  final AuthService _auth=AuthService();
  final FirebaseAuth _authUser = FirebaseAuth.instance;
  Future<FirebaseUser> getCurrentUser(){
    return _authUser.currentUser();
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
  

  @override
  void initState(){
    print("hi firest call");
    super.initState();
    getCurrentUser().then((user){
      uid = user.uid;
      print("uid is this "+uid);
      setState((){
         uid: uid;
      });
      chatroomid = getChatRoomId(uid, peerId);
      print("hey");
      print(chatroomid);
      setState((){
         chatroomid= chatroomid;
      });
      dataBaseService.getUserName(peerId).then((value){
        peerName = value;
        print(peerName);
        dataBaseService.getMyName(uid).then((value){
          setState(() {
            myname = value;
          });
          print(myname);
          List<String> users = [myname,peerName];
          Map<String, dynamic> chatRoom = {
            "users": users,
            "chatRoomId" : chatroomid,
          };

          dataBaseService.addChatRoom(chatRoom, chatroomid);
          setState(() {
            loading=false;
          });

        });
      });
    });
  }

  @override 
  Widget build(BuildContext context){
    return new MaterialApp( 
      title: "Friendly Chat",
      theme: defaultTargetPlatform == TargetPlatform.iOS ? kIOSTheme : KDefaultTheme,
       //home: new Text(chatroomid));
      home: loading ? Loading() : new ChatScreen( 
        chatRoomId: chatroomid,
        myName: myname, )
    );
  }
}

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.teal,
  primaryColor: Colors.teal[200],
  primaryColorBrightness: Brightness.light,
);

final ThemeData KDefaultTheme = new ThemeData(
  primarySwatch: Colors.teal,
  accentColor: Colors.teal[200],
);