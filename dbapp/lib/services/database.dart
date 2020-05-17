import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/models/mentee.dart';
import 'package:dbapp/models/mentor.dart';

class DataBaseService{
  //collection reference
  final String uid;
  DataBaseService({this.uid});
  final CollectionReference mentorCollection= Firestore.instance.collection("Mentor");
  final CollectionReference menteeCollection= Firestore.instance.collection("Mentee");

  Future updateUserData(String name,int year, String email,int rollNo,String branch,int contact,String linkedInURL,String githubURL,List<String> domains,bool hosteller,List<String> languages,bool mentor) async{
    if(mentor){
      return await mentorCollection.document(uid).setData({
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
      'languages':languages
      });
    }else{
      return await menteeCollection.document(uid).setData({
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
      'languages':languages
      });
    }
    
  }

  // userdata list from snapshot
  // List<Mentor> _userListFromSnapshot(QuerySnapshot snapshot){
  //   return snapshot.documents.map((doc){
  //     return UserData(
  //       name:doc.data['name'] ?? '',
  //       year: doc.data['year'] ?? 0
  //     );
  //   }).toList();
  // }

  //get a new stream for any changes to user collecion
  // Stream<List<Mentor>> get users{
  //   return mentorCollection.snapshots()
  //     .map(_userListFromSnapshot);
  // }
  // Stream<List<Mentee>> get users{
  //   return menteeCollection.snapshots()
  //     .map(_userListFromSnapshot);
  // }
}

// Future getUser(String uid) async{
//   try{
//     var userData=await menteeCollection.document(uid).get();
//     return Mentee.fromData(userData.data);
//   }catch(e){
//     return e.message;
//   }
// }

// Future getUser(String uid) async {
//     try {
//       var userData = await menteeCollection.document(uid).get();
//       return User.fromData(userData.data);
//     } catch (e) {
//       return e.message;
//     }
//   }