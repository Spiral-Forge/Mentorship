import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context,String title){
  return AppBar(
    title: Text(title)
  );
}

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
     hintText:hintText,
      hintStyle: TextStyle(
        color:Colors.black,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color:Colors.black)
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color:Colors.black)
               )
  );
}

TextStyle simpleTextFieldStyle(){
  return TextStyle(
    color:Colors.black,
    fontSize:20
  );
}

