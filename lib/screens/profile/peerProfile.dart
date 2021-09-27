import 'dart:math';

import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/shared/clipper.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:fluttericon/octicons_icons.dart';

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
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

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
                            Padding(
                              padding: EdgeInsets.fromLTRB(31, 29, 0, 0),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      size: 39,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(21, 0, 0, 0),
                                    child: Text(
                                        widget.post == "Mentee"
                                            ? "Your Mentor"
                                            : "Your Mentee",
                                        style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 27)),
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
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: Image.asset(
                                                    "assets/images/bg2.jpg",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          clipper: GetClipper(),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.27,
                                      ),
                                      Positioned(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        top:
                                            MediaQuery.of(context).size.height /
                                                10.5,
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
                                                  backgroundImage: user[
                                                              'photoURL'] !=
                                                          null
                                                      ? NetworkImage(
                                                          user['photoURL'],
                                                        )
                                                      : AssetImage(
                                                          "assets/images/avatars/av1.png"),
                                                  backgroundColor: Colors.black,
                                                  radius: 64,
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ]),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          user["name"] != null
                                              ? user["name"]
                                              : "null",
                                          style: TextStyle(
                                              fontFamily: 'Quicksand',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 27)),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        user["post"] != null
                                            ? user["post"]
                                            : "Null",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Quicksand',
                                          color: themeFlag
                                              ? AppColors.COLOR_TURQUOISE
                                              : Color(0xff80B9E8),
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 0),
                                    Center(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Card(
                                          elevation: 10,
                                          shadowColor:
                                              themeFlag ? null : Colors.grey,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 8),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title: Text(
                                                    user["contact"] != null
                                                        ? user["contact"]
                                                            .toString()
                                                        : "null",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: 'Quicksand',
                                                        fontSize: 15,
                                                        color: themeFlag
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                  leading: Icon(
                                                    Icons.phone,
                                                    size: 21,
                                                  ),
                                                ),
                                                ListTile(
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title: Text(
                                                      user["email"] == null
                                                          ? "null"
                                                          : user["email"],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'Quicksand',
                                                          fontSize: 15,
                                                          color: themeFlag
                                                              ? Colors.white
                                                              : Colors.black)),
                                                  leading: Icon(
                                                    Icons.mail,
                                                    size: 21,
                                                  ),
                                                ),
                                                ListTile(
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title: Text(
                                                      user["year"] == null
                                                          ? "null"
                                                          : user["branch"]
                                                                  .toString() +
                                                              ", " +
                                                              user["year"] +
                                                              " year",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'Quicksand',
                                                          fontSize: 15,
                                                          color: themeFlag
                                                              ? Colors.white
                                                              : Colors.black)),
                                                  subtitle: Text(
                                                      user["rollNo"] == null
                                                          ? "null"
                                                          : user["rollNo"]
                                                                  .toString() +
                                                              "                                                    " +
                                                              hostel,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'Quicksand',
                                                          fontSize: 10)),
                                                  isThreeLine: true,
                                                  leading: Icon(
                                                    Icons.school,
                                                    size: 21,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Center(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Card(
                                          elevation: 10,
                                          shadowColor:
                                              themeFlag ? null : Colors.grey,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title: Text("Languages",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'Quicksand',
                                                          fontSize: 15,
                                                          color: themeFlag
                                                              ? Colors.white
                                                              : Colors.black)),
                                                  subtitle: Text(
                                                      user["languages"] != null
                                                          ? user["languages"]
                                                              .toString()
                                                              .split('[')[1]
                                                              .split(']')[0]
                                                          : "null",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'Quicksand',
                                                          fontSize: 10)),
                                                  leading: Icon(
                                                    ModernPictograms.globe,
                                                    size: 21,
                                                  ),
                                                ),
                                                ListTile(
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title: Text("Domains",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'Quicksand',
                                                          fontSize: 15,
                                                          color: themeFlag
                                                              ? Colors.white
                                                              : Colors.black)),
                                                  subtitle: Text(
                                                      user["domains"] != null
                                                          ? user["domains"]
                                                              .toString()
                                                              .split('[')[1]
                                                              .split(']')[0]
                                                          : "null",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'Quicksand',
                                                          fontSize: 10)),
                                                  leading: Icon(
                                                    Icons.code,
                                                    size: 21,
                                                  ),
                                                ),
                                                ListTile(
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title: Text(
                                                      "LinkedIn Profile",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              'Quicksand',
                                                          fontSize: 15,
                                                          color: themeFlag
                                                              ? Colors.white
                                                              : Colors.black)),
                                                  subtitle: GestureDetector(
                                                    onTap: () {
                                                      if (user["linkedInURL"] !=
                                                              null &&
                                                          user["linkedInURL"]
                                                                  .length !=
                                                              0) {
                                                        launch(user[
                                                            "linkedInURL"]);
                                                      }
                                                    },
                                                    child: Text(
                                                        user["linkedInURL"] ==
                                                                    null ||
                                                                user[
                                                                            "linkedInURL"]
                                                                        .length ==
                                                                    0
                                                            ? " - "
                                                            : user[
                                                                "linkedInURL"],
                                                        style: GoogleFonts.lato(
                                                            textStyle: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    'Quicksand',
                                                                fontSize: 10,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline))),
                                                  ),
                                                  leading: Icon(
                                                    MfgLabs.linkedin,
                                                    size: 21,
                                                  ),
                                                ),
                                                ListTile(
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  title: Text(
                                                    "Github Profile",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: 'Quicksand',
                                                        fontSize: 15,
                                                        color: themeFlag
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                  subtitle: GestureDetector(
                                                      onTap: () {
                                                        if (user["githubURL"] !=
                                                                null &&
                                                            user["githubURL"]
                                                                    .length !=
                                                                0) {
                                                          launch(user[
                                                              "githubURL"]);
                                                        }
                                                      },
                                                      child: Text(
                                                          user["githubURL"] ==
                                                                      null ||
                                                                  user["githubURL"]
                                                                          .length ==
                                                                      0
                                                              ? " - "
                                                              : user[
                                                                  "githubURL"],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  'Quicksand',
                                                              fontSize: 10,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline))),
                                                  leading: Icon(
                                                    Octicons.mark_github,
                                                    size: 21,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
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
