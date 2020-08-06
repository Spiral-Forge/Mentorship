import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/models/mentee.dart';

class ProfileService{
  getMenteeProfile(String uid){
    return Firestore.instance.
            collection('Mentee').document(uid).get();
  }
  // Future<Mentee> getProfname() async {
  //     DocumentSnapshot snapshot= await Firestore.instance.collection('Mentee').document('XbsZ1A9UQcRS6OV5khLS2tpAvQ03').get();
  //     return snapshot['name'];
  //   }

  getMentorProfile(String uid){
    return Firestore.instance.
            collection('Mentor').document(uid).get();
  }
}

