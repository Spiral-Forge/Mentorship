import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dbapp/shared/myDrawer.dart';

final myDrawer _drawer = new myDrawer();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var themeFlag = false;
  final FirebaseAuth _authUser = FirebaseAuth.instance;
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 150.0,
                                height: 150.0,
                                decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: themeFlag
                                            ? new AssetImage(
                                                'assets/images/Protege_white_text.png')
                                            : new AssetImage(
                                                'assets/images/Protege no bg.png')))),
                          ]),
                      Padding(
                        padding: const EdgeInsets.only(top: 150.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: Container(
                              child: Text("The Mentorship Society of IGDTUW",
                                  style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: themeFlag
                                          ? Colors.white
                                          : Colors.black)),
                            )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 200,
                      ),
                    ]);
                  } else {
                    return Container(width: 350, child: eventlist[index - 1]);
                  }
                }),
          ));
  }

  void initState() {
    super.initState();
    DataBaseService().getEvents().then((val) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: themeFlag ? AppColors.COLOR_DARK : Colors.white,
      key: _scaffoldKey,
      drawer: _drawer,
      body: Column(children: [
        Expanded(
            child: Container(
                child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(19.0, 30, 0, 0),
              child: Row(children: [
                IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: 28,
                      color: themeFlag ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    }),
                Text(
                  "Home",
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: themeFlag ? Colors.white : Colors.black),
                )
              ]),
            ),
            Expanded(child: eventList()),
          ]),
        )))
      ]),
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
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    return Container(
        child: Card(
            color: themeFlag ? Color(0xff5A5A5A) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 210.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.scaleDown,
                            image: (url == null || url.length == 0)
                                ? AssetImage('assets/images/homebg2.jpg')
                                : NetworkImage(url))),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          trailing: Icon(
                            Icons.arrow_drop_down,
                            size: 20,
                            color: themeFlag ? Colors.white : Colors.black,
                          ),
                          title: Center(
                              child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                        themeFlag ? Colors.white : Colors.black,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17)),
                          )),
                          subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.date_range,
                                        size: 20,
                                        color: themeFlag
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(date,
                                          style: TextStyle(
                                              color: themeFlag
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Quicksand',
                                              fontSize: 11)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.query_builder,
                                        size: 20,
                                        color: themeFlag
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(time,
                                          style: TextStyle(
                                              color: themeFlag
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Quicksand',
                                              fontSize: 11)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.location_on,
                                        size: 20,
                                        color: themeFlag
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(venue,
                                          style: TextStyle(
                                              color: themeFlag
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Quicksand',
                                              fontSize: 11)),
                                    ),
                                  ],
                                ),
                              ]),
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Text(description,
                                  style: TextStyle(fontFamily: 'Quicksand')),
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
                                            fontFamily: 'Quicksand'),
                                        recognizer: new TapGestureRecognizer()
                                          ..onTap = () {
                                            launch(link);
                                          },
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      )),
                ],
              ),
            )));
  }
}
