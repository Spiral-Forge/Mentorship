import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  static String sharedPreferenceUserInfoKey = "USERDATA";
  static String sharedPreferenceUserID = "USERIDKEY";
  static String sharedPreferncePostKey = "USERPOST";
  static String sharedPrefernceDarkModeKey = "DARKMODE";

  //clearing data
  static Future<void> clearData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
  //SAVING DATA TO SHARED PREFERENCE

  static Future<bool> saveUserInfo(Map<String, dynamic> userMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(sharedPreferncePostKey, userMap["post"]);
    return await prefs.setString(
        sharedPreferenceUserInfoKey, json.encode(userMap));
  }
  static Future<bool> saveDarkMode(bool darkMode) async {
    print("coming inside storage stuff");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPrefernceDarkModeKey,darkMode);

  }
  

  static Future<bool> saveUserID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserID, id);
  }

  static Future<bool> saveProfileURL(String url) async {
    await print("im here");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var obj = await prefs.getString(sharedPreferenceUserInfoKey);
    print(obj);
    var parsedObj = json.decode(obj);
    parsedObj['photoURL'] = url;
    return await prefs.setString(sharedPreferenceUserInfoKey, json.encode(parsedObj));
  }

  //GETTING DATA
  static Future<String> getUserPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferncePostKey);
  }
  static Future<bool> getDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPrefernceDarkModeKey);
  }

  static Future<Map<String, dynamic>> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = await prefs.getString(sharedPreferenceUserInfoKey);
    Map<String, dynamic> userinfo = json.decode(user);
    return userinfo;
  }
}
