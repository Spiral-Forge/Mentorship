import 'dart:async';
import 'dart:math';
import 'dart:io';

import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/profile/editProfile.dart';
import 'package:dbapp/services/profile.dart';

import 'package:dbapp/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dbapp/services/auth.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:dbapp/screens/myDrawer.dart';

final myDrawer _drawer = new myDrawer();

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  int randomNum = Random().nextInt(4) + 1;

  // String name='';
  // String email='';
  // int year;
  // String branch='';
  // int roll;
  // int contact;
  // String linked;
  // String git;
  // List languages=[];
  // List domains=[];
  // bool hostel=false;
  // bool mentor;
  bool loading = true;
  Map<String, dynamic> user = {};

  getCurrentUser() async {
    return await StorageServices.getUserInfo();
  }

  @override
  void initState() {
    super.initState();
    print("hi");
    print(randomNum);
    //print(user);
    getCurrentUser().then((userinfo) {
      print("printing user");
      print(userinfo);
      setState(() {
        //print(user.runtimeType);
        user = userinfo;
        loading = false;
      });
    });
  }

  File newDP;
  String pathDP;
  bool newDpFlag = false;

  uploadImg() async {}

  // Future<void> retrieveLostData() async {
  //   final LostData response = await ImagePicker().getLostData();
  //   if (response == null) {
  //     return;
  //   }
  //   if (response.file != null) {
  //     setState(() {
  //       if (response.type == RetrieveType.video) {
  //         _handleVideo(response.file);
  //       } else {
  //         _handleImage(response.file);
  //       }
  //     });
  //   } else {
  //     _handleError(response.exception);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //print("user");
    //print(user);

    String hostel = user["hostel"] != null && user["hostel"] == true
        ? "Hosteller: Yes"
        : "Hosteller: No";

    Future uploadImg(context) async {
      var num = Random(25);
      final StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('dp/${num.nextInt(5000).toString()}.jpg');
      final StorageUploadTask uploadTask = firebaseStorageRef.putFile(newDP);

      final ref = FirebaseStorage.instance
          .ref()
          .child('path')
          .child('to')
          .child('the')
          .child('image_filejpg');
      ref.putFile(newDP);
      var url = Uri.parse(await ref.getDownloadURL()).toString();
      pathDP = url;
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      if (mounted) {
        setState(() {
          print("Profile Picture Changed Successfully");
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Profile Picture Changed Successfully',
                  style: TextStyle(
                    fontFamily: 'GoogleSans',
                    fontStyle: FontStyle.italic,
                  ))));
        });
      }

      print("url");
      print(url);
      ProfileService updateUser = new ProfileService();
      await updateUser.updateDP(url);
      print("checkpt34");
      await StorageServices.saveProfileURL(url);
      StorageServices.getUserInfo().then((updatedUser) {
        print("now updated: ");
        print(updatedUser);
        setState(() {
          user = updatedUser;
          newDpFlag = false;
        });
      });
    }

    Future getImage(context) async {
      final PickedFile pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);

      setState(() {
        newDP = File(pickedFile.path);
        newDpFlag = true;
        print("uploaded");
      });
    }

    return new Scaffold(
      appBar: AppBar(
        title: Text("Your Profile",
            style: TextStyle(
              fontFamily: 'GoogleSans',
            )),
        backgroundColor: AppColors.COLOR_TEAL_LIGHT,
        elevation: 0.0,
        actions: <Widget>[],
      ),
      drawer: _drawer,
      // backgroundColor: Hexcolor('#a7d8de'),
      body: Builder(
        builder: (context) => Container(
          child: ListView(shrinkWrap: true, children: <Widget>[
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: ClipPath(
            //     child: Column(
            //       children: <Widget>[
            //         Image.asset(
            //           "assets/images/bg2.jpg",
            //           width: MediaQuery.of(context).size.width,
            //         ),
            //       ],
            //     ),
            //     clipper: GetClipper(),
            //   ),
            // ),
            // Positioned(
            //   width: MediaQuery.of(context).size.width,
            //   top: MediaQuery.of(context).size.height / 4.5,
            //   child:
            SizedBox(
              height: 25,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: newDpFlag
                              ? Image.file(newDP)
                              : user['photoURL'] != null
                                  ? Image.network(user['photoURL'],
                                      fit: BoxFit.fitWidth)
                                  : Image.asset(
                                      "assets/images/avatars/av1.jpg"),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 125, 0, 0),
                    child: IconButton(
                      icon: Icon(Icons.edit, size: 25),
                      onPressed: () async {
                        await getImage(context);
                      },
                    ),
                  ),
                ]),
            Align(
              alignment: Alignment.center,
              child: Text(user["name"] != null ? user["name"] : "null",
                  style: TextStyle(fontFamily: 'GoogleSans', fontSize: 28)),
            ),
            // SizedBox(height: 100),
            Align(
              alignment: Alignment.center,
              child: Text(
                user["post"] != null ? user["post"] : "Null",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'GoogleSans',
                  color: AppColors.PROTEGE_CYAN,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new FloatingActionButton.extended(
                    heroTag: "btn1",
                    backgroundColor: AppColors.PROTEGE_GREY,
                    onPressed: () async {
                      //Navigator.of(context).pop();
                      //  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new EditProfilePage(user)));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage(user)),
                      ).then((value) {
                        StorageServices.getUserInfo().then((value) {
                          print("im here");
                          print(value);
                          setState(() {
                            user = value;
                          });
                        });
                      });
                    },
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    label: Text('Edit Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'GoogleSans',
                        ))),
                new FloatingActionButton.extended(
                    heroTag: "btn2",
                    backgroundColor: AppColors.PROTEGE_GREY,
                    onPressed: () {
                      uploadImg(context);
                    },
                    icon: Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Save DP',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'GoogleSans'),
                    )),
              ],
            ),
            SizedBox(height: 20),

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
                  ListTile(
                    title: Text(
                        user["contact"] != null
                            ? user["contact"].toString()
                            : "null",
                        style:
                            TextStyle(fontFamily: 'GoogleSans', fontSize: 20)),
                    leading: Icon(
                      Icons.phone,
                      color: AppColors.COLOR_TEAL_LIGHT,
                    ),
                  ),
                  ListTile(
                    title: Text(user["email"] == null ? "null" : user["email"],
                        style:
                            TextStyle(fontFamily: 'GoogleSans', fontSize: 20)),
                    leading: Icon(
                      Icons.mail,
                      color: AppColors.COLOR_TEAL_LIGHT,
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                        user["year"] == null
                            ? "null"
                            : user["branch"].toString() +
                                ", " +
                                user["year"] +
                                " year",
                        style:
                            TextStyle(fontFamily: 'GoogleSans', fontSize: 20)),
                    subtitle: Text(
                        user["rollNo"] == null
                            ? "null"
                            : user["rollNo"].toString() +
                                "                                                    " +
                                hostel,
                        style:
                            TextStyle(fontFamily: 'GoogleSans', fontSize: 20)),
                    isThreeLine: true,
                    leading: Icon(
                      Icons.school,
                      color: AppColors.COLOR_TEAL_LIGHT,
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
                  ListTile(
                    title: Text("Languages",
                        style:
                            TextStyle(fontFamily: 'GoogleSans', fontSize: 18)),
                    subtitle: Text(
                        user["languages"] != null
                            ? user["languages"]
                                .toString()
                                .split('[')[1]
                                .split(']')[0]
                            : "null",
                        style:
                            TextStyle(fontFamily: 'GoogleSans', fontSize: 20)),

                    // isThreeLine: true,
                    leading: Icon(
                      Icons.code,
                      color: AppColors.COLOR_TEAL_LIGHT,
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Domains",
                        style:
                            TextStyle(fontFamily: 'GoogleSans', fontSize: 18)),
                    subtitle: Text(
                        user["domains"] != null
                            ? user["domains"]
                                .toString()
                                .split('[')[1]
                                .split(']')[0]
                            : "null",
                        style:
                            TextStyle(fontFamily: 'GoogleSans', fontSize: 20)),
                    // isThreeLine: true,
                    leading: Icon(
                      Icons.code,
                      color: AppColors.COLOR_TEAL_LIGHT,
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("LinkedIn Profile",
                        style:
                            TextStyle(fontFamily: 'GoogleSans', fontSize: 18)),
                    subtitle: Text(
                      user["linkedInURL"]==null || user["linkedInURL"].length == 0
                          ? " - "
                          : user["linkedInURL"],
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          //color: AppColors.PROTEGE_GREY,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    // isThreeLine: true,
                    leading: Icon(
                      Icons.code,
                      color: AppColors.COLOR_TEAL_LIGHT,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Github Profile",
                      style: TextStyle(fontFamily: 'GoogleSans', fontSize: 18),
                    ),
                    subtitle: Text(
                        user["githubURL"]==null || user["githubURL"].length == 0
                            ? " - "
                            : user["githubURL"],
                        style:
                            TextStyle(fontFamily: 'GoogleSans', fontSize: 18)),
                    // isThreeLine: true,
                    leading: Icon(
                      Icons.code,
                      color: AppColors.COLOR_TEAL_LIGHT,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
          ]),
        ),
      ),

      //     Positioned(
      //       width: MediaQuery.of(context).size.width,
      //       top: MediaQuery.of(context).size.height / 10,
      //       // child: Column(
      //       //   children: <Widget>[
      //       //     Center(
      //       //       widthFactor: 150.0,
      //       //       heightFactor: 150.0,
      //       // decoration: BoxDecoration(
      //       //     color: AppColors.PROTEGE_CYAN,
      //       //     image: DecorationImage(
      //       // image: userInfo["avatarNum"]!= null ? AssetImage("assets/images/avatars/av"+userInfo["avatarNum"].toString()+".jpg"):AssetImage("assets/images/avatars/av1.jpg"),
      //       // child: newDP == null
      //       //     ? AssetImage("assets/images/avatars/av1.jpg")
      //       //     : uploadImage(),

      //       // ),
      //       // borderRadius: BorderRadius.all(Radius.circular(175.0)),
      //       // boxShadow: [
      //       //   BoxShadow(
      //       //     blurRadius: 7.0,
      //       //     color: Colors.black,
      //       //   )
      //       // ]),
      //

      //
      //       ),
      //     ),
      //     SizedBox(height: 5),
      //     FloatingActionButton.extended(
      //         backgroundColor: Color.fromRGBO(0, 128, 128, 0.5),
      //         onPressed: () async {
      //           //Navigator.of(context).pop();
      //           //  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new EditProfilePage(user)));
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => EditProfilePage(user)),
      //           ).then((value) {
      //             StorageServices.getUserInfo().then((value) {
      //               print(value);
      //               setState(() {
      //                 user = value;
      //               });
      //             });
      //           });
      //         },
      //         icon: Icon(
      //           Icons.person,
      //           color: Colors.white,
      //         ),
      //         label: Text(
      //           'Edit Profile',
      //           style: TextStyle(color: Colors.white),
      //         )),

      // Container(
      //   height: 30,
      //   width: 95,
      //   child: Material(
      //     borderRadius: BorderRadius.circular(25),
      //     shadowColor: Colors.blueGrey[200],
      //     elevation: 7.0,
      //     child: GestureDetector(
      //       onTap: () => EditProfilePage,
      //       child: Center(
      //         child: Text(
      //           'Edit Info',
      //           style: GoogleFonts.lato(
      //             textStyle: TextStyle(
      //               color: AppColors.COLOR_TEAL_LIGHT,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

class GetClipper extends CustomClipper<Path> {
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
