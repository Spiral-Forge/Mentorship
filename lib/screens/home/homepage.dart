import 'package:dbapp/blocs/theme.dart';
import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/screenConstants.dart';
import 'package:dbapp/screens/profile/peerProfile.dart';
import 'package:dbapp/screens/profile/unaddedProfile.dart';
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
  var themeFlag = false;
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
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return loading
        ? Loading()
        : Center(
            child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: eventlist.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Stack(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 45),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // Center(
                              // alignment: Alignment.center,
                              // child: Wrap(children: <Widget>[
                              Container(
                                  width: 150.0,
                                  height: 150.0,
                                  decoration: new BoxDecoration(
                                      //shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: themeFlag
                                              ? new AssetImage(
                                                  'assets/images/Protege_white_text.png')
                                              : new AssetImage(
                                                  'assets/images/Protege no bg.png')))),
                              // ])
                            ]),
                      ),
                      // ]),

                      Padding(
                        padding: const EdgeInsets.only(top: 198.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                child: Container(
                              child: Text("The Mentorship Society of IGDTUW",
                                  // textAlign: Alignment.center,
                                  style: TextStyle(
                                      fontFamily: 'GoogleSans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: themeFlag
                                          ? Colors.white
                                          : Color(0xFF303030))),
                            )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 240,
                      )
                    ]);
                  } else {
                    return Container(width: 350, child: eventlist[index - 1]);
                  }
                }),
          ));
  }

  void initState() {
    super.initState();
    // StorageServices.getDarkMode().then((isDarkMode){
    //   print("is dark mode is ");
    //   print(isDarkMode);
    // });
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
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    return Scaffold(
        key: _scaffoldKey,
        drawer: _drawer,
        body: Column(children: [
          Expanded(
              child: Container(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Column(children: [
                        Expanded(
                          child: Stack(children: <Widget>[
                            Container(
                                height:
                                    MediaQuery.of(context).size.height / 3.3,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/homedark.jpg'),
                                      fit: BoxFit.cover),
                                )),
                            Container(
                              height: MediaQuery.of(context).size.height / 3.3,
                              color: themeFlag
                                  ? Hexcolor('#303030').withOpacity(0.55)
                                  : Colors.white.withOpacity(0.55),
                            ),
                            Expanded(child: eventList()),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15.0, 42, 0, 0),
                              child: Row(children: [
                                IconButton(
                                    icon: Icon(Icons.menu),
                                    onPressed: () {
                                      _scaffoldKey.currentState.openDrawer();
                                    }),
                                Text(
                                  "Home",
                                  style: TextStyle(
                                      fontFamily: 'GoogleSans', fontSize: 23),
                                )
                              ]),
                            ),
                          ]),
                        )
                      ])))),
        ])

        // Container(
        //   child: Stack(
        //       children: <Widget>[
        // Container(
        //     height: MediaQuery.of(context).size.height / 3.3,
        //     decoration: BoxDecoration(
        //       image: DecorationImage(
        //           image: AssetImage('assets/images/homedark.jpg'),
        //           fit: BoxFit.cover),
        //     )),
        // Container(
        //   height: MediaQuery.of(context).size.height / 3.3,
        //   color: Colors.white.withOpacity(0.7),
        // ),
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(15.0, 42, 0, 0),
        //   child: Row(children: [
        //     IconButton(
        //         icon: Icon(Icons.menu),
        //         onPressed: () {
        //           _scaffoldKey.currentState.openDrawer();
        //         }),
        //     Text(
        //       "Home",
        //       style: TextStyle(fontFamily: 'GoogleSans', fontSize: 23),
        //     )
        //   ]),
        // ),
        //         Expanded(child: eventList()),
        //         SizedBox(
        //           height: 18,
        //         )
        //       ]),
        // )
        );
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
                              fit: BoxFit.scaleDown, image: NetworkImage(url))),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: ExpansionTile(
                      title: Center(
                          child: Text(name,
                              style: TextStyle(
                                  fontFamily: 'GoogleSans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18))),
                      subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.date_range, size: 15),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: Text(date,
                                        style: TextStyle(
                                            fontFamily: 'GoogleSans',
                                            fontSize: 15))),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.query_builder, size: 15),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: Text(time,
                                        style: TextStyle(
                                            fontFamily: 'GoogleSans',
                                            fontSize: 15))),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.location_on, size: 15),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: Text(venue,
                                        style: TextStyle(
                                            fontFamily: 'GoogleSans',
                                            fontSize: 15))),
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
                    )),
              ],
            )));
  }
}
