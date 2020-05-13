import 'package:flutter/material.dart';
import 'package:dbapp/models/userData.dart';
import 'package:provider/provider.dart';

class Dbdata extends StatefulWidget {
  @override
  _DbdataState createState() => _DbdataState();
}

class _DbdataState extends State<Dbdata> {
  @override
  Widget build(BuildContext context) {
    final list=Provider.of<List<UserData>>(context);
    //print(list.documents);
    list.forEach((user){
      print(user.name);
      print(user.year);
    });
    return Container(
      child:Text("hi")
    );
  }
}