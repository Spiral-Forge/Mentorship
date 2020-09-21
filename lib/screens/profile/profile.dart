import 'dart:async';
import 'dart:io';

import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/profile/editProfile.dart';
import 'package:dbapp/services/profile.dart';

import 'package:dbapp/services/storage.dart';
import 'package:dbapp/shared/clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:image_cropper/image_cropper.dart';
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
                      SizedBox(height: 32),
                      Padding(
                        padding: EdgeInsets.fromLTRB(32, 32, 0, 0),
                        child: Row(children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text("Your Profile",
                                style: TextStyle(
                                    fontFamily: 'GoogleSans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25)),
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
                                        Image.asset(
                                          "assets/images/bg2.jpg",
                                          width:
                                              MediaQuery.of(context).size.width,
                                        ),
                                      ],
                                    ),
                                    clipper: GetClipper(),
                                  ),
                                ),
                                Positioned(
                                  width: MediaQuery.of(context).size.width,
                                  top: MediaQuery.of(context).size.height / 8.3,
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
                                            backgroundColor: Colors.black,
                                            radius: 75,
                                            child: ClipOval(
                                              child: SizedBox(
                                                width: 150,
                                                height: 150,
                                                child: newDpFlag
                                                    ? Image.file(newDP)
                                                    : user['photoURL'] != null
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
                                Positioned(
                                    top: MediaQuery.of(context).size.height /
                                        3.6,
                                    left: MediaQuery.of(context).size.width /
                                        2.15,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              color: AppColors.PROTEGE_GREY,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              size: 12,
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
                              ]),
                              SizedBox(
                                height: 0,
                              ),
                              SizedBox(height: 25),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                    user["name"] != null
                                        ? user["name"]
                                        : "null",
                                    style: TextStyle(
                                        fontFamily: 'GoogleSans',
                                        fontSize: 25)),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  user["post"] != null ? user["post"] : "Null",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'GoogleSans',
                                    color: Hexcolor('#d89279'),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Card(
                                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: ListTile(
                                        title: Text(
                                            user["contact"] != null
                                                ? user["contact"].toString()
                                                : "null",
                                            style: TextStyle(
                                                fontFamily: 'GoogleSans',
                                                fontSize: 18)),
                                        leading: Icon(
                                          Icons.phone,
                                          color: AppColors.COLOR_TEAL_LIGHT,
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
                                              fontSize: 18)),
                                      leading: Icon(
                                        Icons.mail,
                                        color: AppColors.COLOR_TEAL_LIGHT,
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 6.0),
                                      child: ListTile(
                                        title: Text(
                                            user["year"] == null
                                                ? "null"
                                                : user["branch"].toString() +
                                                    ", " +
                                                    user["year"] +
                                                    " year",
                                            style: TextStyle(
                                                fontFamily: 'GoogleSans',
                                                fontSize: 18)),
                                        subtitle: Text(
                                            user["rollNo"] == null
                                                ? "null"
                                                : user["rollNo"].toString() +
                                                    "                                                    " +
                                                    hostel,
                                            style: TextStyle(
                                                fontFamily: 'GoogleSans',
                                                fontSize: 18)),
                                        isThreeLine: true,
                                        leading: Icon(
                                          Icons.school,
                                          color: AppColors.COLOR_TEAL_LIGHT,
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
                                      padding: const EdgeInsets.only(top: 5.0),
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
                                                fontSize: 18)),
                                        leading: Icon(
                                          Icons.code,
                                          color: AppColors.COLOR_TEAL_LIGHT,
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
                                              fontSize: 18)),
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
                                          if (user["linkedInURL"] != null &&
                                              user["linkedInURL"].length != 0) {
                                            launch(user["linkedInURL"]);
                                          }
                                        },
                                        child: Text(
                                          user["linkedInURL"] == null ||
                                                  user["linkedInURL"].length ==
                                                      0
                                              ? " - "
                                              : user["linkedInURL"],
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              fontFamily: 'GoogleSans',
                                              fontSize: 14,
                                              decoration: TextDecoration.underline
                                            ),
                                          ),
                                        ),
                                      ),
                                      leading: Icon(
                                        Icons.code,
                                        color: AppColors.COLOR_TEAL_LIGHT,
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: ListTile(
                                        title: Text(
                                          "Github Profile",
                                          style: TextStyle(
                                              fontFamily: 'GoogleSans',
                                              fontSize: 18),
                                        ),
                                        subtitle: GestureDetector(
                                          onTap: () {
                                            if (user["githubURL"] != null &&
                                                user["githubURL"].length != 0) {
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
                                            ),),
                                        ),
                                        leading: Icon(
                                          Icons.code,
                                          color: AppColors.COLOR_TEAL_LIGHT,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 25),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 40,
                                      child: new FlatButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          color: AppColors.PROTEGE_GREY,
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
                                                color: Colors.white,
                                                fontFamily: 'GoogleSans',
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
