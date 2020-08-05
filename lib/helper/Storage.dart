import 'package:shared_preferences/shared_preferences.dart';

class StorageHelperFunctions{
  static String sharedPreferenceUserLoggedInKey="ISLOGGEDIN";
  static String sharedPreferenceUserNameKey="USERNAMEKEY";
  static String sharedPreferenceUserID="USERIDKEY";
  static String sharedPreferenceUserEmail="USEREMAILKEY";

  //clearing data
  static Future<void> clearData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
  //SAVING DATA TO SHARED PREFERENCE
  static Future<void> saveUserLoggedIn(bool isUserLoggedIn) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserName(String name) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, name);
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
  static Future<bool> getUserLoggedIn() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserName() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserNameKey);
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