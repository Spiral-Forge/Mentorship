import 'package:chatApp/common/widgets.dart';
import 'package:chatApp/config/constants.dart';
import 'package:chatApp/helper/Storage.dart';
import 'package:chatApp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'conversation.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchController=new  TextEditingController();
  DatabaseMethods databaseMethods=new DatabaseMethods();
  QuerySnapshot searchSnapshot;

  Widget SearchTile({String name,String email,String userid}){
      return Container(
        padding: EdgeInsets.symmetric(vertical:16,horizontal:24),
        child:Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(name,style: simpleTextFieldStyle(),),
                Text(email,style: simpleTextFieldStyle(),)
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                createChatRoomAndStartConversation(userid);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical:8,horizontal:20),
                child:Text("Message"),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius:BorderRadius.circular(30)
                ),
                ),
            )
          ],
        )
      );
  }

  Widget searchList(){
    // if(searchSnapshot !=null){
    //   print(searchSnapshot.documents[0].documentID);
    // }
    
    return searchSnapshot !=null ? ListView.builder(
      itemCount:searchSnapshot.documents.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SearchTile(
          name:searchSnapshot.documents[index].data["name"],
          email:searchSnapshot.documents[index].data["email"],
          userid: searchSnapshot.documents[index].documentID,
          );
      },
    ) : Container() ;
  }

  void createChatRoomAndStartConversation(String userid) {
    //TODO
    //add check if user is trying to text herself=> required use case?

    //HelperFunctions.getUserID();
    List<String> users=[Constants.myID,userid];
    print(users);
    String chatRoomID=getChatRoomId(Constants.myID,userid);
    Map<String, dynamic> chatRoomMap={
      "users":users,
      "chatRoomID":chatRoomID
    };
    databaseMethods.createChatRoom(chatRoomID, chatRoomMap);
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ConversationScreen(chatRoomID)
      ));

  }
  String getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  void initiateSearch() {
    databaseMethods.getUserByUsername(searchController.text).then((data){
      //print(data);
      setState(() {
        searchSnapshot=data;
      });
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, "search screen appbar"),
      body:Container(
        child: Column(
          children:[
            Container(
              color:Color(0X54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal:24,vertical:16),
              child: Row(children: <Widget>[
                Expanded(
                    child: TextField(
                      controller:searchController,
                      style: TextStyle(
                        color: Colors.black
                      ),
                      decoration: InputDecoration(
                        hintText: "Search username..",
                        hintStyle: TextStyle(
                          color: Colors.black
                          ),
                        border: InputBorder.none
                      ),
                    )
                    ),
                GestureDetector(
                  onTap: (){
                    initiateSearch();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0x36FFFFFF),
                          const Color(0x0FFFFFFF)
                        ]
                        ),
                        borderRadius: BorderRadius.circular(40)
                    ),
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.search)),
                )
              ],),
            ),
            searchList()
          ]
        ),
      )
    );
  }

  
}

