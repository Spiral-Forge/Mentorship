import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/chat/chatRoomScreen.dart';
import 'package:dbapp/screens/myDrawer.dart';
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
    final myDrawer _drawer = new myDrawer();
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Room"),
        backgroundColor: AppColors.COLOR_TEAL_LIGHT
      ),
      drawer: _drawer,
      
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
  String profPic="";
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
        username=val["name"];
        profPic=val["profilePic"];
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
              builder: (context)=>ConversationScreen(widget.userID,widget.peerID,username,profPic!=null ? profPic : null)
            ));
        },
          child: Row(
            children: <Widget>[
              Container(
         padding: EdgeInsets.symmetric(horizontal:24,vertical:16),
        child:Row(children: <Widget>[
              Container(
                height:60,
                width:60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:AppColors.PROTEGE_CYAN,
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                      image: profPic!=null ? NetworkImage(profPic) : AssetImage("assets/images/avatars/av1.jpg"),
                  ))
              ),
              SizedBox(
                width: 8,
              ),
              Text(username,
              style: TextStyle(
                            fontFamily: 'GoogleSans',
                            fontSize: 25,
                          )
              )
        ],)
      ),
            ],
          ),
    );
  }
}