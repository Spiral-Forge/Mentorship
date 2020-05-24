import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:dbapp/services/auth.dart';

import 'package:provider/provider.dart';
import 'package:dbapp/blocs/theme.dart';
import 'package:dbapp/blocs/values.dart';

import 'package:dbapp/screens/home/homepage.dart';

import 'package:dbapp/screens/sidebarScreens/about.dart';
import 'package:dbapp/screens/sidebarScreens/faqs.dart';
import 'package:dbapp/screens/sidebarScreens/feedback.dart';
import 'package:dbapp/screens/sidebarScreens/guidelines.dart';
import 'package:dbapp/shared/loading.dart';

import '../../services/database.dart';

class ChatScreen extends StatefulWidget{
  final String chatRoomId;
  final String myName;

  ChatScreen({this.chatRoomId,this.myName});

  @override 
  State createState()=> new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {

  var _darkTheme = true;

  final AuthService _auth=AuthService();
  var chats;
  String msg = '';
  bool sendBy;
  bool loading = true;
  final TextEditingController textController = new TextEditingController();

  Widget chatMessages(){
    return loading? Loading() : 
    ListView.builder(
      itemCount: chats.length,
       itemBuilder: (context,index){
         return chats[index];
       }
      );
     }
      
    //new ChatMessageTile(message: msg, sendbyMe: sendBy, myName: widget.myName);
    // return FutureBuilder<String>(
    //   future: getChats("S03TGDOFDMYayaQ9bAGmWxG10sj1_zmjYSWrGgmWpfR1p3ZMyxnbw4Hw1"),
    //   builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    //     if(snapshot.hasData){
    //       return Text('Number Of completed : ${snapshot.data}');
    //     }
    //     return Container();
    //   },
    // );
    // return StreamBuilder(
    //   stream: chats,
    //   builder: (context,snapshot){
    //     return snapshot.hasData? ListView.builder(
    //       itemCount: snapshot.data.documents.length,
    //         itemBuilder: (context,index){
    //           return ChatMessageTile(
    //             message: snapshot.data.documents[index].data["message"],
    //             sendbyMe: widget.myName == snapshot.data.documents[index].data["sendBy"],
    //             myName: widget.myName,
    //           );
    //         }) : 
    //         Container(
    //           child: Text("empty chats"),
    //         );
    //   },
    // );


  addMessage() {
    if (textController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": widget.myName,
        "message": textController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };

      DataBaseService().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        textController.text = "";
      });
    }
  }

  @override
  void initState(){
    super.initState();
    print(widget.chatRoomId);
    DataBaseService().getChats(widget.chatRoomId).then((val){
          print("after this");
          print(val.documents[0].data["message"]);
          this.setState((){
            chats = val;
            loading=false;
          });
          List<ChatMessageTile> templist=[];
          for(var i=0;i<val.documents.length;i++){
            templist.add(
              ChatMessageTile(
                message: val.documents[i].data["message"], 
                sendbyMe: widget.myName == chats.documents[0].data["sendBy"], 
                myName: widget.myName)
            );
          }
      });
  }

  @override 
  Widget build(BuildContext context){

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    // final _themeChanger = Provider.of<ThemeChanger>(context);
    _darkTheme = (_themeChanger.getTheme() == darkTheme);

    return new Scaffold( 
      appBar: AppBar(
        title:Text(widget.chatRoomId),
        elevation: Theme.of(context).platform== TargetPlatform.iOS ? 0.0 : 4.0,
        backgroundColor:Colors.teal[300] ,
        // actions: <Widget>[
        //   FlatButton.icon(
        //     onPressed: () async{
        //       await _auth.signOut();
        //     }, 
        //     icon: Icon(Icons.person),
        //     label:Text('logout')
        //     )
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
                  onChanged: (val) {
                    setState(() {
                      _darkTheme = val;
                    });
                    onThemeChanged(val, _themeChanger);
                  },
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
              onTap: () async => await _auth.signOut()
            ),
          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            chatMessages(),
            Container(alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                // color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                              hintText: "Message...",
                              hintStyle: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                              ),
                              border: const OutlineInputBorder()
                          ),
                        )),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.teal,
                                    Colors.teal
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/send.png",
                            height: 25, width: 25,)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessageTile extends StatelessWidget{
  final String message;
  final bool sendbyMe;
  final String myName;

  ChatMessageTile({@required this.message, @required this.sendbyMe, @required this.myName});

  @override 
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.only(
        top:8, bottom: 8,
        left: sendbyMe? 0:24,
        right: sendbyMe? 24:0
      ),
      alignment: sendbyMe ? Alignment.centerRight: Alignment.centerLeft,
      child: Container(
        margin: sendbyMe? EdgeInsets.only(left: 30) : EdgeInsets.only(right:30),
        padding: EdgeInsets.only(
          top: 17, bottom: 17,
          left: 20, right: 20
        ),
        decoration: BoxDecoration(
          borderRadius: sendbyMe? BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23)
          ) : 
          BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23)
          ),
          gradient: LinearGradient(
            colors:[
            Colors.teal[300],
            Colors.teal[300] ]
          )
        ),
        child: Text(message,
          textAlign: TextAlign.start,
          style: TextStyle(
            // color: Colors.white,
            fontSize: 16,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.w300)
        ),
      ),
    );
  }
}



