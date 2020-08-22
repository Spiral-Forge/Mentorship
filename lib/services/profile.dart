import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/models/mentee.dart';
import 'package:dbapp/services/database.dart';
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

  Future updateDP(url) async {
    FirebaseUser currUser = await FirebaseAuth.instance.currentUser();
    print("here");
    print(url);
    await Firestore.instance
        .collection('/Users')
        .where('email', isEqualTo: currUser.email)
        .getDocuments()
        .then((docs) async {
      print("hello");
      await Firestore.instance
          .document('/Users/${docs.documents[0].documentID}')
          .updateData({
        'photoURL': url,
      }).then((val) {
        print("updated dp :)");
      }).catchError((e) {
        print(e);
      });
    }).catchError((e) {
      print(e);
    });
    print("checkpoint");
  }
}
