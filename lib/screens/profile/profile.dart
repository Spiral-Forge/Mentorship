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
  // var _darkTheme = true;
  // Random random = new ;
  int randomNum = Random().nextInt(4) + 1;

  // final AuthService auth = AuthService();
  // final FirebaseAuth authUser = FirebaseAuth.instance;
  // Future<FirebaseUser> getCurrentUser(){
  //   return _authUser.currentUser();
  // }

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
    // getCurrentUser().then((user){
    //     ProfileService()
    //   .getUserProfile(user.uid)
    //   .then((docs){
    //     print(docs);
    //     if(docs.exists){
    //       print(docs.data["email"]);
    //       setState(() {
    //           name=docs.data["name"];
    //           email=docs.data["email"];
    //           year=docs.data["year"];
    //           roll=docs.data["rollNo"];
    //           contact=docs.data["contact"];
    //           git=docs.data['githubURL'];
    //           linked=docs.data['linkedInURL'];
    //           languages=docs.data['languages'];
    //           domains=docs.data['domains'];
    //           hostel=docs.data['hosteller'];
    //           mentor=docs.data['post'] == 'Mentor';
    //           loading=false;
    //       });
    //      }else{
    //        print("coming here");
    //      }
    //     //else{
    //     ProfileService().getMentorProfile(user.uid)
    //     .then((DocumentSnapshot docs){
    //       if(docs.exists){
    //         print(docs.data["year"]);
    //         setState(() {
    //             name=docs.data["name"];
    //             email=docs.data["email"];
    //             year=docs.data["year"];
    //             roll=docs.data["rollNo"];
    //             git=docs.data['githubURL'];
    //             linked=docs.data['linkedInURL'];
    //             contact=docs.data["contact"];
    //             languages=docs.data['languages'];
    //             domains=docs.data['domains'];
    //             hostel=docs.data['hosteller'];
    //             mentor=true;
    //             loading=false;
    //         });
    //       }
    //     });
    // }
    // });
    //});
  }

  File newDP;
  String pathDP;

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
    // ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    // // final _themeChanger = Provider.of<ThemeChanger>(context);
    // _darkTheme = (_themeChanger.getTheme() == darkTheme);
    String hostel = user["hostel"] != null && user["hostel"] == true
        ? "Hosteller: Yes"
        : "Hosteller: No";

    Future getImage() async {
      final PickedFile pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      // final String pickedPath = getApplicationDocumentsDirectory().path;
      // final PickedFile tempImg = await pickedFile.copy('$pickedPath/userDP.png');
      setState(() {
        newDP = File(pickedFile.path);
        print("uploaded");
        // newDP = tempImg;
      });
    }

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
      setState(() {
        print("Profile Picture Changed Successfully");
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Profile Picture Changed Successfully')));
      });
      print("url");
      print(url);
      ProfileService updateUser = new ProfileService();
      updateUser.updateDP(url);
      print("checkpt34");
      StorageServices.saveProfileURL(url);
      var userInfo = StorageServices.getUserInfo();
      userInfo.then((updatedUser) {
        print("now updated: ");
        print(updatedUser);
        setState(() {
          user = updatedUser;
        });
      });
    }

    return new Scaffold(
      appBar: AppBar(
        title: Text("Your Profile"),
        backgroundColor: AppColors.COLOR_TEAL_LIGHT,
        elevation: 0.0,
        actions: <Widget>[],
      ),
      drawer: _drawer,
      body: Builder(
        builder: (context) => Container(
          child: ListView(shrinkWrap: true,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                  height: 15,
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
                              child: user['photoURL'] != null
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
                          onPressed: () {
                            getImage();
                          },
                        ),
                      ),
                    ]),
                // ),
                // SizedBox(height: 35),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    user["name"] != null ? user["name"] : "null",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        // color: AppColors.PROTEGE_GREY,
                        // fontFamily: GoogleFonts,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 100),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    user["post"] != null ? user["post"] : "Null",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: AppColors.PROTEGE_CYAN,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new FloatingActionButton.extended(
                        heroTag: "btn1",
                        backgroundColor: Color.fromRGBO(0, 128, 128, 1),
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
                        label: Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.white),
                        )),
                    new FloatingActionButton.extended(
                        heroTag: "btn2",
                        backgroundColor: Color.fromRGBO(0, 128, 128, 1),
                        onPressed: () {
                          setState(() {
                            uploadImg(context);
                          });
                        },
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Save DP',
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
                SizedBox(height: 10),

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
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          user["contact"] != null
                              ? user["contact"].toString()
                              : "null",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              // color: AppColors.PROTEGE_GREY,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        leading: Icon(
                          Icons.phone,
                          color: Colors.teal[500],
                        ),
                      ),
                      ListTile(
                        title: Text(
                          user["email"] == null ? "null" : user["email"],
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              //color: AppColors.PROTEGE_GREY,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        leading: Icon(
                          Icons.mail,
                          color: Colors.teal[500],
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          user["year"] == null
                              ? "null"
                              : user["branch"].toString() + ", " + user["year"],
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              // color: AppColors.PROTEGE_GREY,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          user["rollNo"] == null
                              ? "null"
                              : user["rollNo"].toString() +
                                  "                                                    " +
                                  hostel,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              // color: AppColors.PROTEGE_GREY,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        isThreeLine: true,
                        leading: Icon(
                          Icons.school,
                          color: Colors.teal[500],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 15),

                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Languages"),
                        subtitle: Text(
                          user["languages"] != null
                              ? user["languages"].toString()
                              : "null",
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
                          color: Colors.teal[500],
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text("Domains"),
                        subtitle: Text(
                          user["domains"] != null
                              ? user["domains"].toString()
                              : "null",
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
                          color: Colors.teal[500],
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text("LinkedIN"),
                        subtitle: Text(
                          user["linkedInURL"].length == 0
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
                          color: Colors.teal[500],
                        ),
                      ),
                      ListTile(
                        title: Text("Github"),
                        subtitle: Text(
                          user["githubURL"].length == 0
                              ? " - "
                              : user["githubURL"],
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
                          color: Colors.teal[500],
                        ),
                      ),
                    ],
                  ),
                )
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
