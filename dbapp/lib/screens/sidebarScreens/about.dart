import 'package:flutter/material.dart';

class About extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("About"), backgroundColor: Colors.redAccent),
      body: new Center(
        child: Text("About the organisation"),
      ),
    );
  }
}