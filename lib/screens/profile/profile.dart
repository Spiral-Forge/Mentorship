import 'dart:async';
import 'dart:io';

import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/profile/editProfile.dart';
import 'package:dbapp/services/profile.dart';

import 'package:dbapp/services/storage.dart';
import 'package:dbapp/shared/clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool loading = true;
  Map<String, dynamic> user = {};

  getCurrentUser() async {
    return await StorageServices.getUserInfo();
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser().then((userinfo) {
      setState(() {
        user = userinfo;
        loading = false;
      });
    });
  }

  File newDP;
  String pathDP;
  bool newDpFlag = false;
  bool inprocess = false;

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    String hostel = user["hosteller"] != null && user["hosteller"] == true
        ? "Hosteller: Yes"
        : "Hosteller: No";

    Future uploadImg(context) async {
      String fileName = basename(newDP.path);
      final StorageReference ref =
          FirebaseStorage.instance.ref().child(fileName);
      final StorageUploadTask uploadTask = ref.putFile(newDP);

      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      if (mounted) {
        setState(() {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Profile Picture Changed Successfully',
                style: TextStyle(
                  fontFamily: 'GoogleSans',
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                )),
          ));
        });
      }
      var url = Uri.parse(await ref.getDownloadURL()).toString();
      pathDP = url;
      ProfileService updateUser = new ProfileService();
      await updateUser.updateDP(url);
      await StorageServices.saveProfileURL(url);
      StorageServices.getUserInfo().then((updatedUser) {
        setState(() {
          user = updatedUser;
          newDpFlag = false;
        });
      });
    }

    Future getImage(context) async {
      this.setState(() {
        inprocess = true;
      });

      final PickedFile pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File resized = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 150,
          maxWidth: 150,
          compressFormat: ImageCompressFormat.jpg,
        );
        if (resized != null) {
          this.setState(() {
            newDP = resized;
            newDpFlag = true;
            inprocess = false;
            uploadImg(context);
          });
        } else {
          this.setState(() {
            inprocess = false;
          });
        }
      } else {
        this.setState(() {
          inprocess = false;
        });
      }
    }

    return new Scaffold(
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
                        child: Row(children: <Widget>[
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
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text("Your Profile",
                                style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 27)),
                          ),
                        ]),
                      ),
                      Expanded(
                        child: Builder(
                          builder: (context) => Container(
                            child:
                                ListView(shrinkWrap: true, children: <Widget>[
                              Stack(children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: ClipPath(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                Positioned(
                                  width: MediaQuery.of(context).size.width,
                                  top: MediaQuery.of(context).size.height / 20,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Align(
                                          heightFactor: 1.5,
                                          alignment: Alignment.center,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            radius: 64,
                                            backgroundImage: newDpFlag
                                                ? Image.file(newDP)
                                                : user['photoURL'] != null
                                                    ? Image.network(
                                                        user['photoURL'])
                                                    : AssetImage(
                                                        "assets/images/avatars/av1.png"),
                                          ),
                                        ),
                                      ]),
                                ),
                                Positioned(
                                    top: MediaQuery.of(context).size.height /
                                        4.12,
                                    left: MediaQuery.of(context).size.width /
                                        2.15,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 28,
                                          width: 28,
                                          decoration: BoxDecoration(
                                              color: AppColors.PROTEGE_GREY,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                            alignment: Alignment.center,
                                            onPressed: () async {
                                              await getImage(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.29,
                                ),
                              ]),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                    user["name"] != null
                                        ? user["name"]
                                        : "null",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Quicksand',
                                        fontSize: 27)),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  user["post"] != null ? user["post"] : "Null",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Quicksand',
                                    color: AppColors.COLOR_TURQUOISE,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Card(
                                    elevation: 10,
                                    shadowColor: themeFlag ? null : Colors.grey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 8),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              user["contact"] != null
                                                  ? user["contact"].toString()
                                                  : "null",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
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
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                                user["email"] == null
                                                    ? "null"
                                                    : user["email"],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Quicksand',
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
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                                user["year"] == null
                                                    ? "null"
                                                    : user["branch"]
                                                            .toString() +
                                                        ", " +
                                                        user["year"] +
                                                        " year",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Quicksand',
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
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Quicksand',
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
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Card(
                                    elevation: 10,
                                    shadowColor: themeFlag ? null : Colors.grey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                            title: Text("Languages",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Quicksand',
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
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Quicksand',
                                                    fontSize: 10)),
                                            leading: Icon(
                                              ModernPictograms.globe,
                                              size: 21,
                                            ),
                                          ),
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                            title: Text("Domains",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Quicksand',
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
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Quicksand',
                                                    fontSize: 10)),
                                            leading: Icon(
                                              Icons.code,
                                              size: 21,
                                            ),
                                          ),
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                            title: Text("LinkedIn Profile",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Quicksand',
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
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Quicksand',
                                                      fontSize: 10,
                                                      decoration: TextDecoration
                                                          .underline),
                                                ),
                                              ),
                                            ),
                                            leading: Icon(
                                              MfgLabs.linkedin,
                                              size: 21,
                                            ),
                                          ),
                                          ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              "Github Profile",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Quicksand',
                                                  fontSize: 15,
                                                  color: themeFlag
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                            subtitle: GestureDetector(
                                              onTap: () {
                                                if (user["githubURL"] != null &&
                                                    user["githubURL"].length !=
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
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Quicksand',
                                                    fontSize: 10,
                                                    decoration: TextDecoration
                                                        .underline),
                                              ),
                                            ),
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
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 140,
                                      height: 34,
                                      child: new FlatButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          color: themeFlag
                                              ? AppColors.COLOR_TURQUOISE
                                              : Color(0xff4B7191),
                                          onPressed: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfilePage(user)),
                                            ).then((value) {
                                              StorageServices.getUserInfo()
                                                  .then((value) {
                                                setState(() {
                                                  user = value;
                                                });
                                              });
                                            });
                                          },
                                          child: Text('Edit Profile',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                fontFamily: 'Quicksand',
                                                fontSize: 15,
                                              ))),
                                    ),
                                  ]),
                              SizedBox(height: 20),
                            ]),
                          ),
                        ),
                      )
                    ],
                  ))))
    ]));
  }
}
