import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;
  SharedPreferences prefs;

  ThemeChanger(this._themeData);

  getTheme() => _themeData;
  setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
  //  _initPrefs() async{
  //    if(prefs==null){
  //      prefs=await SharedPreferences.getInstance();
  //    }
  //  }

  // _loadFromPrefs() async{
  //   await _initPrefs
  // }
}