import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  getUserProfile(String uid) async {
    return await Firestore.instance.collection('Users').document(uid).get();
  }

  Future updateDP(url) async {
    FirebaseUser currUser = await FirebaseAuth.instance.currentUser();
    await Firestore.instance
        .collection('/Users')
        .where('email', isEqualTo: currUser.email)
        .getDocuments()
        .then((docs) async {
      await Firestore.instance
          .document('/Users/${docs.documents[0].documentID}')
          .updateData({
            'photoURL': url,
          })
          .then((val) {})
          .catchError((e) {
            print(e);
          });
    }).catchError((e) {
      print(e);
    });
  }
}
