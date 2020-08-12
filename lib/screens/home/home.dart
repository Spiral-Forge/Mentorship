import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/ResourceCenter/resourceList.dart';
import 'package:dbapp/screens/ResourceCenter/resourcesCategoryList.dart';
import 'package:dbapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/screens/profile/profile.dart';
import 'package:dbapp/screens/chat/chat.dart';
import 'package:dbapp/screens/home/homepage.dart';



class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex=1;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _children = <Widget>[
    Profile(),
    HomePage(),
    ResourceCategoryList()
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
          icon: Icon(Icons.person),
          title: Text('Profile'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          title: Text('Resource Center'),
        ),
      ],
      currentIndex: _currentIndex,
      selectedItemColor: AppColors.COLOR_TEAL_LIGHT,
      onTap: _onItemTapped,
    ),
    );
  }
}




