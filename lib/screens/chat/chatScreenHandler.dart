import 'package:dbapp/screens/chat/chatRoomScreen.dart';
import 'package:dbapp/screens/chat/emptyChatHandler.dart';
import 'package:dbapp/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/screens/chat/chatRoomList.dart';
class ChatScreenHandler extends StatefulWidget {
  @override
  _ChatScreenHandlerState createState() => _ChatScreenHandlerState();
}

class _ChatScreenHandlerState extends State<ChatScreenHandler> {
  var user;


  void initState(){
    setUser();
    super.initState();
  }
  setUser() async{
    var userData=await StorageServices.getUserInfo();
    print(userData);
    setState(() {
      user=userData;
    });

  }
  @override
  Widget build(BuildContext context) {
     if(user==null || user["peerID"]==null || user["peerID"].length==0){
      return EmptyChat();
    }
    else{
      return ChatRoomList(user["id"],user["peerID"]);
    }
  }
}