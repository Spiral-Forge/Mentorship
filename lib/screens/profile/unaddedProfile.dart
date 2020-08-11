import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UnaddedProfile extends StatelessWidget {
  final String post;
  UnaddedProfile(this.post);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text(post=="Mentor"?"Your Mentee": "Your Mentor"), backgroundColor: Colors.teal[300]),
      body: Column(
        children: <Widget>[
          Center(
            child: Center(
              child: Container(
                width: 5000.0,
                height: 400.0,
                decoration: new BoxDecoration(
                //shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new AssetImage('assets/images/wait_for_it.png')
                  )
              )),
            ),
          ),
          Text("WAIT FOR IT...",style:GoogleFonts.lato(
                    textStyle: TextStyle(
                     // color: Hexcolor('#565656'),
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),
            )
          )
        ],
      )
    );
  }
}