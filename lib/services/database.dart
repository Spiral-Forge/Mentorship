import 'package:chatApp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods{
  getEvents(){
    return Firestore.instance.collection("Events")
        .getDocuments();
  }
  getUserByUsername(String name) async {
    return await Firestore.instance.collection("users")
      .where("name",isEqualTo:name)
      .getDocuments();
  }
  getUserInfo(String email) async {
    return Firestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }
  getProfile(String userID){
    return Firestore.instance.collection('users').document(userID).get();
  }

  uploadUserInfo(userMap) async {
    return await Firestore.instance.collection("users")
    .add(userMap);

  }
  createChatRoom(String chatRoomID,chatRoomMap){
    Firestore.instance.collection("ChatRoom").document(chatRoomID)
      .setData(chatRoomMap).catchError((e){
        print(e.toString());
      });
  }

  addConversationMessage(String chatRoomID,messageMap){
    Firestore.instance.collection("ChatRoom")
    .document(chatRoomID)
    .collection("chats")
    .add(messageMap)
    .catchError((e){
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomID)async {
    return await Firestore.instance.collection("ChatRoom")
    .document(chatRoomID)
    .collection("chats")
    .orderBy("time",descending: false)
    .snapshots();
  }

  getChatRooms(String userID) async {
    return await Firestore.instance.collection("ChatRoom")
            .where("users",arrayContains:userID)
            .snapshots();
  }

  Future<DocumentReference> addFeedback(feedbackMap) {
    return Firestore.instance
        .collection("feedback")
        .add(feedbackMap)
        .catchError((e) {
      print(e);
    });
  }

  Future<dynamic> getUserFromID(String userID) async{
    dynamic doc=await Firestore.instance.collection("users").document(userID).get();
    return await doc.data["name"];
    // .then((value){
    //   print(value.data);
    //   return(value.data["name"]);
    // });
    // .where("documentID", isEqualTo: userID)
    //     .getDocuments();
  
    // print(document.documents[0].data["name"]);
    // firestoreInstance.collection("users").document(firebaseUser.uid).get().then((value){
    //   print(value.data);
    // });
  }

}