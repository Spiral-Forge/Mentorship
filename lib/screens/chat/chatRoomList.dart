import 'package:dbapp/screens/chat/chatRoomScreen.dart';
import 'package:dbapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ChatRoomList extends StatefulWidget {
  final String userID;
  final List<dynamic> peerList;
  ChatRoomList(this.userID,this.peerList);
  @override
  _ChatRoomListState createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  // void initState(){
  //   print("printing peer list");
  //   print(widget.peerList);
  //   super.initState();
  // }

  Widget roomList(){
    // return ListBuilder(
    //   stream: chatRoomsStream,
    //   builder: (context,snapshot){
    //     return snapshot.hasData ? ListView.builder(
    //       itemCount: snapshot.data.documents.length,
    //       itemBuilder: (context,index){
    //         return ChatRoomTile(snapshot.data.documents[index].data["chatRoomID"]
    //         .toString().replaceAll("_", "")
    //         .replaceAll(Constants.myID, ""),
    //         snapshot.data.documents[index].data["chatRoomID"]
    //         );
    //       }
    //       ): Container();
    //   },
    //   );

      return ListView.builder(
          itemCount: widget.peerList.length,
          itemBuilder: (context, index) {
            return ChatRoomTile(
              widget.userID,
              widget.peerList[index]
            );
          });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Room"),
      ),
      body:roomList()
    );
  }
}

 

class ChatRoomTile extends StatefulWidget {
  final String userID;
  final String peerID;
  ChatRoomTile(this.userID,this.peerID);

  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  DataBaseService databaseMethods=new DataBaseService();
  String username="";
  @override
  void initState(){
    getNames();
    super.initState();
  }
  getNames() async{
    //print(widget.userID);
    await databaseMethods.getUserFromID(widget.peerID).then((val){
      print("val is what?");
      print(val);
      setState(() {
        username=val;
      });
    });
    //print(username);
    
    //print("all done");
  }
  @override
  Widget build(BuildContext context) {
    return username.length ==0 ? Container() : GestureDetector(
      onTap: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context)=>ConversationScreen(widget.userID,widget.peerID)
            ));
        },
          child: Container(
         padding: EdgeInsets.symmetric(horizontal:24,vertical:16),
        child:Row(children: <Widget>[
          Container(
            height:40,
            width:40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:Colors.blue,
              borderRadius: BorderRadius.circular(40)
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Text(username)
        ],)
      ),
    );
  }
}