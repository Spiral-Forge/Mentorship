//import 'package:dbapp/services/auth.dart';
import 'package:chatApp/config/constants.dart';
import 'package:chatApp/helper/Storage.dart';
import 'package:chatApp/views/chatRoomScreen.dart';
import 'package:chatApp/views/homepage.dart';
import 'package:chatApp/views/profile.dart';
import 'package:flutter/material.dart';
// import 'package:dbapp/screens/profile/profile.dart';
// import 'package:dbapp/screens/chat/chat.dart';
// import 'package:dbapp/screens/home/homepage.dart';



class BottomNavigationScreen extends StatefulWidget {

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex=1;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _children = <Widget>[
    Profile(),
    HomePage(),
    ChatRoom()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState(){
    setUserInfo();
    super.initState();
  }
  
  void setUserInfo() async{
      Constants.myID = await StorageHelperFunctions.getUserID();
      //print(Constants.myID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_children[_currentIndex],
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('Profile'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          title: Text('Chat'),
        ),
      ],
      currentIndex: _currentIndex,
      selectedItemColor: Colors.teal[300],
      onTap: _onItemTapped,
    ),
    );
  }
}




