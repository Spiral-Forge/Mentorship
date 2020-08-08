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
      FirebaseUser user=result.user;
      DataBaseService(uid:user.uid).getUserData().then((userdata) async{
        //print(userdata.data);
        await StorageServices.saveUserInfo(userdata.data);
        return user;
      });
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //register wit email and password
  Future register(String email,String password,String name,int year,int rollNo,String branch,int contact,String linkedInURL,String githubURL,List<String> domains,bool hosteller,List<String> languages,bool mentor) async{
    try{
      AuthResult result=await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      FirebaseUser user=result.user;
      await DataBaseService(uid:user.uid).updateUserData(name,year,email,rollNo,branch,contact,linkedInURL,githubURL,domains,hosteller,languages,mentor);
      //List<String> userList=[name,year.toString(),email,rollNo.toString(),branch,contact.toString(),linkedInURL,githubURL,domains.toString(),hosteller.toString(),languages.toString(),mentor.toString()];
      Map<String,dynamic> userlist={
        'name':name,
        'year':year,
        'email': email,
        'rollNo': rollNo,
        'branch':branch,
        'contact':contact,
        'linkedInURL': linkedInURL,
        'githubURL': githubURL,
        'domains':domains,
        'hosteller':hosteller,
        'languages':languages,
        'post': mentor ? "Mentor" : "Mentee"
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