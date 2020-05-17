import 'package:flutter/material.dart';

class MyFeedback extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Feedback"), backgroundColor: Colors.redAccent),
      body: new Center(
        child: Text("Feedback goes here"),
      ),
    );
  }
}