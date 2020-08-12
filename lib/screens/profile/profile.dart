import 'package:dbapp/screens/authenticate/authenticate.dart';
import 'package:dbapp/services/profile.dart';
import 'package:dbapp/screens/profile/editProfile.dart';

import 'package:dbapp/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dbapp/services/auth.dart';

import 'package:provider/provider.dart';
import 'package:dbapp/blocs/theme.dart';
import 'package:dbapp/blocs/values.dart';

import 'package:dbapp/screens/home/homepage.dart';
import 'package:dbapp/screens/sidebarScreens/about.dart';
import 'package:dbapp/screens/sidebarScreens/faqs.dart';
import 'package:dbapp/screens/sidebarScreens/feedback.dart';
import 'package:dbapp/screens/sidebarScreens/guidelines.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dbapp/shared/loading.dart';

import 'dart:math';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {

  var _darkTheme = true;
  // Random random = new ;
  int randomNum= Random().nextInt(4)+1;
  
  final AuthService _auth=AuthService();
  final FirebaseAuth _authUser = FirebaseAuth.instance;
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
  bool loading=true;
  Map<String,dynamic> user={};

  getCurrentUser() async{
    return await StorageServices.getUserInfo();
  }

  @override
  void initState(){
    super.initState();
    print("hi");
    print(randomNum);
    //print(user);
    getCurrentUser().then((userinfo){
      print("printing user");
      print(userinfo);
      setState(() {
        //print(user.runtimeType);
        user=userinfo;
        loading=false;
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
  @override
  Widget build(BuildContext context) {
    //print("user");
  //print(user);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    // final _themeChanger = Provider.of<ThemeChanger>(context);
    _darkTheme = (_themeChanger.getTheme() == darkTheme);

    return new Scaffold(
      appBar: AppBar(
        title:Text("Your Profile"),
        backgroundColor:Colors.teal[300] ,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async{
              //Navigator.of(context).pop();
            //  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new EditProfilePage(user)));
            Navigator.push( context, MaterialPageRoute( builder: (context) => EditProfilePage(user)), ).then((value){
              print("coming here");
              StorageServices.getUserInfo().then((value){
                print(value);
                setState(() {
                  user=value;
                });
              });
              print("now working");
            } );
            }, 
            icon: Icon(Icons.person,color: Colors.white,),
            label:Text('Edit Profile',style: TextStyle(color:Colors.white),)
            )
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new ListTile(
              title: new Text("Code of Conduct"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Guidelines()));
              }
            ),
            new ListTile(
              title: new Text("About"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new About()));
              }
            ),
            new ListTile(
              title: new Text("FAQs"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new FAQS()));
              }
            ),
            
            new ListTile(
              title: new Text("Contact us and feedback"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MyFeedback()));
              }
            ),
             
            new Divider(),
            new ListTile(
              trailing: Transform.scale(
                scale: 1.4,
                child: Switch(
                  value: _darkTheme,
                  onChanged: (val) {
                    setState(() {
                      _darkTheme = val;
                    });
                    onThemeChanged(val, _themeChanger);
                  },
                ),
              ),
              // leading: new IconButton(
              //             onPressed: () => _themeChanger.setTheme(Theme.dark()),
              //             icon: Icon(
              //               Icons.brightness_3
              //             ),
              //             color: Hexcolor('#565656'),
              //           ),
              // title: new Text("Change Theme"),
              // onTap: () {
              //   Navigator.of(context).pop();
              //   Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ThemeChanger(ThemeData.dark())));
              // }
            ),           
            new Divider(),
            new ListTile(
              title: new Text("Logout"),
              trailing: new Icon(Icons.people),
              onTap: () async {
                await _auth.signOut();
              }
            ),
          ],
        ),
      ),
      body:  new Stack(
        children: <Widget>[
          
          ClipPath(
            child: 
            // Container(
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage(
            //         "assets/images/bg2.jpg",
            //       ),    
            //     ),
            //   ),
            //   color: Hexcolor('#565656'),
            // ),
            Column(
              children: <Widget>[
                Image.asset(
                  "assets/images/bg2.jpg",
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),

            clipper: getClipper(),
          ),
          Positioned(
            
            width: MediaQuery.of(context).size.width ,
            top: MediaQuery.of(context).size.height / 9,
            child: Column(
              children: <Widget>[
                
                Container(
                  width: 150.0,
                  height: 150.0,
                  // decoration: BoxDecoration(
                  //   color: Hexcolor('#96ece7'),
                  //   image: DecorationImage(
                  //     image: AssetImage("assets/images/avatars/av"+user["avatarNum"].toString()+".jpg"),
                  //     fit: BoxFit.cover,
                  //   ),
                  //   borderRadius: BorderRadius.all(Radius.circular(175.0)),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       blurRadius: 7.0,
                  //       color: Colors.black,
                  //     )
                  //   ]
                  // ),
                ),
                SizedBox( height: 35),
                Text(
                  user["name"] != null ? user["name"] : "null",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      // color: Hexcolor('#565656'),
                      // fontFamily: GoogleFonts,
                      fontSize: 28,
                    ),
                  ),
                ),
                SizedBox( height: 8),
                Text(
                  user["post"]!=null ? user["post"] : "Null",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Hexcolor('#96ece7'),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                SizedBox( height: 15),
                Text(
                  user["email"]==null? "null" : user["email"],
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      //color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),
                
                SizedBox( height: 10),
                Text(
                  user["contact"] != null ? user["contact"].toString(): "null",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                     // color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 10),
                Text(
                  user["year"] == null ? "null" : user["year"].toString()+" "+user["branch"],
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                     // color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 10),
                Text(
                  user["roll"]==null ? "null" : user["roll"].toString(),
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      // color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 10),
                Text(
                  user["linkedInURL"]==null ? "null" : user["linkedInURL"],
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      //color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 10),
                Text(
                  user["githubURL"] ==null? "null" : user["githubURL"],
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      //color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 10),
                Text(
                  user["languages"] != null ? "Languages: "+user["languages"].toString() : "null",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      //color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox( height: 10),
                Text(
                  user["domains"] !=null ? "Domains: "+user["domains"].toString() : "null",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      //color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 10),
                Text(
                  user["hostel"]!=null && user["hostel"]==true? "Hosteller: Yes" : "Hosteller: No",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      //color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  width: 95,
                  child: Material(
                    borderRadius: BorderRadius.circular(25),
                    shadowColor: Colors.blueGrey[200],
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () => EditProfilePage,
                      child: Center(
                        child: Text(
                          'Edit Info',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Colors.teal[300],
                            ),
                          ),
                        ),
                      ),
                      
                    ),
                  ),
                ),
                SizedBox( height: 25),
                
              ],
            ) 
          )
          
        ],        
      ),
    );
  }
}

class getClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    var path = new Path();
    path.lineTo(0.0, size.height/3.3);
    path.lineTo(size.width + 500, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return true;
  }
}

void onThemeChanged(bool value, ThemeChanger _themeChanger) async {
  (value) ? _themeChanger.setTheme(darkTheme) : _themeChanger.setTheme(lightTheme);
    // var prefs = await SharedPreferences.getInstance();
    // prefs.setBool('darkMode', value);
}

