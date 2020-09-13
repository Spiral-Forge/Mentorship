import 'dart:math';

import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/profile/unaddedProfile.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class PeerProfile extends StatefulWidget {
  final String peerID;
  final String post;
  //=["6qJheR9NT9djQiA7pkG9vS4hyE63"];
  PeerProfile(this.post, this.peerID);
  @override
  _PeerProfileState createState() => _PeerProfileState();
}

class _PeerProfileState extends State<PeerProfile> {
  Map<String, dynamic> user = {};
  bool loading = true;
  int avatorNum = Random().nextInt(4) + 1;
  // bool isPeerAdded;

  void initState() {
    // if (widget.peerID == null) {
    //   setState(() {
    //     isPeerAdded = false;
    //   });
    // } else {
    DataBaseService().getPeerData(widget.peerID).then((userinfo) {
      setState(() {
        user = userinfo.data;
        loading = false;
        // isPeerAdded = true;
      });
      super.initState();
    });
    //}
  }

  @override
  Widget build(BuildContext context) {
    String hostel = user["hostel"] != null && user["hostel"] == true
        ? "Hosteller: Yes"
        : "Hosteller: No";
    return loading
        ? Loading()
        : Scaffold(
            // appBar: new AppBar(
            //     title: new Text("profile"),
            //     backgroundColor: AppColors.COLOR_TEAL_LIGHT),
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
                                          clipper: getClipper(),
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
                                                              "assets/images/avatars/av1.jpg"),
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
                                    // SizedBox(height: 100),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        user["post"] != null
                                            ? user["post"]
                                            : "Null",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'GoogleSans',
                                          // color: AppColors.COLOR_TEAL_LIGHT,
                                          color: Hexcolor('#d89279'),
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 25),

                                    // Container(
                                    //   margin: EdgeInsets.fromLTRB(35, 0, 35, 0),
                                    //   child: Row(
                                    //     crossAxisAlignment: CrossAxisAlignment.center,
                                    //     children: <Widget>[
                                    //       Container(
                                    //         margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                    //         child: Icon(
                                    //           Icons.call,
                                    //           size: 20,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),

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
                                                // color: Hexcolor('#d89279'),
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
                                              // color: Hexcolor('#d89279'),
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
                                                // color: Hexcolor('#d89279'),
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

                                              // isThreeLine: true,
                                              leading: Icon(
                                                Icons.code,
                                                color:
                                                    AppColors.COLOR_TEAL_LIGHT,
                                                // color: Hexcolor('#d89279'),
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
                                            // isThreeLine: true,
                                            leading: Icon(
                                              Icons.code,
                                              color: AppColors.COLOR_TEAL_LIGHT,
                                              // color: Hexcolor('#d89279'),
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
                                                  textStyle: TextStyle(
                                                    //color: AppColors.PROTEGE_GREY,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // isThreeLine: true,
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
                                                        fontFamily:
                                                            'GoogleSans',
                                                        fontSize: 18)),
                                              ),
                                              // isThreeLine: true,
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

// Stack(
//   children: <Widget>[

//     Positioned(

//       width: MediaQuery.of(context).size.width ,
//       top: MediaQuery.of(context).size.height / 9,
//       child: Column(
//         children: <Widget>[
//           Container(
//             width: 150.0,
//             height: 150.0,
//             decoration: BoxDecoration(
//               color: AppColors.PROTEGE_CYAN,
//               image: DecorationImage(
//                 image: AssetImage("assets/images/avatars/av"+avatorNum.toString()+".jpg"),
//                 fit: BoxFit.cover,
//               ),
//               borderRadius: BorderRadius.all(Radius.circular(175.0)),
//               boxShadow: [
//                 BoxShadow(
//                   blurRadius: 7.0,
//                   color: Colors.black,
//                 )
//               ]
//             ),
//           ),
//           SizedBox( height: 35),
//           Text(
//             user["name"] != null ? user["name"] : "null",
//             style: GoogleFonts.lato(
//               textStyle: TextStyle(
//                 // color: AppColors.PROTEGE_GREY,
//                 // fontFamily: GoogleFonts,
//                 fontSize: 28,
//               ),
//             ),
//           ),
//           SizedBox( height: 8),
//           Text(
//             user["post"]!=null ? user["post"] : "Null",
//             style: GoogleFonts.lato(
//               textStyle: TextStyle(
//                 fontSize: 20,
//                 color: AppColors.PROTEGE_CYAN,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//           ),

//           SizedBox( height: 15),
//           Text(
//             user["email"]==null? "null" : user["email"],
//             style: GoogleFonts.lato(
//               textStyle: TextStyle(
//                 //color: AppColors.PROTEGE_GREY,
//                 fontSize: 20,
//               ),
//             ),
//           ),

//           SizedBox( height: 10),
//           Text(
//             user["contact"] != null ? user["contact"].toString(): "null",
//             style: GoogleFonts.lato(
//               textStyle: TextStyle(
//                // color: AppColors.PROTEGE_GREY,
//                 fontSize: 20,
//               ),
//             ),
//           ),

//           SizedBox( height: 10),
//           Text(
//             user["year"] == null ? "null" : user["year"].toString()+" "+user["branch"],
//             style: GoogleFonts.lato(
//               textStyle: TextStyle(
//                // color: AppColors.PROTEGE_GREY,
//                 fontSize: 20,
//               ),
//             ),
//           ),

//           SizedBox( height: 10),
//           Text(
//             user["rollNo"]==null ? "null" : user["rollNo"].toString(),
//             style: GoogleFonts.lato(
//               textStyle: TextStyle(
//                 // color: AppColors.PROTEGE_GREY,
//                 fontSize: 20,
//               ),
//             ),
//           ),

//           SizedBox( height: 10),
//           Text(
//             user["linkedInURL"]==null ? "Not added yet" : user["linkedInURL"],
//             style: GoogleFonts.lato(
//               textStyle: TextStyle(
//                 //color: AppColors.PROTEGE_GREY,
//                 fontSize: 20,
//               ),
//             ),
//           ),

//           SizedBox( height: 10),
//           Text(
//             user["githubURL"] ==null? "Not added yet" : user["githubURL"],
//             style: GoogleFonts.lato(
//               textStyle: TextStyle(
//                 //color: AppColors.PROTEGE_GREY,
//                 fontSize: 20,
//               ),
//             ),
//           ),

//           SizedBox( height: 10),
//           Text(
//             user["languages"] != null ? "Languages: "+user["languages"].toString() : "null",
//             style: GoogleFonts.lato(
//               textStyle: TextStyle(
//                 //color: AppColors.PROTEGE_GREY,
//                 fontSize: 20,
//               ),
//             ),
//           ),
//           SizedBox( height: 10),
//           Text(
//             user["domains"] !=null ? "Domains: "+user["domains"].toString() : "null",
//             style: GoogleFonts.lato(
//               textStyle: TextStyle(
//                 //color: AppColors.PROTEGE_GREY,
//                 fontSize: 20,
//               ),
//             ),
//           ),

//           SizedBox( height: 10),
//           Text(
//             user["hostel"]!=null && user["hostel"]==true? "Hosteller: Yes" : "Hosteller: No",
//             style: GoogleFonts.lato(
//               textStyle: TextStyle(
//                 //color: AppColors.PROTEGE_GREY,
//                 fontSize: 20,
//               ),
//             ),
//           ),

//         ],
//       )
//     )

//   ],
// )

//               );
//   }
// }

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height / 1.2);
    path.lineTo(size.width + 500, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
