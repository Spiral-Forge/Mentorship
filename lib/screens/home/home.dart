import 'package:dbapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/screens/sidebarScreens/page.dart';
import 'package:dbapp/screens/profile/profile.dart';
import 'package:dbapp/screens/chat/chat.dart';



import 'package:dbapp/screens/home/homepage.dart';



class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex=0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _children = <Widget>[
    HomePage(),
    profile(),
    FriendlyChatApp()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_children[_currentIndex],
    bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('Profile'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          title: Text('Chat'),
        ),
      ],
      currentIndex: _currentIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    ),
    );
  }
}




