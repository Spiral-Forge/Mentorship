import 'package:flutter/material.dart';
// import 'package:dbapp/screens/sidebarScreens/aboutHelper.dart';
class About extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("About"), backgroundColor: Colors.redAccent),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
              child: new Column(
          children: <Widget>[
            Center(
              child: new Container(
                margin: EdgeInsets.symmetric(vertical:20.0,horizontal:10.0),
                child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",style: TextStyle(fontSize:20.0 ),),
              ),
            ),
            new Mycard1(),
              new Mycard2(),
              new Mycard3(),
              new Mycard4(),
            // ListView(
            //   shrinkWrap: true,
            //   children: <Widget>[
                
            //   ],
            // )
           
          ],
        ),
      )
      // new Container(
      //     margin:EdgeInsets.symmetric(vertical:16.0,horizontal:20.0),
      //     child:new Stack(
      //       children: <Widget>[
      //         myCard,
      //         myimage
              
      //       ],
      //     )
      //   )
      
      
    );
  }
}

class Mycard1 extends StatelessWidget {
  int num;
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: new Stack(
        children: <Widget>[
          card1,
          thumbnail1
        ],
      )
    );
  }
}
class Mycard2 extends StatelessWidget {
  int num;
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: new Stack(
        children: <Widget>[
          card2,
          thumbnail2
        ],
      )
    );
  }
}
class Mycard3 extends StatelessWidget {
  int num;
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: new Stack(
        children: <Widget>[
          card3,
          thumbnail3
        ],
      )
    );
  }
}
class Mycard4 extends StatelessWidget {
  int num;
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: new Stack(
        children: <Widget>[
          card4,
          thumbnail4
        ],
      )
    );
  }
}
final thumbnail1 = new Container(
    margin: new EdgeInsets.symmetric(
      vertical: 16.0
    ),
    alignment: FractionalOffset.centerLeft,
    child: ClipOval(
          child: new Image(
        image: new AssetImage("assets/images/bg2.jpg"),
        height: 92.0,
        width: 92.0,
      ),
    ),
  );

  final card1 = new Container(
    padding: EdgeInsets.only(left:25.0),
    height: 124.0,
    margin: new EdgeInsets.only(left: 46.0),
    child: Center(child: Text(" Urvi Goel \n Founder \n SOMe cool line she said",style: TextStyle(fontSize:20.0),)),
    decoration: new BoxDecoration(
      color: Colors.teal,
      shape: BoxShape.rectangle,
      borderRadius: new BorderRadius.circular(8.0),
      boxShadow: <BoxShadow>[
        new BoxShadow(  
          color: Colors.black12,
          blurRadius: 10.0,
          offset: new Offset(0.0, 10.0),
        ),
      ],
    ),
  );


  final thumbnail2 = new Container(
    
    margin: new EdgeInsets.symmetric(
      vertical: 16.0
    ),
    alignment: FractionalOffset.centerLeft,
    child: ClipOval(
          child: new Image(
        image: new AssetImage("assets/images/bg2.jpg"),
        height: 92.0,
        width: 92.0,
      ),
    ),
  );

  final card2 = new Container(
     padding: EdgeInsets.only(left:25.0),
    height: 124.0,
    margin: new EdgeInsets.only(left: 46.0),
    child: Center(child: Text("Nitasha Dhingra \n Founder \n SOMe cool line she said",style: TextStyle(fontSize:20.0),)),
    decoration: new BoxDecoration(
      color: Colors.teal,
      shape: BoxShape.rectangle,
      borderRadius: new BorderRadius.circular(8.0),
      boxShadow: <BoxShadow>[
        new BoxShadow(  
          color: Colors.black12,
          blurRadius: 10.0,
          offset: new Offset(0.0, 10.0),
        ),
      ],
    ),
  );

  final thumbnail3 = new Container(
    margin: new EdgeInsets.symmetric(
      vertical: 16.0
    ),
    alignment: FractionalOffset.centerLeft,
    child: ClipOval(
          child: new Image(
        image: new AssetImage("assets/images/bg2.jpg"),
        height: 92.0,
        width: 92.0,
      ),
    ),
  );

  final card3 = new Container(
     padding: EdgeInsets.only(left:25.0),
    height: 124.0,
    margin: new EdgeInsets.only(left: 46.0),
    child: Center(child: Text("Oshin Saini \n Founder \n SOMe cool line she said",style: TextStyle(fontSize:20.0),)),
    decoration: new BoxDecoration(
      color: Colors.teal,
      shape: BoxShape.rectangle,
      borderRadius: new BorderRadius.circular(8.0),
      boxShadow: <BoxShadow>[
        new BoxShadow(  
          color: Colors.black12,
          blurRadius: 10.0,
          offset: new Offset(0.0, 10.0),
        ),
      ],
    ),
  );

  final thumbnail4 = new Container(
    margin: new EdgeInsets.symmetric(
      vertical: 16.0
    ),
    alignment: FractionalOffset.centerLeft,
    child: ClipOval(
          child: new Image(
        image: new AssetImage("assets/images/bg2.jpg"),
        height: 92.0,
        width: 92.0,
      ),
    ),
  );

  final card4 = new Container(
     padding: EdgeInsets.only(left:25.0),
    height: 124.0,
    margin: new EdgeInsets.only(left: 46.0),
    child: Center(child: Text("Suhani Chawla \n Founder \n SOMe cool line i said",style: TextStyle(fontSize:20.0),)),
    decoration: new BoxDecoration(
      color: Colors.teal,
      shape: BoxShape.rectangle,
      borderRadius: new BorderRadius.circular(8.0),
      boxShadow: <BoxShadow>[
        new BoxShadow(  
          color: Colors.black12,
          blurRadius: 10.0,
          offset: new Offset(0.0, 10.0),
        ),
      ],
    ),
  );


