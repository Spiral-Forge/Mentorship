import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/authenticate/authenticate.dart';
import 'package:dbapp/services/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/screens/sidebarScreens/about.dart';
import 'package:dbapp/screens/sidebarScreens/faqs.dart';
import 'package:dbapp/screens/sidebarScreens/feedback.dart';
import 'package:dbapp/screens/sidebarScreens/guidelines.dart';
import 'package:dbapp/screens/sidebarScreens/date_view.dart';
import 'package:dbapp/screens/profile/profile.dart';
import 'package:flutter_switch/flutter_switch.dart';

class myDrawer extends StatefulWidget {
  @override
  _myDrawerState createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {
  var photoURL = '';

  void initState() {
    super.initState();
    StorageServices.getUserInfo().then((value) {
      setState(() {
        photoURL = value["photoURL"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final user = Provider.of<FirebaseUser>(context);

    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    final Widget space = SizedBox(
      height: 10,
    );

    return new Drawer(
      child: new ListView(
        children: <Widget>[
          Divider(
            height: 5,
            color: Colors.transparent,
          ),
          new ListTile(
              leading: Stack(children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 32,
                  backgroundImage: photoURL != null && photoURL.length != 0
                      ? Image.network(photoURL)
                      : AssetImage("assets/images/avatars/av1.png"),
                ),
                Positioned(
                    left: 50,
                    top: 35,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 5,
                    )),
              ]),
              title: new Text(
                "Profile",
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 23,
                    fontWeight: FontWeight.w700),
              ),
              subtitle: new Text(
                "Logged In",
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: themeFlag
                        ? AppColors.COLOR_TURQUOISE
                        : Color(0xff777777)),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              }),
          // new Divider(),
          new ListTile(
              title: new Text(
                "Code of Conduct",
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 19,
                    fontWeight: FontWeight.w500),
              ),
              trailing: new Icon(
                Icons.arrow_right,
                size: 39,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Guidelines()));
              }),
          space,
          new ListTile(
              title: new Text(
                "Deadlines",
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 19,
                    fontWeight: FontWeight.w500),
              ),
              trailing: new Icon(
                Icons.arrow_right,
                size: 39,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DateView()));
              }),
          space,
          new ListTile(
              title: new Text(
                "Our Vision",
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 19,
                    fontWeight: FontWeight.w500),
              ),
              trailing: new Icon(
                Icons.arrow_right,
                size: 39,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new About()));
              }),
          space,
          new ListTile(
              title: new Text(
                "FAQs",
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 19,
                    fontWeight: FontWeight.w500),
              ),
              trailing: new Icon(
                Icons.arrow_right,
                size: 39,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new FAQS()));
              }),
          space,
          new ListTile(
              title: new Text(
                "Help Center",
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 19,
                    fontWeight: FontWeight.w500),
              ),
              trailing: new Icon(
                Icons.arrow_right,
                size: 39,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new MyFeedback()));
              }),
          space,
          // new Divider(),
          Consumer<ThemeNotifier>(builder: (context, notifier, child) {
            return Padding(
              padding: const EdgeInsets.only(right: 20, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 39,
                  ),
                  FlutterSwitch(
                    width: 30.0,
                    height: 15.0,
                    valueFontSize: 12.0,
                    toggleSize: 10.0,
                    toggleColor: themeFlag ? Colors.black : Colors.white,
                    activeColor: themeFlag ? Colors.white : Colors.black,
                    value: notifier.darkTheme,
                    onToggle: (val) async {
                      notifier.toggleTheme();
                    },
                  ),
                ],
              ),
            );
          }),
          space,
          // Divider(),
          new ListTile(
              title: new Text(
                "Logout",
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 19,
                    fontWeight: FontWeight.w500),
              ),
              trailing: new Icon(Icons.call_made),
              onTap: () async {
                await _auth.signOut(user.uid);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Authenticate(),
                  ),
                  (route) => false,
                );
              }),
        ],
      ),
    );
  }
}
