import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  final String uid;
  DataBaseService({this.uid});
  final CollectionReference userCollection =
      Firestore.instance.collection("Users");

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
      String dpurl,
      List<dynamic> peerID
      ) async {
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
      'peerID': peerID,
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

  Future<DocumentReference> addResource(collectionName, title, link) async {
    Map<String, String> resourceMap = {"Title": title, "Link": link};
    return await Firestore.instance
        .collection(collectionName)
        .add(resourceMap)
        .catchError((e) {
          print(e.toString());
    });
  }

  Future<dynamic> getUserFromID(String userID) async{
    dynamic doc=await Firestore.instance.collection("Users").document(userID).get();
    var data=await doc.data;
    Map<String,String> rv={
      "name":data["name"],
      "profilePic":data["photoURL"]
    };
    return rv;
  }
}


