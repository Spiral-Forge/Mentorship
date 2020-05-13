import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/models/userData.dart';

class DataBaseService{
  //collection reference
  final String uid;
  DataBaseService({this.uid});
  final CollectionReference usercollection= Firestore.instance.collection("users");

  Future updateUserData(String name,int year) async{
    return await usercollection.document(uid).setData({
      'name':name,
      'year':year
    });
  }

  //userdata list from snapshot
  List<UserData> _userListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return UserData(
        name:doc.data['name'] ?? '',
        year: doc.data['year'] ?? 0
      );
    }).toList();
  }

  //get a new stream for any changes to user collecion
  Stream<List<UserData>> get users{
    return usercollection.snapshots()
      .map(_userListFromSnapshot);
  }
}