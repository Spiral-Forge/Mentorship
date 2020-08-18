import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/models/mentee.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  getUserProfile(String uid) async {
    return await Firestore.instance.collection('Users').document(uid).get();
  }
  // Future<Mentee> getProfname() async {
  //     DocumentSnapshot snapshot= await Firestore.instance.collection('Mentee').document('XbsZ1A9UQcRS6OV5khLS2tpAvQ03').get();
  //     return snapshot['name'];
  //   }

  getMentorProfile(String uid) async {
    return await Firestore.instance.collection('Mentor').document(uid).get();
  }

  updateDP(dpurl) {
    var userInfo = new UserUpdateInfo();
    userInfo.photoUrl = dpurl;
    // FirebaseUser user = FirebaseUser.instance.currentUser();

    // FirebaseUser.updateProfile(userInfo).then((value) {
    // FirebaseAuth.instance.currentUser().then((user) {
    // Firestore.instance
    //     .collection('/users')
    //     .where('uid', isEqualTo: user.uid)
    //     .getDocuments()
    //     .then((docs) {
    //   Firestore.instance
    //       .document('/users/${docs.documents[0].documentID}')
    Firestore.instance.collection('users').document().setData({
      // .updateData({
      'photoURL': dpurl
    }).then((val) {
      print("dp added");
    }).catchError((e) {
      print(e);
    });
    //   });
    // }).catchError((e) {
    //   print(e);
    // });
    // }).catchError((e) {
    //   print(e);
    // });
  }
}
