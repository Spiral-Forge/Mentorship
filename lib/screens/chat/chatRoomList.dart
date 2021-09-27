import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/chat/chatRoomScreen.dart';
import 'package:dbapp/shared/myDrawer.dart';
import 'package:dbapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Widget roomList(bool themeFlag) {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container(
                decoration: BoxDecoration(
                    color: themeFlag ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(34),
                        topRight: Radius.circular(34))),
                child: ListView.builder(
                    itemCount: snapshot.data.data["peerID"].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ChatRoomTile(
                          widget.userID, snapshot.data.data["peerID"][index]);
                    }),
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    final myDrawer _drawer = new myDrawer();
    return Scaffold(
        backgroundColor:
            themeFlag ? Color(0xff303030) : AppColors.COLOR_TURQUOISE,
        drawer: _drawer,
        key: _scaffoldKey,
        body: Column(children: [
          Expanded(
              child: Container(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 0, 0),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.menu,
                                      color: Colors.white,
                                      size: 39,
                                    ),
                                    onPressed: () {
                                      _scaffoldKey.currentState.openDrawer();
                                    }),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 5),
                                  child: Text(
                                    "Chat Room",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Quicksand',
                                        fontSize: 27,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SearchBar(),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(child: roomList(themeFlag))
                      ]))))
        ]));
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return Stack(
      children: [
        Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
                color: themeFlag
                    ? Color(0xff5A5A5A).withOpacity(0.6)
                    : Color(0xff64A3D8),
                borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    cursorColor: Colors.white,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Quicksand',
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Quicksand',
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            )),
        Positioned(
            left: 0,
            child: CircleAvatar(
              backgroundColor:
                  themeFlag ? Color(0xff5A5A5A) : Color(0xff569BD4),
              radius: 25,
              child: Icon(Icons.search, color: Colors.white),
            ))
      ],
    );
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
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                            radius: 30,
                            backgroundImage: profPic != null
                                ? NetworkImage(profPic)
                                : AssetImage("assets/images/avatars/av1.png")),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(username,
                                style: TextStyle(
                                  fontFamily: 'GoogleSans',
                                  fontSize: 25,
                                )),
                            Text(
                              'Last message',
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w500,
                                color: Color(0xff777777),
                                fontSize: 13,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Text(
                      'Time',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w500,
                        color: Color(0xff777777),
                        fontSize: 13,
                      ),
                    )
                  ],
                )),
          );
  }
}
