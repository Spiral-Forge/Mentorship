import 'dart:math';
import 'package:dbapp/services/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dbapp/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /*auth change using stream*/
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  Future signin(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser user = result.user;
      DataBaseService(uid: user.uid).getUserData().then((userdata) async {
        Map<String, dynamic> userMap = userdata.data;
        userMap["id"]=userdata.documentID;
        await StorageServices.saveUserInfo(userMap);
        return user;
      });
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future register(
      String name,
      String phoneNo,
      String email,
      String password,
      String year,
      String branch,
      String rollNo,
      String linkedInURL,
      String githubURL,
      List domains,
      List languages,
      bool hosteller,
      String post) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser user = result.user;
      await DataBaseService(uid: user.uid).updateUserData(
          name,
          phoneNo,
          email,
          year, 
          branch,
          rollNo,
          linkedInURL,
          githubURL,
          domains,
          languages,
          hosteller,
          post,
          null,
          []);
      Map<String, dynamic> userlist = {
        'name': name,
        'contact': phoneNo,
        'email': email,
        'year': year,
        'branch': branch,
        'rollNo': rollNo,
        'linkedInURL': linkedInURL,
        'githubURL': githubURL,
        'domains': domains,
        'languages': languages,
        'hosteller': hosteller,
        'post': post,
        "peerID": [],
        'photoURL': null
      };
      userlist["id"]=user.uid;
      await StorageServices.saveUserInfo(userlist);
      return user;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
