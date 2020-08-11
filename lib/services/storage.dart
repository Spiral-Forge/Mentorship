import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageServices{
  static String sharedPreferenceUserInfoKey="USERDATA";
  static String sharedPreferenceUserNameKey="USERNAMEKEY";
  static String sharedPreferenceUserID="USERIDKEY";
  static String sharedPreferenceUserEmail="USEREMAILKEY";
  static String sharedPreferncePostKey="USERPOST";

  //clearing data
  static Future<void> clearData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
  //SAVING DATA TO SHARED PREFERENCE
  // static Future<void> saveUserInfo(List<String> userList) async{
  //   SharedPreferences preferences=await SharedPreferences.getInstance();
  //   preferences.setStringList(sharedPreferenceUserInfoKey, userList);
  // }

  static Future<bool> saveUserInfo(Map<String,dynamic> userMap) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setString(sharedPreferncePostKey, userMap["post"]);
    print('Imprinting');
    print(userMap);
    
    var rv = await prefs.setString(sharedPreferenceUserInfoKey, json.encode(userMap));
    print(rv);
    return rv;

  }

  static Future<bool> saveUserEmail(String email) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmail, email);
  }

  static Future<bool> saveUserID(String id) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserID, id);
  }

  //GETTING DATA
  static Future<String> getUserPost() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferncePostKey);
  }
  // static Future<List<String>> getUserInfo() async{
  //   SharedPreferences prefs=await SharedPreferences.getInstance();
  //   List<String> rv=await prefs.getStringList(sharedPreferenceUserInfoKey);
  //   //print(rv);
  //   return rv;
  // }

  static Future<Map<String,dynamic>> getUserInfo() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    String user=await prefs.getString(sharedPreferenceUserInfoKey);
    Map<String,dynamic> userinfo=json.decode(user);
    return userinfo;
  }

  static Future<String> getUserEmail() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserEmail);
  }

  static Future<String> getUserID() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserID);
  }

}