// const String _name = "Urvi";

// class ChatMessagess extends StatelessWidget{
//     ChatMessage({this.text,this.animationController});
//     final String text;
//     final AnimationController animationController;
//     @override
//     Widget build(BuildContext context){
//       return new SizeTransition(
//         sizeFactor: new CurvedAnimation(
//           parent: animationController,curve: Curves.fastLinearToSlowEaseIn),
//         axisAlignment: 0.0,
//         child: new Container(
//           margin: const EdgeInsets.symmetric(vertical: 10.0),
//           child: new Row( 
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               new Container(
//                 margin: const EdgeInsets.only(right: 16.0),
//                 child: new CircleAvatar(child: new Text(_name[0])),
//               ),
//               new Expanded(
//                 child: new Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget> [
//                     new Text(_name,style: Theme.of(context).textTheme.subhead),
//                     new Container(
//                       margin: const EdgeInsets.only(top: 5.0),
//                       child: new Text(text),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
// }


  // Widget _buildTextComposer(){
  //   return new IconTheme(
  //     data: new IconThemeData(color: Theme.of(context).accentColor), 
  //     child: new Container( 
  //       margin: const EdgeInsets.symmetric(horizontal: 8.0),
  //       child: new Row(
  //         children: <Widget>[
  //           new Flexible(
  //             child: new TextField(
  //               controller: _textController,
  //               onChanged: (String text){
  //                 setState(() {
  //                   _isComposing = text.length > 0;
  //                 });
  //               },
  //               onSubmitted: addMessage(_textController.text),
  //               decoration: new InputDecoration.collapsed(hintText: "Send a message"),
  //             ) ,
  //           ),
  //           new Container(
  //             margin: new EdgeInsets.symmetric(horizontal: 4.0),
  //             child: Theme.of(context).platform == TargetPlatform.iOS ?
  //             new CupertinoButton(
  //               child: new Text("Send"), 
  //               onPressed:_isComposing
  //                     ? () => addMessage(_textController.text) : null,) :
  //               new IconButton(
  //                 icon: new Icon(Icons.send),
  //                 onPressed: _isComposing
  //                      ? () => addMessage(_textController.text) : null,
  //               ) 
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // void _handleSubmitted(String text){
  //   _textController.clear();
  //   setState(() {
  //     _isComposing = false;
  //   });
  //   Map<String, dynamic> chatMessageMap = {
  //       "sendBy": widget.myName,
  //       "message": text,
  //       'time': DateTime
  //           .now()
  //           .millisecondsSinceEpoch,
  //     };

  //     DataBaseService().addMessage(widget.chatRoomId, chatMessageMap);
    
  // }



// final ThemeData kIOSTheme = new ThemeData(
//   primarySwatch: Colors.teal,
//   primaryColor: Colors.teal[200],
//   primaryColorBrightness: Brightness.light,
// );

// final ThemeData KDefaultTheme = new ThemeData(
//   primarySwatch: Colors.teal,
//   accentColor: Colors.teal[200],
// );