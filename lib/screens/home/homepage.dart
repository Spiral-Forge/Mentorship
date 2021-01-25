import 'package:dbapp/blocs/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dbapp/shared/MyDrawer.dart';

final MyDrawer _drawer = new MyDrawer();

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
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: _drawer,
      body: Column(children: [
        Expanded(
            child: Container(
                child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 42, 0, 0),
              child: Row(children: [
                IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      _scaffoldKey.currentState.openDrawer();
                    }),
                Text(
                  "Home",
                  style: TextStyle(fontFamily: 'GoogleSans', fontSize: 23),
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
                              fit: BoxFit.scaleDown,
                              image: (url == null || url.length == 0)
                                  ? AssetImage('assets/images/homebg2.jpg')
                                  : NetworkImage(url))),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: ExpansionTile(
                      title: Center(
                          child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Text(name,
                            style: TextStyle(
                                fontFamily: 'GoogleSans',
                                fontWeight: FontWeight.w600,
                                fontSize: 18)),
                      )),
                      subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.date_range, size: 16),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(8, 0, 0, 5),
                                    child: Text(date,
                                        style: TextStyle(
                                            fontFamily: 'GoogleSans',
                                            fontSize: 16))),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.query_builder, size: 16),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(8, 0, 0, 5),
                                    child: Text(time,
                                        style: TextStyle(
                                            fontFamily: 'GoogleSans',
                                            fontSize: 16))),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.location_on, size: 16),
                                ),
                                Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.fromLTRB(8, 0, 0, 5),
                                      child: Text(venue,
                                          style: TextStyle(
                                              fontFamily: 'GoogleSans',
                                              fontSize: 16))),
                                ),
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
                            )),
                      ],
                    )),
              ],
            )));
  }
}
