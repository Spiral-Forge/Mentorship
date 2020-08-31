import 'package:dbapp/blocs/theme.dart';
import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/screenConstants.dart';
import 'package:dbapp/screens/profile/peerProfile.dart';
import 'package:dbapp/services/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/services/auth.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:dbapp/screens/sidebarScreens/about.dart';
import 'package:dbapp/screens/sidebarScreens/faqs.dart';
import 'package:dbapp/screens/sidebarScreens/feedback.dart';
import 'package:dbapp/screens/sidebarScreens/guidelines.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dbapp/screens/myDrawer.dart';

import '../../constants/colors.dart';

final myDrawer _drawer = new myDrawer();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var themeFlag=false;
  final FirebaseAuth _authUser = FirebaseAuth.instance;
  final AuthService _auth = AuthService();
  bool loading = true;
  String post;
  bool postFlag = false;
  static List<dynamic> peerID = [];
  List fixedList = Iterable<int>.generate(peerID.length).toList();
  Future<FirebaseUser> getCurrentUser() {
    return _authUser.currentUser();
  }

  List<EventTile> eventlist = [];
  Widget eventList() {
    return loading
        ? Loading()
        : Center(
            child: Container(
            width: 350.0,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: eventlist.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                        child: ListView(shrinkWrap: true, children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                child: Wrap(children: <Widget>[
                              Container(
                                  width: 150.0,
                                  height: 150.0,
                                  decoration: new BoxDecoration(
                                      //shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: themeFlag ? new AssetImage(
                                              'assets/images/book.jpg'): new AssetImage(
                                              'assets/images/Protege no bg.png')))),
                            ]))
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                              child: Text("The Mentorship Society of IGDTUW",
                                  style: TextStyle(
                                      fontFamily: 'GoogleSans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: AppColors.PROTEGE_GREY))),
                        ],
                      ),
                      SizedBox(height: 35),
                    ]));
                  } else if (index == 1) {
                    return Center(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Text("UPCOMING EVENTS IN COLLEGE",
                              style: TextStyle(
                                  fontFamily: 'GoogleSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  ))),
                    );
                  } else {
                    return eventlist[index - 2];
                  }
                }),
          ));
  }

  void initState() {
    super.initState();
    StorageServices.getDarkMode().then((isDarkMode){
      print("is dark mode is ");
      print(isDarkMode);
    });
    DataBaseService().getEvents().then((val) {
      print(val.documents[0].data);
      List<EventTile> templist = [];
      for (var i = 0; i < val.documents.length; i++) {
        templist.add(EventTile(
            name: val.documents[i].data["name"],
            date: val.documents[i].data["date"],
            time: val.documents[i].data["time"],
            venue: val.documents[i].data["venue"],
            description: val.documents[i].data["description"],
            url: val.documents[i].data["url"],
            link: val.documents[i].data["link"]));
        this.setState(() {
          eventlist = templist;
          loading = false;
        });
      }
      setPost();
    });
  }

  void setPost() async {
    FirebaseUser user = await getCurrentUser();
    DataBaseService().getPeerData(user.uid).then((value) {
      setState(() {
        post = value.data["post"];
        postFlag = true;
        peerID = value.data["peerID"] != null ? value.data["peerID"] : [];
      });
      //print("this already happened");
    });
    // await StorageServices.getUserPost().then((value) {

    // });
  }

  //var _darkTheme = true;

  @override
  Widget build(BuildContext context) {
    // ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    // print("printing theme notifier");
    // print(_themeNotifier.darkTheme);
    // // final _themeChanger = Provider.of<ThemeChanger>(context);
    // _darkTheme = (_themeChanger.getTheme() == darkTheme);

    return Scaffold(
        appBar: AppBar(
          title: Text("Home", style: TextStyle(fontFamily: 'GoogleSans')),
          backgroundColor: AppColors.COLOR_TEAL_LIGHT,
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          actions: peerID.length <= 1
              ? <Widget>[
                  FlatButton.icon(
                      onPressed: () async {
                        //add navigation to edit profile page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PeerProfile(post,
                                    peerID.length == 0 ? null : peerID[0])));
                      },
                      icon: postFlag == true
                          ? Icon(
                              Icons.people,
                              color: Colors.white,
                            )
                          : Icon(null),
                      label: Text(
                        postFlag == true
                            ? post == "Mentor" ? 'Mentee' : 'Mentor'
                            : "",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'GoogleSans',
                            fontSize: 16),
                      ))
                ]
              : <Widget>[
                  PopupMenuButton<String>(
                    onSelected: (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PeerProfile(post, value))),
                    itemBuilder: (BuildContext context) {
                      return fixedList.map((index) {
                        return PopupMenuItem<String>(
                          value: peerID[index],
                          child: Text(
                              "View mentee " +
                                  (index + 1).toString() +
                                  " profile",
                              style: TextStyle(fontFamily: 'GoogleSans')),
                        );
                      }).toList();
                    },
                  )
                ],
        ),
        drawer: _drawer,
        body: eventList());
  }
}

class EventTile extends StatelessWidget {
  final String name;
  final String date;
  final String time;
  final String venue;
  final String description;
  final String url;
  final String link;

  EventTile(
      {@required this.name,
      this.date,
      this.time,
      this.venue,
      this.description,
      this.url,
      this.link});

  @override
  Widget build(BuildContext context) {
    print(url);
    return Container(
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 210.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill, image: NetworkImage(url)
                              //AssetImage("assets/images/bg2.jpg")
                              )),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: ExpansionTile(
                      // trailing: Icon(Icons.more),
                      title: Center(
                          child: Text(name,
                              style: TextStyle(
                                  fontFamily: 'GoogleSans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15))),
                      subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.date_range, size: 14),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: Text(date,
                                        style: TextStyle(
                                            fontFamily: 'GoogleSans',
                                            fontSize: 14))),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.query_builder, size: 14),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: Text(time,
                                        style: TextStyle(
                                            fontFamily: 'GoogleSans',
                                            fontSize: 14))),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.location_on, size: 14),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: Text(venue,
                                        style: TextStyle(
                                            fontFamily: 'GoogleSans',
                                            fontSize: 14))),
                              ],
                            ),
                          ]),
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(description,
                              style: TextStyle(fontFamily: 'GoogleSans')),
                        ),
                        new Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                            child: new RichText(
                              text: new TextSpan(
                                children: [
                                  new TextSpan(
                                    text: 'Register Here',
                                    style: new TextStyle(
                                        color: Colors.blue,
                                        fontFamily: 'GoogleSans'),
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () {
                                        launch(link);
                                      },
                                  ),
                                ],
                              ),
                            ))
                      ],
                      // ],
                    )),
              ],
            )));
  }
}

void onThemeChanged(bool value, ThemeChanger _themeChanger) async {
  (value)
      ? _themeChanger.setTheme(darkTheme)
      : _themeChanger.setTheme(lightTheme);
}
