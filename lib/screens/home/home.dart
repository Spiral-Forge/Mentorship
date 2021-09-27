import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/ResourceCenter/resourcesCategoryList.dart';
import 'package:dbapp/screens/chat/chatScreenHandler.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/screens/home/homepage.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;
  final List<Widget> _children = <Widget>[
    ChatScreenHandler(),
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
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 68,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                size: 25,
              ),
              title: Text(
                'Chat',
                style: TextStyle(
                    color: themeFlag ? Colors.white : Color(0xff777777),
                    fontSize: 12,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w400),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 25,
              ),
              title: Text('Home',
                  style: TextStyle(
                      color: themeFlag ? Colors.white : Color(0xff777777),
                      fontSize: 12,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w400)),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.link,
                size: 25,
              ),
              title: Text('Resources',
                  style: TextStyle(
                      color: themeFlag ? Colors.white : Color(0xff777777),
                      fontSize: 12,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w400)),
            )
          ],
          currentIndex: _currentIndex,
          unselectedItemColor: themeFlag ? Colors.white : Color(0xff777777),
          selectedItemColor:
              themeFlag ? AppColors.COLOR_TURQUOISE : Color(0xff4B7191),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
