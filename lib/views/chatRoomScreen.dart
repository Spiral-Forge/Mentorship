import 'package:chatApp/common/widgets.dart';
import 'package:chatApp/config/constants.dart';
import 'package:chatApp/helper/authenticate.dart';
// import 'package:chatApp/helper/Storage.dart';
import 'package:chatApp/services/auth.dart';
import 'package:chatApp/services/database.dart';
import 'package:chatApp/views/conversation.dart';
import 'package:chatApp/views/searchScreen.dart';
import 'package:chatApp/views/sidebarScreens/about.dart';
import 'package:chatApp/views/sidebarScreens/faqs.dart';
import 'package:chatApp/views/sidebarScreens/feedback.dart';
import 'package:chatApp/views/sidebarScreens/guidelines.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  var _darkTheme = true;
  AuthMethods authMethods=new AuthMethods();
  DatabaseMethods databaseMethods=new DatabaseMethods();
  Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
            return ChatRoomTile(snapshot.data.documents[index].data["chatRoomID"]
            .toString().replaceAll("_", "")
            .replaceAll(Constants.myID, ""),
            snapshot.data.documents[index].data["chatRoomID"]
            );
          }
          ): Container();
      },
      );
  }

  
  @override
  void initState(){
    saveUserInfo();
    super.initState();

  }
  void saveUserInfo() async {
    //Constants.myID = await StorageHelperFunctions.getUserID();
    //print("coming here and id is "+ Constants.myID);
    databaseMethods.getChatRooms(Constants.myID).then((chatRooms){
      setState(() {
        chatRoomsStream=chatRooms;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Room"),
        // actions: <Widget>[
        //   GestureDetector(
        //     onTap: (){
        //       authMethods.signOut();
        //       Navigator.pushReplacement(context, MaterialPageRoute(
        //       builder: (context)=>Authenticate()
        //     ));
        //     },
        //     child: Container(
        //       padding: EdgeInsets.symmetric(horizontal:16),
        //       child: Icon(Icons.exit_to_app)
        //     ),
        //   )
        // ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new ListTile(
              title: new Text("Code of Conduct"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Guidelines()));
              }
            ),
            new ListTile(
              title: new Text("About"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new About()));
              }
            ),
            new ListTile(
              title: new Text("FAQs"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new FAQS()));
              }
            ),
            
            new ListTile(
              title: new Text("Contact us and feedback"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MyFeedback()));
              }
            ),
             
            new Divider(),
            new ListTile(
              trailing: Transform.scale(
                scale: 1.4,
                child: Switch(
                  value: _darkTheme,
                  // onChanged: (val) {
                  //   setState(() {
                  //     _darkTheme = val;
                  //   });
                  //   //onThemeChanged(val, _themeChanger);
                  // },
                ),
              ),
              // leading: new IconButton(
              //             onPressed: () => _themeChanger.setTheme(Theme.dark()),
              //             icon: Icon(
              //               Icons.brightness_3
              //             ),
              //             color: Hexcolor('#565656'),
              //           ),
              // title: new Text("Change Theme"),
              // onTap: () {
              //   Navigator.of(context).pop();
              //   Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ThemeChanger(ThemeData.dark())));
              // }
            ),           
            new Divider(),
            new ListTile(
              title: new Text("Logout"),
              trailing: new Icon(Icons.people),
              onTap: () async{
                await authMethods.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context)=>Authenticate()
                ));
              }
            ),
          ],
        ),
      ),
      body:chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context)=>SearchScreen()
          ));
        },),
    );
  }
}


class ChatRoomTile extends StatefulWidget {
  final String userID;
  final String chatRoomID;
  ChatRoomTile(this.userID,this.chatRoomID);

  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  DatabaseMethods databaseMethods=new DatabaseMethods();
  String username="";
  @override
  void initState(){
    getNames();
    super.initState();
  }
  getNames() async{
    //print(widget.userID);
    await databaseMethods.getUserFromID(widget.userID).then((val){
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
              builder: (context)=>ConversationScreen(widget.chatRoomID)
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
          Text(username,style:simpleTextFieldStyle())
        ],)
      ),
    );
  }
}