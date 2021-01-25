import 'package:dbapp/screens/chat/chatRoomScreen.dart';
import 'package:dbapp/shared/MyDrawer.dart';
import 'package:dbapp/services/database.dart';
import 'package:flutter/material.dart';

class ChatRoomList extends StatefulWidget {
  final String userID;
  final List<dynamic> peerList;
  ChatRoomList(this.userID, this.peerList);
  @override
  _ChatRoomListState createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  Stream chatRooms;
  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    DataBaseService().getUserPeers(widget.userID).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
      });
    });
  }

  Widget roomList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.data["peerID"].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                      widget.userID, snapshot.data.data["peerID"][index]);
                })
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    final MyDrawer _drawer = new MyDrawer();
    return Scaffold(
        drawer: _drawer,
        key: _scaffoldKey,
        body: Column(children: [
          Expanded(
              child: Container(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 42, 0, 0),
                          child: Row(children: [
                            IconButton(
                                icon: Icon(Icons.menu),
                                onPressed: () {
                                  _scaffoldKey.currentState.openDrawer();
                                }),
                            Text(
                              "Chat Room",
                              style: TextStyle(
                                  fontFamily: 'GoogleSans', fontSize: 23),
                            )
                          ]),
                        ),
                        Expanded(child: roomList())
                      ]))))
        ]));
  }
}

class ChatRoomTile extends StatefulWidget {
  final String userID;
  final String peerID;
  ChatRoomTile(this.userID, this.peerID);

  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  DataBaseService databaseMethods = new DataBaseService();
  String username = "";
  String profPic = "";
  @override
  void initState() {
    getNames();
    super.initState();
  }

  getNames() async {
    await databaseMethods.getUserFromID(widget.peerID).then((val) {
      setState(() {
        username = val["name"];
        profPic = val["profilePic"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return username.length == 0
        ? Container()
        : GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConversationScreen(
                          widget.userID,
                          widget.peerID,
                          username,
                          profPic != null ? profPic : null)));
            },
            child: Row(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: <Widget>[
                        Container(
                            height: 60,
                            width: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(40),
                                image: DecorationImage(
                                  image: profPic != null
                                      ? NetworkImage(profPic)
                                      : AssetImage(
                                          "assets/images/avatars/av1.png"),
                                ))),
                        SizedBox(
                          width: 8,
                        ),
                        Text(username,
                            style: TextStyle(
                              fontFamily: 'GoogleSans',
                              fontSize: 25,
                            ))
                      ],
                    )),
              ],
            ),
          );
  }
}
