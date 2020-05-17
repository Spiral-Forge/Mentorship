import 'package:flutter/material.dart';

class Guidelines extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Guidelines"), backgroundColor: Colors.redAccent),
      body: new Center(
        child: Text("Code of conduct for mentors and mentees"),
      ),
    );
  }
}