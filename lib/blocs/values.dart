import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dbapp/services/storage.dart';
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  accentColor: Colors.white,
  dividerColor: Colors.black,
);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  accentColor: Colors.black,
  dividerColor: Colors.white54,
);


class ThemeNotifier extends ChangeNotifier{
  final String key="theme";
  bool _darktheme;
  SharedPreferences prefs;
  bool get darkTheme=>_darktheme;

  ThemeNotifier(){
    _darktheme=false;
    _loadFromPrefs();
  }
  toggleTheme(){
    // print("this is getting called");
    // print(_darktheme);
    _darktheme=!_darktheme;
    _saveToPrefs();
    // print("now dark?");
    // print(_darktheme);
    notifyListeners();
  }
  // _initPrefs() async{
  //    if(prefs==null){
  //      prefs=await SharedPreferences.getInstance();
  //    }
  //  }

  _loadFromPrefs() async{
    //await _initPrefs();
    var val=await StorageServices.getDarkMode();
    print("val is "+val.toString());
    _darktheme=val!=null ? val:false;
    notifyListeners();
  }

  _saveToPrefs() async{
    //await _initPrefs();
    //prefs.setBool(key, _darktheme);
    print("coming inside func");
    await StorageServices.saveDarkMode(_darktheme);
    //print("val is ")
  }


}