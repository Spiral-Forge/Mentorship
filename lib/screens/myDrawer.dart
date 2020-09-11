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
import 'package:dbapp/screens/profile/profile.dart';

class myDrawer extends StatefulWidget {
  @override
  _myDrawerState createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {
  // var dark=false;

  // void initState(){
  //   super.initState();
  //    print("printing dark mode");
  //    asyncmode();

  // }
  // asyncmode()async {
  //   var val= await StorageServices.getDarkMode();
  //   if(val){
  //     dark=true;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    File newDP;
    // ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    // final _themeChanger = Provider.of<ThemeChanger>(context);

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
              // leading: CircleAvatar(
              //               backgroundColor: Colors.black,
              //               radius: 75,
              //               child: ClipOval(
              //                 child: SizedBox(
              //                   width: 150,
              //                   height: 150,
              //                   child: StorageServices.getUserInfo().then((user) => user["photoURL"])
              //                 ),
              title: new Text(
                "Profile",
                style: TextStyle(fontFamily: 'GoogleSans', fontSize: 20),
              ),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              }),
          new Divider(),
          new ListTile(
              title: new Text(
                "Code of Conduct",
                style: TextStyle(fontFamily: 'GoogleSans', fontSize: 15),
              ),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Guidelines()));
              }),
          new ListTile(
              title: new Text(
                "Our Vision",
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
                "Help Center",
                style: TextStyle(fontFamily: 'GoogleSans', fontSize: 15),
              ),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new MyFeedback()));
              }),
          new Divider(),
          Consumer<ThemeNotifier>(builder: (context, notifier, child) {
            return Align(
              alignment: Alignment.bottomRight,
              child: new ListTile(
                leading: Icon(
                  Icons.lightbulb_outline,
                  size: 25,
                ),
                trailing: Transform.scale(
                  scale: 1.4,
                  child: Switch(
                    value: notifier.darkTheme,
                    onChanged: (val) async {
                      notifier.toggleTheme();
                      // var darkModeFlag=await StorageServices.getDarkMode();
                      // await StorageServices.saveDarkMode(!darkModeFlag);
                      // setState(() {
                      //   dark = val;
                      // });
                      // onThemeChanged(val, _themeChanger);
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
            );
          }),
          Divider(),
          new ListTile(
              title: new Text(
                "Logout",
                style: TextStyle(fontFamily: 'GoogleSans', fontSize: 15),
              ),
              trailing: new Icon(Icons.call_made),
              onTap: () async {
                await _auth.signOut();
              }),
          new Divider(),
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
