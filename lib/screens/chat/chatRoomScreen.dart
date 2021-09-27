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

  Widget chatMessageList() {
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: MessageTile(
                        snapshot.data.documents[index].data["message"],
                        snapshot.data.documents[index].data["sentBy"] ==
                            widget.userID,
                        widget.profPic),
                  );
                })
            : Container();
      },
    );
  }

  sendMessage() async {
    if (messageController.text.isNotEmpty) {
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

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    return Scaffold(
        backgroundColor:
            themeFlag ? AppColors.COLOR_DARK : AppColors.COLOR_TURQUOISE,
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 39,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
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
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.4),
                          child: Text(widget.peerName,
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: themeFlag ? null : Colors.white,
                              ))),
                    ),
                  ],
                ),
                CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        themeFlag ? Colors.black : Color(0xff569BD4),
                    child: IconButton(
                      icon: Icon(
                        Icons.phone,
                        size: 21,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ))
              ],
            ),
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: themeFlag ? Colors.black : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                )),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: chatMessageList(),
            ),
          )),
          Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: AppColors.COLOR_DARK,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      controller: messageController,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                      ),
                      decoration: InputDecoration(
                          fillColor:
                              themeFlag ? Colors.white : AppColors.PROTEGE_GREY,
                          hintText: "Enter message..",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                          ),
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
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
              ))
        ]));
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  final String profile;
  MessageTile(this.message, this.isSentByMe, this.profile);
  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    return isSentByMe
        ? SelfMessageTile(message: message)
        : PeerMessageTile(
            message: message,
            profile: profile,
          );
  }
}

class PeerMessageTile extends StatelessWidget {
  final String message;
  final String profile;

  const PeerMessageTile({Key key, this.message, this.profile})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.blue,
          backgroundImage: profile != null
              ? NetworkImage(profile)
              : AssetImage("assets/images/avatars/av1.png"),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(9),
                topRight: Radius.circular(9),
                bottomRight: Radius.circular(9),
              ),
              elevation: 5,
              color: themeFlag ? Color(0xff303030) : Colors.black,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 10.0,
                            maxWidth:
                                (6 * MediaQuery.of(context).size.width) / 10,
                          ),
                          child: Linkify(
                              onOpen: (link) async {
                                if (await canLaunch(link.url)) {
                                  await launch(link.url);
                                } else {
                                  Toast.show("Could not launch $link", context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.BOTTOM);
                                }
                              },
                              text: message,
                              linkStyle: TextStyle(
                                  color: themeFlag
                                      ? Hexcolor("#42A2F5")
                                      : Hexcolor("#2D8CFF")),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                  Positioned(
                    child: Text('Time',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w500)),
                    right: 5,
                    bottom: 5,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ],
    );
  }
}

class SelfMessageTile extends StatelessWidget {
  final String message;

  const SelfMessageTile({Key key, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Material(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(9),
            topRight: Radius.circular(9),
            bottomLeft: Radius.circular(9),
          ),
          elevation: 5,
          color: themeFlag ? Color(0xff5A5A5A) : AppColors.COLOR_DARK,
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 20.0,
                        maxWidth: (7 * MediaQuery.of(context).size.width) / 9,
                      ),
                      child: Linkify(
                          onOpen: (link) async {
                            if (await canLaunch(link.url)) {
                              await launch(link.url);
                            } else {
                              Toast.show("Could not launch $link", context,
                                  duration: Toast.LENGTH_SHORT,
                                  gravity: Toast.BOTTOM);
                            }
                          },
                          text: message,
                          linkStyle: TextStyle(
                              color: themeFlag
                                  ? Hexcolor("#42A2F5")
                                  : Hexcolor("#2D8CFF")),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
              Positioned(
                child: Text('Time',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w500)),
                right: 5,
                bottom: 5,
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
