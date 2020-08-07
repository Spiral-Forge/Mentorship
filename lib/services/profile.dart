import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/models/mentee.dart';

class ProfileService{
  getUserProfile(String uid) async{
    return await Firestore.instance.
            collection('Users').document(uid).get();
  }
  // Future<Mentee> getProfname() async {
  //     DocumentSnapshot snapshot= await Firestore.instance.collection('Mentee').document('XbsZ1A9UQcRS6OV5khLS2tpAvQ03').get();
  //     return snapshot['name'];
  //   }

  getMentorProfile(String uid) async{
    return await Firestore.instance.
            collection('Mentor').document(uid).get();
  }
}

