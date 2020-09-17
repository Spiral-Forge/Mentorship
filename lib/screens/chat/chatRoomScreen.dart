import 'dart:async';

import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/profile/peerProfile.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatefulWidget {
  final String userID;
  final String peerID;
  final String peerName;
  final String profPic;
  ConversationScreen(this.userID, this.peerID, this.peerName, this.profPic);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController = new TextEditingController();
  DataBaseService databaseMethods = new DataBaseService();
  Stream chatMessageStream;
  String chatRoomId;
  var post;
  ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();

    initialise();
    getPost();
    super.initState();
  }

  void getPost() async {
    var user = await StorageServices.getUserInfo();
    this.setState(() {
      post = user["post"];
    });
  }

  void initialise() async {
    List<String> users = [widget.userID, widget.peerID];
    String chatRoomID = getChatRoomId(widget.userID, widget.peerID);
    print("priting userid");
    print(widget.userID);
    setState(() {
      chatRoomId = chatRoomID;
    });
    print(chatRoomID);
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "ChatRoomID": chatRoomID
    };
    await databaseMethods.createChatRoom(chatRoomID, chatRoomMap);
    var messageList = await databaseMethods.getConversationMessages(chatRoomID);
    print("displaying message List");
    print(messageList);
    setState(() {
      chatMessageStream = messageList;
    });
  }

  String getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  _scrollToEnd() async {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100), curve: Curves.ease);
  }

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());

        return snapshot.hasData
            ? ListView.builder(
                controller: scrollController,
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      snapshot.data.documents[index].data["message"],
                      snapshot.data.documents[index].data["sentBy"] ==
                          widget.userID);
                })
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sentBy": widget.userID,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessage(chatRoomId, messageMap);
      messageController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    return Scaffold(
        appBar: new AppBar(
            iconTheme: IconThemeData(
              color: themeFlag ? null : Colors.black, //change your color here
            ),
            backgroundColor: themeFlag ? null : Colors.white,
            title: Container(
                child: Row(
              children: <Widget>[
                CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 20,
                    child: ClipOval(
                        child: SizedBox(
                            width: 40,
                            height: 40,
                            child: widget.profPic != null
                                ? Image.network(widget.profPic)
                                : Image.asset(
                                    "assets/images/avatars/av1.png")))),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PeerProfile(post, widget.peerID)));
                    },
                    child: Container(
                        child: Text(widget.peerName,
                            style: TextStyle(
                              color: themeFlag ? null : Colors.black,
                            ))))
              ],
            ))),
        body: Container(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 72, top: 8),
                child: ChatMessageList(),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: themeFlag ? Colors.grey[700] : Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        controller: messageController,
                        style: TextStyle(
                            color: themeFlag ? Colors.white : Colors.black),
                        decoration: InputDecoration(
                            hintText: "Enter message..",
                            hintStyle: TextStyle(
                                color:
                                    themeFlag ? Colors.white : Colors.black87,
                                fontFamily: 'GoogleSans'),
                            border: InputBorder.none),
                      )),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40)),
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.send)),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  MessageTile(this.message, this.isSentByMe);
  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    return Container(
      padding: EdgeInsets.only(
          left: isSentByMe ? 0 : 10, right: isSentByMe ? 10 : 0),
      margin: EdgeInsets.symmetric(vertical: 2),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          constraints: BoxConstraints(
              maxWidth: (7 * MediaQuery.of(context).size.width) / 8),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: isSentByMe
                ? Hexcolor('#fcf9f0')
                : themeFlag ? Colors.grey[700] : AppColors.PROTEGE_GREY,
          ),
          child: Text(message,
              textAlign: isSentByMe ? TextAlign.right : TextAlign.left,
              style: TextStyle(
                  color: isSentByMe ? Colors.black : Colors.white,
                  fontSize: 17,
                  fontFamily: 'GoogleSans'))),
    );
  }
}
