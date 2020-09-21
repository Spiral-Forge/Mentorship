import 'dart:math';

import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/shared/clipper.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class PeerProfile extends StatefulWidget {
  final String peerID;
  final String post;
  PeerProfile(this.post, this.peerID);
  @override
  _PeerProfileState createState() => _PeerProfileState();
}

class _PeerProfileState extends State<PeerProfile> {
  Map<String, dynamic> user = {};
  bool loading = true;
  int avatorNum = Random().nextInt(4) + 1;

  void initState() {
    DataBaseService().getPeerData(widget.peerID).then((userinfo) {
      setState(() {
        user = userinfo.data;
        loading = false;
      });
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    String hostel = user["hostel"] != null && user["hostel"] == true
        ? "Hosteller: Yes"
        : "Hosteller: No";
    return loading
        ? Loading()
        : Scaffold(
            body: Column(children: [
            Expanded(
                child: Container(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 32),
                            Padding(
                              padding: EdgeInsets.fromLTRB(32, 32, 0, 0),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text(
                                        widget.post == "Mentee"
                                            ? "Your Mentor"
                                            : "Your Mentee",
                                        style: TextStyle(
                                            fontFamily: 'GoogleSans',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 25)),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Builder(
                                builder: (context) => Container(
                                  child: ListView(shrinkWrap: true, children: <
                                      Widget>[
                                    Stack(children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: ClipPath(
                                          child: Column(
                                            children: <Widget>[
                                              Image.asset(
                                                "assets/images/bg2.jpg",
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                              ),
                                            ],
                                          ),
                                          clipper: GetClipper(),
                                        ),
                                      ),
                                      Positioned(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        top:
                                            MediaQuery.of(context).size.height /
                                                8.3,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.center,
                                                child: CircleAvatar(
                                                  radius: 75,
                                                  child: ClipOval(
                                                    child: SizedBox(
                                                      width: 150,
                                                      height: 150,
                                                      child: user['photoURL'] !=
                                                              null
                                                          ? Image.network(
                                                              user['photoURL'],
                                                              fit: BoxFit
                                                                  .scaleDown)
                                                          : Image.asset(
                                                              "assets/images/avatars/av1.png"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ]),
                                    SizedBox(
                                      height: 0,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          user["name"] != null
                                              ? user["name"]
                                              : "null",
                                          style: TextStyle(
                                              fontFamily: 'GoogleSans',
                                              fontSize: 28)),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        user["post"] != null
                                            ? user["post"]
                                            : "Null",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'GoogleSans',
                                          color: Hexcolor('#d89279'),
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 25),
                                    Card(
                                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: ListTile(
                                              title: Text(
                                                  user["contact"] != null
                                                      ? user["contact"]
                                                          .toString()
                                                      : "null",
                                                  style: TextStyle(
                                                      fontFamily: 'GoogleSans',
                                                      fontSize: 20)),
                                              leading: Icon(
                                                Icons.phone,
                                                color:
                                                    AppColors.COLOR_TEAL_LIGHT,
                                              ),
                                            ),
                                          ),
                                          Divider(),
                                          ListTile(
                                            title: Text(
                                                user["email"] == null
                                                    ? "null"
                                                    : user["email"],
                                                style: TextStyle(
                                                    fontFamily: 'GoogleSans',
                                                    fontSize: 20)),
                                            leading: Icon(
                                              Icons.mail,
                                              color: AppColors.COLOR_TEAL_LIGHT,
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 6.0),
                                            child: ListTile(
                                              title: Text(
                                                  user["year"] == null
                                                      ? "null"
                                                      : user["branch"]
                                                              .toString() +
                                                          ", " +
                                                          user["year"] +
                                                          " year",
                                                  style: TextStyle(
                                                      fontFamily: 'GoogleSans',
                                                      fontSize: 20)),
                                              subtitle: Text(
                                                  user["rollNo"] == null
                                                      ? "null"
                                                      : user["rollNo"]
                                                              .toString() +
                                                          "                                                    " +
                                                          hostel,
                                                  style: TextStyle(
                                                      fontFamily: 'GoogleSans',
                                                      fontSize: 20)),
                                              isThreeLine: true,
                                              leading: Icon(
                                                Icons.school,
                                                color:
                                                    AppColors.COLOR_TEAL_LIGHT,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Card(
                                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: ListTile(
                                              title: Text("Languages",
                                                  style: TextStyle(
                                                      fontFamily: 'GoogleSans',
                                                      fontSize: 18)),
                                              subtitle: Text(
                                                  user["languages"] != null
                                                      ? user["languages"]
                                                          .toString()
                                                          .split('[')[1]
                                                          .split(']')[0]
                                                      : "null",
                                                  style: TextStyle(
                                                      fontFamily: 'GoogleSans',
                                                      fontSize: 20)),
                                              leading: Icon(
                                                Icons.code,
                                                color:
                                                    AppColors.COLOR_TEAL_LIGHT,
                                              ),
                                            ),
                                          ),
                                          Divider(),
                                          ListTile(
                                            title: Text("Domains",
                                                style: TextStyle(
                                                    fontFamily: 'GoogleSans',
                                                    fontSize: 18)),
                                            subtitle: Text(
                                                user["domains"] != null
                                                    ? user["domains"]
                                                        .toString()
                                                        .split('[')[1]
                                                        .split(']')[0]
                                                    : "null",
                                                style: TextStyle(
                                                    fontFamily: 'GoogleSans',
                                                    fontSize: 20)),
                                            leading: Icon(
                                              Icons.code,
                                              color: AppColors.COLOR_TEAL_LIGHT,
                                            ),
                                          ),
                                          Divider(),
                                          ListTile(
                                            title: Text("LinkedIn Profile",
                                                style: TextStyle(
                                                    fontFamily: 'GoogleSans',
                                                    fontSize: 18)),
                                            subtitle: GestureDetector(
                                              onTap: () {
                                                if (user["linkedInURL"] !=
                                                        null &&
                                                    user["linkedInURL"]
                                                            .length !=
                                                        0) {
                                                  launch(user["linkedInURL"]);
                                                }
                                              },
                                              child: Text(
                                                user["linkedInURL"] == null ||
                                                        user["linkedInURL"]
                                                                .length ==
                                                            0
                                                    ? " - "
                                                    : user["linkedInURL"],
                                                style: GoogleFonts.lato(
                                                  textStyle:  TextStyle(
                                              fontFamily: 'GoogleSans',
                                              fontSize: 14,
                                              decoration: TextDecoration.underline
                                                  ))
                                              ),
                                            ),
                                            leading: Icon(
                                              Icons.code,
                                              color: AppColors.COLOR_TEAL_LIGHT,
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: ListTile(
                                              title: Text(
                                                "Github Profile",
                                                style: TextStyle(
                                                    fontFamily: 'GoogleSans',
                                                    fontSize: 18),
                                              ),
                                              subtitle: GestureDetector(
                                                onTap: () {
                                                  if (user["githubURL"] !=
                                                          null &&
                                                      user["githubURL"]
                                                              .length !=
                                                          0) {
                                                    launch(user["githubURL"]);
                                                  }
                                                },
                                                child: Text(
                                                    user["githubURL"] == null ||
                                                            user["githubURL"]
                                                                    .length ==
                                                                0
                                                        ? " - "
                                                        : user["githubURL"],
                                                    style: TextStyle(
                                              fontFamily: 'GoogleSans',
                                              fontSize: 14,
                                              decoration: TextDecoration.underline
                                            ))),
                                              leading: Icon(
                                                Icons.code,
                                                color:
                                                    AppColors.COLOR_TEAL_LIGHT,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 25),
                                  ]),
                                ),
                              ),
                            )
                          ],
                        ))))
          ]));
  }
}
