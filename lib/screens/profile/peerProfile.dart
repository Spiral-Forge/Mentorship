import 'dart:math';

import 'package:dbapp/screens/profile/unaddedProfile.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class PeerProfile extends StatefulWidget {
  final String post;
  final String peerID;
  //=["6qJheR9NT9djQiA7pkG9vS4hyE63"];
  PeerProfile(this.post,this.peerID);
  @override
  _PeerProfileState createState() => _PeerProfileState();
}

class _PeerProfileState extends State<PeerProfile> {
  Map<String,dynamic> user;
  bool loading=true;
  int avatorNum=Random().nextInt(4)+1;
  bool isPeerAdded;

  void initState(){
    if(widget.peerID==null){
      setState(() {
        isPeerAdded=false;
      });
    }else{
      DataBaseService().getPeerData(widget.peerID).then((userinfo){
        // print("coming here");
        // print(userinfo.data);
          setState(() {
            //print(user.runtimeType);
            user=userinfo.data;
            loading=false;
            isPeerAdded=true;
          });
          super.initState();
        });
    }

  }
  @override
  Widget build(BuildContext context) {
    return isPeerAdded==false ? UnaddedProfile(widget.post) : loading ?  Loading() : Scaffold(
      appBar: new AppBar(title: new Text(widget.post=="Mentor"?"Your Mentee": "Your Mentor"), backgroundColor: Colors.teal[300]),
      body:Stack(
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
                  decoration: BoxDecoration(
                    color: Hexcolor('#96ece7'),
                    image: DecorationImage(
                      image: AssetImage("assets/images/avatars/av"+avatorNum.toString()+".jpg"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(175.0)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7.0,
                        color: Colors.black,
                      )
                    ]
                  ),
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
                
              ],
            ) 
          )
          
        ],        
      )
      
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