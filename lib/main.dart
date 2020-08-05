import 'package:chatApp/helper/authenticate.dart';
import 'package:chatApp/helper/Storage.dart';
//import 'package:chatApp/views/chatRoomScreen.dart';
import 'package:chatApp/views/bottomNavigationScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'blocs/theme.dart';
void main() => runApp(
  ChangeNotifierProvider<ThemeChanger>(
    create: (_) => ThemeChanger(ThemeData.light()),
    child: MyApp(),
  )
);
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  bool isLoggedIn;

  @override
  void initState(){
    super.initState();
    //StorageHelperFunctions.clearData();
    //print("cleared everything");
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
    final _themeChanger = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      title:"Protege",
      debugShowCheckedModeBanner: false,
      theme: _themeChanger.getTheme(),
      // ThemeData(
      //   primarySwatch:Colors.blue,
      //   visualDensity: VisualDensity.adaptivePlatformDensity 
      // ),
      home:isLoggedIn==null||false ? Authenticate() : BottomNavigationScreen()
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      //home: HomePage(),
      theme: theme.getTheme(),
    );
  }
}