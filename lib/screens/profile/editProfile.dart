import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  Map<String,dynamic> userMap;
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Edit Profile"), backgroundColor: Colors.teal),
      
    );
  }
}