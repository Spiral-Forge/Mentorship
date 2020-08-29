import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/profile/editProfile.dart';

import 'package:dbapp/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dbapp/services/auth.dart';

import 'package:provider/provider.dart';
import 'package:dbapp/blocs/theme.dart';
import 'package:dbapp/blocs/values.dart';

import 'package:dbapp/screens/sidebarScreens/about.dart';
import 'package:dbapp/screens/sidebarScreens/faqs.dart';
import 'package:dbapp/screens/sidebarScreens/feedback.dart';
import 'package:dbapp/screens/sidebarScreens/guidelines.dart';

class myDrawer extends StatefulWidget {
  @override
  _myDrawerState createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {
  var _darkTheme = true;

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    // final _themeChanger = Provider.of<ThemeChanger>(context);
    _darkTheme = (_themeChanger.getTheme() == darkTheme);
    final AuthService _auth = AuthService();
    // final FirebaseAuth _authUser = FirebaseAuth.instance;
    

    return new Drawer(
      child: new ListView(
        children: <Widget>[
          Divider(
            height: 5,
            color: Colors.transparent,
          ),
          new ListTile(
              title: new Text(
                "Code of Conduct",
                style: TextStyle(fontFamily: 'GoogleSans', fontSize: 15),
              ),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new Guidelines()));
              }),
          new ListTile(
              title: new Text(
                "About",
                style: TextStyle(fontFamily: 'GoogleSans', fontSize: 15),
              ),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new About()));
              }),
          new ListTile(
              title: new Text(
                "FAQs",
                style: TextStyle(fontFamily: 'GoogleSans', fontSize: 15),
              ),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new FAQS()));
              }),
          new ListTile(
              title: new Text(
                "Send Feedback",
                style: TextStyle(fontFamily: 'GoogleSans', fontSize: 15),
              ),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new MyFeedback()));
              }),
          new Divider(),
          new ListTile(
            leading: Icon(
              Icons.lightbulb_outline,
              size: 25,
            ),
            trailing: Transform.scale(
              scale: 1.4,
              child: Switch(
                value: _darkTheme,
                onChanged: (val) async {
                  var darkModeFlag=await StorageServices.getDarkMode();
                  await StorageServices.saveDarkMode(!darkModeFlag);
                  setState(() {
                    _darkTheme = val;
                  });
                  onThemeChanged(val, _themeChanger);
                },
              ),
            ),
            // leading: new IconButton(
            //             onPressed: () => _themeChanger.setTheme(Theme.dark()),
            //             icon: Icon(
            //               Icons.brightness_3
            //             ),
            //             color: AppColors.PROTEGE_GREY,
            //           ),
            // title: new Text("Change Theme"),
            // onTap: () {
            //   Navigator.of(context).pop();
            //   Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ThemeChanger(ThemeData.dark())));
            // }
          ),
          new Divider(
            height: 431,
            color: Colors.transparent,
          ),
          new ListTile(
              title: new Text(
                "Logout",
                style: TextStyle(fontFamily: 'GoogleSans', fontSize: 15),
              ),
              trailing: new Icon(Icons.call_made),
              onTap: () async {
                await _auth.signOut();
              }),
        ],
      ),
    );
  }
}

void onThemeChanged(bool value, ThemeChanger _themeChanger) async {
  (value)
      ? _themeChanger.setTheme(darkTheme)
      : _themeChanger.setTheme(lightTheme);
}
