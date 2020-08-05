import 'package:chatApp/common/widgets.dart';
import 'package:chatApp/config/constants.dart';
import 'package:chatApp/services/database.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomID;
  ConversationScreen(this.chatRoomID);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController =new TextEditingController();
  DatabaseMethods databaseMethods=new DatabaseMethods();
  Stream chatMessageStream;
  @override
  void initState(){
    databaseMethods.getConversationMessages(widget.chatRoomID).then((messageList){
      print(messageList);
      setState(() {
        chatMessageStream=messageList;
      });
      super.initState();
    });
  }
  Widget ChatMessageList(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
            return MessageTile(snapshot.data.documents[index].data["message"],snapshot.data.documents[index].data["sentBy"]==Constants.myID);
          }
          ): Container();
      },
      );
  }
  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String, dynamic> messageMap={
      "message":messageController.text,
      "sentBy": Constants.myID,
      "time":DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessage(widget.chatRoomID, messageMap);
      messageController.text='';
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, "chat person"),
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
                   const Color(0xff007EF4),
                   const Color(0xff2A75BC)
                ]:[
                  const Color(0X1AFFFFFF),
                  const Color(0x1AFFFFFF)
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