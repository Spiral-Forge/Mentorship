import 'package:dbapp/blocs/theme.dart';
import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/screenConstants.dart';
import 'package:dbapp/screens/profile/peerProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:dbapp/screens/sidebarScreens/about.dart';
import 'package:dbapp/screens/sidebarScreens/faqs.dart';
import 'package:dbapp/screens/sidebarScreens/feedback.dart';
import 'package:dbapp/screens/sidebarScreens/guidelines.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/shared/loading.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   final FirebaseAuth _authUser = FirebaseAuth.instance;
  final AuthService _auth=AuthService();
   bool loading=true;
   String post;
   bool postFlag=false;
   static List<dynamic> peerID=[];
   List fixedList = Iterable<int>.generate(peerID.length).toList();
    Future<FirebaseUser> getCurrentUser(){
      return _authUser.currentUser();
    }

   List<EventTile> eventlist=[];
    Widget eventList(){
      return loading ? Loading() : 
      Center(
        child: Container(
          width: 350.0,
            child:ListView.builder(
             shrinkWrap: true,
            itemCount: eventlist.length+2,
            itemBuilder: (context,index){
              if(index==0){
                return Container(
                  padding: EdgeInsets.all(40.0),
                  child:Text(ScreenConstants.homepageText)
                );
              }else if(index==1){
                return Center(
                  child: Container(
                    child:Text("OUR EVENTS")
                  ),
                );
              }else{
                return eventlist[index-2];
              }
            }
            ),
        )
      );
     }
  void initState(){
    super.initState();
    DataBaseService().getEvents().then((val){
      print(val.documents[0].data);
      List<EventTile> templist=[];
          for(var i=0;i<val.documents.length;i++){
            templist.add(
              EventTile(
                name:val.documents[i].data["name"],
                date:val.documents[i].data["date"],
                time:val.documents[i].data["time"],
                venue:val.documents[i].data["venue"],
                description:val.documents[i].data["description"] ,
                url:val.documents[i].data["url"]
                )
            );
            this.setState((){
              eventlist=templist;
              loading=false;
            });
          }
          setPost();
    });
  }

  void setPost() async{
    FirebaseUser user= await getCurrentUser();
    DataBaseService().getPeerData(user.uid).then((value){
      setState(() {
        post=value.data["post"];
        postFlag=true;
        peerID=value.data["peerID"]!=null ? value.data["peerID"] : [];
      });
      //print("this already happened");
    });
    // await StorageServices.getUserPost().then((value) {
      
    // });
  }

  var _darkTheme = true;

  @override
  Widget build(BuildContext context) {

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    // final _themeChanger = Provider.of<ThemeChanger>(context);
    _darkTheme = (_themeChanger.getTheme() == darkTheme);

    return Scaffold(
      appBar: AppBar(
        title:Text("Protege"),
        backgroundColor:AppColors.COLOR_TEAL_LIGHT,
        elevation: Theme.of(context).platform== TargetPlatform.iOS ? 0.0 : 4.0,
        actions: peerID.length<=1 ? <Widget>[
          FlatButton.icon(
            onPressed: () async{
             //add navigation to edit profile page
             Navigator.push(context, MaterialPageRoute(builder: (context)=> PeerProfile(post,peerID.length==0 ? null:peerID[0])));
            }, 
            icon: postFlag==true ? Icon(Icons.person,color: Colors.white,):Icon(null),
            label:Text(postFlag==true ? post=="Mentor" ? 'Know your mentee':'Know your mentor':"",style: TextStyle(color:Colors.white),)
            )
        ] :
         <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => Navigator.push(context,MaterialPageRoute(builder: (context)=>PeerProfile(post,value))),
            itemBuilder: (BuildContext context){
              return fixedList.map((index){
                return PopupMenuItem<String>(
                  value: peerID[index],
                  child: Text("View mentee "+(index+1).toString()+" profile"),
                );
              }).toList();
            },
          )
        ],

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
              //             color: AppColors.PROTEGE_GREY,
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
              onTap: () async {
                await _auth.signOut();
              }
            ),
          ],
        ),
      ),
      body: eventList()
    );
  }
}


class EventTile extends StatelessWidget {
 final String name;
  final String date;
  final String time;
  final String venue;
  final String description;
  final String url;

  EventTile({@required this.name,this.date, this.time, this.venue,this.description,this.url});
  
  @override 
  Widget build(BuildContext context){
    print(url);
    return Container(
      child:Card(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        ),
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height:210.0,
              decoration: BoxDecoration(
                image:DecorationImage(
                  fit:BoxFit.fill,
                  image: NetworkImage(url)
                  //AssetImage("assets/images/bg2.jpg")
                 )
              ),
            )
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: ExpansionTile(
                // trailing: Icon(Icons.more),
                title: Center(child: Text(name)),
                subtitle: Center(child: Text("Date: "+date+"\nTime: "+time+"\nWhere: "+venue)),
                
                children: <Widget>[
                  Text(description)
                ],
                ),
            )
          ],
          )
      )
    );
  }
}

void onThemeChanged(bool value, ThemeChanger _themeChanger) async {
  (value) ? _themeChanger.setTheme(darkTheme) : _themeChanger.setTheme(lightTheme);
}

