import 'package:chatApp/helper/authenticate.dart';
import 'package:chatApp/helper/Storage.dart';
//import 'package:chatApp/views/chatRoomScreen.dart';
import 'package:chatApp/views/bottomNavigationScreen.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn;

  @override
  void initState(){
    super.initState();
    StorageHelperFunctions.clearData();
    print("cleared everything");
    getLoggedInState();
  }

  getLoggedInState() async{
    await StorageHelperFunctions.getUserLoggedIn().then((val){
        setState(() {
          isLoggedIn=val;
        });
    });
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:"Flutter Demo",
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        primarySwatch:Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity 
      ),
      home:isLoggedIn==null||false ? Authenticate() : BottomNavigationScreen()
    );
  }
}

// class BlankWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//     );
//   }
// }