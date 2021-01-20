import 'dart:async';

import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/profile/peerProfile.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:http/http.dart' as http;
import 'package:dbapp/constants/keys.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';

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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Stream chatMessageStream;
  String chatRoomId;
  var post;
  String token = '';
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
    setState(() {
      chatRoomId = chatRoomID;
    });
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "ChatRoomID": chatRoomID
    };
    await databaseMethods.createChatRoom(chatRoomID, chatRoomMap);
    var messageList = await databaseMethods.getConversationMessages(chatRoomID);
    var peerData = await databaseMethods.getPeerToken(widget.peerID);
    print("peerdata is");
    print(peerData.data["token"]);
    setState(() {
      chatMessageStream = messageList;
      token = peerData.data["token"];
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

  sendMessage() async {
    if (messageController.text.isNotEmpty) {
      print("coming here");
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sentBy": widget.userID,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      await databaseMethods.addConversationMessage(chatRoomId, messageMap);
      await sendAndRetrieveMessage(token, messageController.text);
    }
  }

  Future<Map<String, dynamic>> sendAndRetrieveMessage(
      String token, String msg) async {
    print("inside send and retrive func and token is " + token);
    print("inside send and retrive func and msg is " + msg);
    var serverToken = Keys.serverKey;
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': msg,
            'title': widget.peerName
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );
    messageController.text = '';
    print("inside mid of send and retrive func");

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );
    print("just before returning");
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    return Scaffold(
        appBar: new AppBar(
            iconTheme: IconThemeData(
              color: themeFlag ? null : Colors.black,
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
          decoration: BoxDecoration(
              image: DecorationImage(
            image: themeFlag
                ? AssetImage("assets/images/feature graphic.png")
                : AssetImage("assets/images/feature_light.jpeg"),
            fit: BoxFit.cover,
          )),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 72, top: 8),
                child: ChatMessageList(),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: themeFlag ? Colors.grey[900] : Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        controller: messageController,
                        style: TextStyle(
                            color: themeFlag ? Colors.white : Colors.black),
                        decoration: InputDecoration(
                            fillColor: themeFlag
                                ? Colors.white
                                : AppColors.PROTEGE_GREY,
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
      constraints: BoxConstraints(
          maxWidth: (7 * MediaQuery.of(context).size.width) / 8,
          minWidth: 10.0),
      padding: EdgeInsets.only(
          left: isSentByMe ? 0 : 10, right: isSentByMe ? 10 : 0),
      margin: EdgeInsets.symmetric(vertical: 2),
      // width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
            maxWidth: (7 * MediaQuery.of(context).size.width) / 8,
            minWidth: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: isSentByMe
              ? themeFlag
                  ? Colors.grey[800]
                  : Hexcolor("#dea38e")
              : themeFlag
                  ? Hexcolor("#22272B")
                  : Colors.grey[700],
        ),
        child: Linkify(
            onOpen: (link) async {
              if (await canLaunch(link.url)) {
                await launch(link.url);
              } else {
                Toast.show("Could not launch $link", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
              }
            },
            text: message,
            textAlign: isSentByMe ? TextAlign.right : TextAlign.left,
            linkStyle: TextStyle(
                color: themeFlag ? Hexcolor("#42A2F5") : Hexcolor("#2D8CFF")),
            style: TextStyle(
                color: Colors.white, fontSize: 17, fontFamily: 'GoogleSans')),
      ),
    );
  }
}
