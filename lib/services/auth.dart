import 'dart:math';

import 'package:dbapp/models/user.dart';
import 'package:dbapp/services/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dbapp/services/database.dart';
import 'dart:convert';
class AuthService{
  final FirebaseAuth _auth=FirebaseAuth.instance;

  //create user object based on firebase user
  // User _userFromFireBaseUser(FirebaseUser user){
  //   return user!=null ? User(uid:user.uid) : null;
  // }

  //auth change using stream
  Stream<FirebaseUser> get user{
    return _auth.onAuthStateChanged;
  }
   
  //sign in anonymously
  // Future signInAnon() async{
  //   try{
  //     AuthResult result =await _auth.signInAnonymously();
  //     FirebaseUser user=result.user;
  //     return _userFromFireBaseUser(user);
  //   }catch(e){
  //     print(e.toString());
  //     return null;
  //   }
  // }

  //sign in with email and password
  Future signin(String email,String password) async{
    try{
      AuthResult result=await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );
      //print("coming here atlease");
      FirebaseUser user=result.user;
      DataBaseService(uid:user.uid).getUserData().then((userdata) async{
       // print(userdata.data);
        Map<String,dynamic> userMap=userdata.data;
        userMap["avatarNum"]=Random().nextInt(4)+1;
        //print("printing user map");
        //print(userMap);
        await StorageServices.saveUserInfo(userMap);
        return user;
      });
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  
  //register wit email and password
  Future register(String name,String phoneNo,String email,String password,String year,String branch,String rollNo,String linkedInURL,String githubURL,List domains,List languages,bool hosteller, String post) async{
    try{
      AuthResult result=await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      FirebaseUser user=result.user;
      await DataBaseService(uid:user.uid).updateUserData(name, phoneNo, email, year, branch, rollNo,linkedInURL,githubURL,domains,languages, hosteller, post);
      //List<String> userList=[name,year.toString(),email,rollNo.toString(),branch,contact.toString(),linkedInURL,githubURL,domains.toString(),hosteller.toString(),languages.toString(),mentor.toString()];
      Map<String,dynamic> userlist={
        'name':name,
        'contact':phoneNo,
        'email': email,
        'year':year,
        'branch':branch,
        'rollNo': rollNo,
        'linkedInURL': linkedInURL,
        'githubURL': githubURL,
        'domains':domains,
        'languages':languages,
        'hosteller':hosteller,
        'post': post,
        "avatarNum": Random().nextInt(4)+1,
        "peerID":[]

      };
      print("coming here");
      await StorageServices.saveUserInfo(userlist);
      print("saved info");
      //String info= await StorageServices.getUserName();
      
      // print(decoded["domains"].runtimeType);
      // print("got info");
      return user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //signout
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}