import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/models/mentee.dart';
import 'package:dbapp/models/mentor.dart';
import 'package:dbapp/models/chatlist.dart';

class DataBaseService{
  //collection reference
  final String uid;
  DataBaseService({this.uid});
  final CollectionReference userCollection= Firestore.instance.collection("Users");
  //final CollectionReference menteeCollection= Firestore.instance.collection("Mentee");

  Future updateUserData(String name,int year, String email,int rollNo,String branch,int contact,String linkedInURL,String githubURL,List<String> domains,bool hosteller,List<String> languages,bool mentor) async{
    return await userCollection.document(uid).setData({
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
      'languages':languages,
      'post': mentor ? "Mentor" : "Mentee"
      });
    // if(mentor){
      
    // }else{
    //   return await menteeCollection.document(uid).setData({
    //   'name':name,
    //   'year':year,
    //   'email': email,
    //   'rollNo': rollNo,
    //   'branch':branch,
    //   'contact':contact,
    //   'linkedInURL': linkedInURL,
    //   'githubURL': githubURL,
    //   'domains':domains,
    //   'hosteller':hosteller,
    //   'languages':languages
    //   });
    // }
    
  }
   getEvents() async {
    return await Firestore.instance.collection("Events")
        .getDocuments();
  }

  getCurrentCollectionData(collectionName) async{
    return await Firestore.instance.collection(collectionName).getDocuments();
  }

  getUserData() async{
    return await Firestore.instance.collection("Users").document(this.uid).get();
  }
  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    Firestore.instance
        .collection("MentorMentee")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  Future getUserName(id) async{
    DocumentSnapshot snapshot= await Firestore.instance.collection("Mentor")
    .document(id).get();
    return snapshot.data["name"];
  }

  Future getMyName(id) async{
    DocumentSnapshot snapshot= await Firestore.instance.collection("Mentee")
    .document(id).get();
    return snapshot.data["name"];
  }


  Future<void> addMessage(String chatRoomId, chatMessageMap){

    Firestore.instance.collection("MentorMentee")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageMap).catchError((e){
          print("Error in add message");
    });
  }

  getChats(String chatRoomId){
    print("wwere inside getchats");
    print(chatRoomId);
    // return await Firestore.instance
    //     .collection("MentorMentee")
    //     .document(chatRoomId)
    //     .collection("chats")
    //     .snapshots();
    //     //.map(_chatListFromSnapshot);
    //     // print("inside get chats");
    //     // print(variable);
    //     // return variable;
        var document = Firestore.instance.collection('MentorMentee').document(chatRoomId).collection("chats");
        return document.getDocuments();

        // await document.get().then((val){
        //   print("yoyo");
        //   print(val.data["chats"]);
        // });
        //document.get();
  }

  Future<bool> addFeedback(feedbackMap) {
    Firestore.instance
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
  List<Chatlist> _chatListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Chatlist(
        message:doc.data['message'] ?? '',
      );
    }).toList();
  }

  //get a new stream for any changes to user collecion
  // Stream<List<Chatlist>> get mychats{
  //   return mentorCollection.snapshots()
     
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