// import 'package:chatApp/common/widgets.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/services/storage.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  //final String chatRoomID;
  final String userID;
  final String peerID;
  final String peerName;
  ConversationScreen(this.userID,this.peerID,this.peerName);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController =new TextEditingController();
  DataBaseService databaseMethods=new DataBaseService();
  Stream chatMessageStream;
  String chatRoomId;
  @override
  void initState(){
    
    initialise();
     super.initState();
    
  }

  void initialise() async{
    // var user=await StorageServices.getUserInfo();
    // print("user coming here from local storage");
    // print(user);
    List<String> users=[widget.userID,widget.peerID];
    //print(users);
    String chatRoomID=getChatRoomId(widget.userID,widget.peerID);
    setState(() {
      chatRoomId=chatRoomID;
    });
    Map<String, dynamic> chatRoomMap={
      "users":users,
      "ChatRoomID":chatRoomID
    };
    await databaseMethods.createChatRoom(chatRoomID, chatRoomMap);
    var messageList= await databaseMethods.getConversationMessages(chatRoomID);
    print(messageList);
    setState(() {
      chatMessageStream=messageList;
    });
     
  }

  String getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
  Widget ChatMessageList(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
            return MessageTile(snapshot.data.documents[index].data["message"],snapshot.data.documents[index].data["sentBy"]==widget.userID);
          }
          ): Container();
      },
      );
  }
  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String, dynamic> messageMap={
      "message":messageController.text,
      "sentBy": widget.userID,
      "time":DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessage(chatRoomId, messageMap);
      messageController.text='';
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
            title: new Text(widget.peerName),
            backgroundColor: AppColors.COLOR_TEAL_LIGHT),
      body: Container(
        child: Stack(
          children: <Widget>[
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color:Color(0X54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal:24,vertical:16),
                child: Row(children: <Widget>[
                  Expanded(
                      child: TextField(
                        controller:messageController,
                        style: TextStyle(
                          color: Colors.black
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter message..",
                          hintStyle: TextStyle(
                            color: Colors.black
                            ),
                          border: InputBorder.none
                        ),
                      )
                      ),
                  GestureDetector(
                    onTap: (){
                      sendMessage();
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
                      child: Icon(Icons.send)),
                  )
                ],),
              ),
            )
          ],
          
          ),
      )
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  MessageTile(this.message,this.isSentByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSentByMe ? 0:24, right:isSentByMe ? 24:0),
      margin: EdgeInsets.symmetric(vertical:8),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight:Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical:16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSentByMe ?  [
                   const Color(0xff96ECE7),
                   const Color(0xff96ECE7)
                ]:[
                  const Color(0xff565656),
                  const Color(0xff565656)
                ]
              )
            ),
        child:Text(message,style:TextStyle(
          color:Colors.black,
          fontSize:17
        ) 
        )
      ),
    );
  }
}