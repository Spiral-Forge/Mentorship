import 'package:dbapp/blocs/theme.dart';
import 'package:dbapp/blocs/values.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:dbapp/screens/sidebarScreens/about.dart';
import 'package:dbapp/screens/sidebarScreens/faqs.dart';
import 'package:dbapp/screens/sidebarScreens/feedback.dart';
import 'package:dbapp/screens/sidebarScreens/guidelines.dart';
import 'package:hexcolor/hexcolor.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth=AuthService();
  var _darkTheme = true;

  @override
  Widget build(BuildContext context) {

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    // final _themeChanger = Provider.of<ThemeChanger>(context);
    
    _darkTheme = (_themeChanger.getTheme() == darkTheme);

    return Scaffold(
      appBar: AppBar(
        title:Text("Mentorship App"),
        backgroundColor:Colors.teal[300] ,
        elevation: Theme.of(context).platform== TargetPlatform.iOS ? 0.0 : 4.0,
        // actions: <Widget>[
        //   FlatButton.icon(
        //     onPressed: () async{
        //       await _auth.signOut();
        //     }, 
        //     icon: Icon(Icons.person),
        //     label:Text('logout')
        //     )
        // ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new ListTile(
              title: new Text("Code of Conduct"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Guidelines()));
              }
            ),
            new ListTile(
              title: new Text("About"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new About()));
              }
            ),
            new ListTile(
              title: new Text("FAQs"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new FAQS()));
              }
            ),
            
            new ListTile(
              title: new Text("Contact us and feedback"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MyFeedback()));
              }
            ),
             
            new Divider(),
            new ListTile(
              trailing: Transform.scale(
                scale: 1.4,
                child: Switch(
                  value: _darkTheme,
                  onChanged: (val) {
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
              //             color: Hexcolor('#565656'),
              //           ),
              // title: new Text("Change Theme"),
              // onTap: () {
              //   Navigator.of(context).pop();
              //   Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ThemeChanger(ThemeData.dark())));
              // }
            ),           
            new Divider(),
            new ListTile(
              title: new Text("Logout"),
              trailing: new Icon(Icons.people),
              onTap: () async => await _auth.signOut()
            ),
          ],
        ),
      ),
      body:Text("hello world")
    );
  }
}

void onThemeChanged(bool value, ThemeChanger _themeChanger) async {
  (value) ? _themeChanger.setTheme(darkTheme) : _themeChanger.setTheme(lightTheme);
    // var prefs = await SharedPreferences.getInstance();
    // prefs.setBool('darkMode', value);
}

