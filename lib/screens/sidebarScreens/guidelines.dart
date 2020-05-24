import 'package:flutter/material.dart';

class Guidelines extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Guidelines"), backgroundColor: Colors.redAccent),
      body: Container(
        padding: EdgeInsets.only(top:20.0),
        child: Center(
          child: Column(
            children:<Widget>[
              Text("Heading"),
              SizedBox(height:20.0),
              Text("Guideline 1"),
              SizedBox(height:10.0),
              Text("Guideline 2"),
              SizedBox(height:10.0),
              Text("Guideline 3"),
              SizedBox(height:10.0),
              Text("Guideline 4"),
              SizedBox(height:10.0),
              Text("Guideline 5"),
            ]
          ),
        ),
      )
      // new Center(
      //   child: Text("Code of conduct for mentors and mentees"),
      // ),
    );
  }
}