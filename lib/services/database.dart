import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/models/mentee.dart';
import 'package:dbapp/models/mentor.dart';
import 'package:dbapp/models/chatlist.dart';

class DataBaseService {
  //collection reference
  final String uid;
  DataBaseService({this.uid});
  final CollectionReference userCollection =
      Firestore.instance.collection("Users");
  //final CollectionReference menteeCollection= Firestore.instance.collection("Mentee");

  Future updateUserData(
      String name,
      String phoneNo,
      String email,
      String year,
      String branch,
      String rollNo,
      String linkedInURL,
      String githubURL,
      List domains,
      List languages,
      bool hosteller,
      String post,
      String dpurl) async {
    return await userCollection.document(uid).setData({
      'name': name,
      'year': year,
      'email': email,
      'rollNo': rollNo,
      'branch': branch,
      'contact': phoneNo,
      'linkedInURL': linkedInURL,
      'githubURL': githubURL,
      'domains': domains,
      'hosteller': hosteller,
      'languages': languages,
      'post': post,
      'peerID': [],
      'photoURL': dpurl
    });
  }

  getEvents() async {
    return await Firestore.instance.collection("Events").getDocuments();
  }

  getCurrentCollectionData(collectionName) async {
    return await Firestore.instance.collection(collectionName).getDocuments();
  }

  getUserData() async {
    return await Firestore.instance
        .collection("Users")
        .document(this.uid)
        .get();
  }

  getConversationMessages(String chatRoomID)async {
    return await Firestore.instance.collection("ChatRoom")
    .document(chatRoomID)
    .collection("chats")
    .orderBy("time",descending: false)
    .snapshots();
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

  getPeerData(String peerID) async {
    return await Firestore.instance.collection("Users").document(peerID).get();
  }

  // Future<bool> addChatRoom(chatRoom, chatRoomId) {
  //   Firestore.instance
  //       .collection("MentorMentee")
  //       .document(chatRoomId)
  //       .setData(chatRoom)
  //       .catchError((e) {
  //     print(e);
  //   });
  // }

  // Future getUserName(id) async {
  //   DocumentSnapshot snapshot =
  //       await Firestore.instance.collection("Mentor").document(id).get();
  //   return snapshot.data["name"];
  // }

  // Future getMyName(id) async {
  //   DocumentSnapshot snapshot =
  //       await Firestore.instance.collection("Mentee").document(id).get();
  //   return snapshot.data["name"];
  // }

  // Future<void> addMessage(String chatRoomId, chatMessageMap) {
  //   Firestore.instance
  //       .collection("MentorMentee")
  //       .document(chatRoomId)
  //       .collection("chats")
  //       .add(chatMessageMap)
  //       .catchError((e) {
  //     print("Error in add message");
  //   });
  // }

  // getChats(String chatRoomId) {
  //   print("wwere inside getchats");
  //   print(chatRoomId);
  //   // return await Firestore.instance
  //   //     .collection("MentorMentee")
  //   //     .document(chatRoomId)
  //   //     .collection("chats")
  //   //     .snapshots();
  //   //     //.map(_chatListFromSnapshot);
  //   //     // print("inside get chats");
  //   //     // print(variable);
  //   //     // return variable;
  //   var document = Firestore.instance
  //       .collection('MentorMentee')
  //       .document(chatRoomId)
  //       .collection("chats");
  //   return document.getDocuments();

  //   // await document.get().then((val){
  //   //   print("yoyo");
  //   //   print(val.data["chats"]);
  //   // });
  //   //document.get();
  // }

  Future<DocumentReference> addFeedback(feedbackMap) async {
    return await Firestore.instance
        .collection("feedback")
        .add(feedbackMap)
        .catchError((e) {
      print(e);
    });
  }

  // Future<dynamic> getUserChats(String itIsMyName) async {
  //   return await Firestore.instance
  //       .collection("MentorMentee")
  //       .where('users', arrayContains: itIsMyName)
  //       .snapshots();
  // }

//my list from snapshtot
  // List<Mentor> _userListFromSnapshot(QuerySnapshot snapshot){
  //   return snapshot.documents.map((doc){
  //     return UserData(
  //       name:doc.data['name'] ?? '',
  //       year: doc.data['year'] ?? 0
  //     );
  //   }).toList();
  // }

  //userdata list from snapshot
  List<Chatlist> _chatListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Chatlist(
        message: doc.data['message'] ?? '',
      );
    }).toList();
  }

  Future<DocumentReference> addResource(collectionName, title, link) async {
    print("coming here");
    Map<String, String> resourceMap = {"Title": title, "Link": link};
    print(resourceMap);
    return await Firestore.instance
        .collection(collectionName)
        .add(resourceMap)
        .catchError((e) {
      print(e);
    });
  }
}
