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
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          Divider(
            height: 5,
            color: Colors.transparent,
          ),
          new ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 20,
                  child: ClipOval(
                      child: SizedBox(
                          width: 40,
                          height: 40,
                          child: photoURL != null && photoURL.length != 0
                              ? Image.network(photoURL)
                              : Image.asset("assets/images/avatars/av1.png")))),
              title: new Text(
                "Profile",
                style: TextStyle(fontFamily: 'GoogleSans', fontSize: 20),
              ),
              subtitle: new Text(
                "Logged In",
                style: TextStyle(fontFamily: 'GoogleSans', fontSize: 13),
              ),
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
                "Deadlines",
                style: TextStyle(fontFamily: 'GoogleSans', fontSize: 15),
              ),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DateView()));
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
                    },
                  ),
                ),
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
                await _auth.signOut(user.uid);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Authenticate(),
                  ),
                  (route) => false,
                );
              }),
          new Divider(),
        ],
      ),
    );
  }
}
