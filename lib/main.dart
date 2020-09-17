import 'package:dbapp/screens/wrapper.dart';
import 'package:dbapp/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'blocs/values.dart';


void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
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
  }
}
    



