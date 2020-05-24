import 'package:flutter/material.dart';
import 'package:dbapp/services/auth.dart';
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
   final AuthService _auth=AuthService();
   bool loading=true;
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
                  child:Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.")
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
                )
            );
            this.setState((){
              eventlist=templist;
              loading=false;
            });
          }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("myapp"),
        backgroundColor:Colors.teal[300] ,
        elevation: Theme.of(context).platform== TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
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
              title: new Text("Guidelines"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Guidelines()));
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
              title: new Text("Logout"),
              trailing: new Icon(Icons.people),
              onTap: () async => await _auth.signOut()
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

  EventTile({@required this.name,this.date, this.time, this.venue,this.description});

  @override 
  Widget build(BuildContext context){
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
                  image: AssetImage("assets/images/bg2.jpg")
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
