import 'package:dbapp/screens/wrapper.dart';
import 'package:dbapp/services/auth.dart';
import 'package:dbapp/services/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:dbapp/blocs/theme.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:dbapp/models/user.dart';

import 'blocs/values.dart';


void main() {
 
  runApp( MyApp());
  // ChangeNotifierProvider<ThemeChanger>(
  //   create: (_) {
  //     return ThemeChanger(ThemeData.light());
  //   },
  //   child: MyApp(),
  // ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    
  @override
  Widget build(BuildContext context) {
    
    return StreamProvider<FirebaseUser>.value(
      value:AuthService().user,
          child: ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
            child: Consumer<ThemeNotifier>(
              builder: (context, ThemeNotifier notifier, child) {

                return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: notifier.darkTheme ? darkTheme : lightTheme,
                home:Wrapper(),
              );
              } ,
            ),
      ),
    );
        
    // StreamProvider<FirebaseUser>.value(
    //   value:AuthService().user,
    //     child: ChangeNotifierProvider(
    //     create: (_)=>ThemeNotifier(),
    //       child: Consumer<ThemeNotifier>(
    //         builder: (context,ThemeNotifier notifier, child) {
    //            return MaterialApp(
    //           debugShowCheckedModeBanner: false,
    //           theme: notifier.darkTheme ? darkTheme : lightTheme,
    //           home:Wrapper(),
    //       );
    //       }) ,
    //       ),
    // );
  }
}
    



// class MaterialAppWithTheme extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Provider.of<ThemeChanger>(context);
//     return MaterialApp(
//       //home: HomePage(),
//       theme: mytheme,
//     );
//   }
// }

// final ThemeData kIOSTheme = new ThemeData(
//   primarySwatch: Colors.teal,
//   primaryColor: Colors.teal[200],
//   primaryColorBrightness: Brightness.light,
// );

// final ThemeData KDefaultTheme = new ThemeData(
//   primarySwatch: Colors.teal,
//   accentColor: Colors.teal[200],
// );

