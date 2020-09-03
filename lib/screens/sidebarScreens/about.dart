// import 'dart:js';

import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/sidebarConstants.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // appBar: new AppBar(
        //     title:
        //         new Text("About", style: TextStyle(fontFamily: 'GoogleSans')),
        //     backgroundColor: AppColors.COLOR_TEAL_LIGHT),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 32),
                    // Row(
                    //   children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(height: 25),
                    Text("Our Vision",
                        style: TextStyle(
                            fontFamily: 'GoogleSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 32)),
                    // SizedBox(height: 8),
                    new Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      child: Text(
                        SidebarConstants.aboutSoc,
                        style:
                            TextStyle(fontSize: 16.0, fontFamily: 'GoogleSans'),
                      ),
                    ),
                    // new Mycard1(),
                    // new Mycard2(),
                    // new Mycard3(),
                    // new Mycard4(),

                    Row(
                      children: [
                        _buildCard(context, "Nitasha Dhingra",
                            "assets/images/bg2.jpg", "url", 1),
                        _buildCard(context, "Nitasha Dhingra",
                            "assets/images/bg2.jpg", "url", 2),
                      ],
                    ),
                    Row(
                      children: [
                        _buildCard(context, "Nitasha Dhingra",
                            "assets/images/bg2.jpg", "url", 3),
                        _buildCard(context, "Nitasha Dhingra",
                            "assets/images/bg2.jpg", "url", 4),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    )
                  ],
                ))));
  }
}

Widget _buildCard(
    BuildContext context, String name, String img, String link, int index) {
  return Container(
    width: MediaQuery.of(context).size.width / 2.22,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 23,
          ),
          Align(
              alignment: Alignment.center,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black12,
                    image: DecorationImage(
                      image: new AssetImage(img),
                    )),
              )),
          SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              name,
              style: TextStyle(
                  fontFamily: 'GoogleSans',
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                  fontSize: 18),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "this is my vision",
              style: TextStyle(
                  fontFamily: 'GoogleSans',
                  fontStyle: FontStyle.italic,
                  color: AppColors.PROTEGE_GREY,
                  fontSize: 12),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                onPressed: () => link,
                // padding: EdgeInsets.fromLTRB(20, 35, 20, 14),
                child: Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white),
                  child: Center(
                      child: Text(
                    "Connect",
                    style: TextStyle(
                        fontFamily: 'GoogleSans',
                        fontWeight: FontWeight.w200,
                        fontSize: 14,
                        color: Colors.grey),
                  )),
                ),
              ))
        ],
      ),
      // margin: index.isEven
      //     ? EdgeInsets.fromLTRB(10, 0, 25, 10)
      //     : EdgeInsets.fromLTRB(25, 0, 10, 10),
    ),
  );
}

class Mycard1 extends StatelessWidget {
  int num;
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 22.0,
        ),
        child: new Stack(
          children: <Widget>[card1, thumbnail1],
        ));
  }
}

class Mycard2 extends StatelessWidget {
  int num;
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 22.0,
        ),
        child: new Stack(
          children: <Widget>[card2, thumbnail2],
        ));
  }
}

class Mycard3 extends StatelessWidget {
  int num;
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 22.0,
        ),
        child: new Stack(
          children: <Widget>[card3, thumbnail3],
        ));
  }
}

class Mycard4 extends StatelessWidget {
  int num;
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 22.0,
        ),
        child: new Stack(
          children: <Widget>[card4, thumbnail4],
        ));
  }
}

final thumbnail1 = new Container(
  margin: new EdgeInsets.symmetric(vertical: 16.0),
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
  padding: EdgeInsets.only(left: 25.0),
  height: 124.0,
  margin: new EdgeInsets.only(left: 46.0),
  child: Center(
      child: Text(
    SidebarConstants.founderUrvi,
    style: TextStyle(
        fontSize: 15.0,
        fontFamily: 'GoogleSans',
        color: AppColors.PROTEGE_GREY),
  )),
  decoration: new BoxDecoration(
    color: AppColors.PROTEGE_CYAN,
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
  margin: new EdgeInsets.symmetric(vertical: 16.0),
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
  padding: EdgeInsets.only(left: 25.0),
  height: 124.0,
  margin: new EdgeInsets.only(left: 46.0),
  child: Center(
      child: Text(
    SidebarConstants.founderNitasha,
    style: TextStyle(
        fontSize: 15.0,
        fontFamily: 'GoogleSans',
        color: AppColors.PROTEGE_GREY),
  )),
  decoration: new BoxDecoration(
    color: AppColors.PROTEGE_CYAN,
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
  margin: new EdgeInsets.symmetric(vertical: 16.0),
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
  padding: EdgeInsets.only(left: 25.0),
  height: 124.0,
  margin: new EdgeInsets.only(left: 46.0),
  child: Center(
      child: Text(
    SidebarConstants.founderOshin,
    style: TextStyle(
        fontSize: 15.0,
        fontFamily: 'GoogleSans',
        color: AppColors.PROTEGE_GREY),
  )),
  decoration: new BoxDecoration(
    color: AppColors.PROTEGE_CYAN,
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
  margin: new EdgeInsets.symmetric(vertical: 16.0),
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
  padding: EdgeInsets.only(left: 25.0),
  height: 124.0,
  margin: new EdgeInsets.only(left: 46.0),
  child: Center(
      child: Text(
    SidebarConstants.founderSuhani,
    style: TextStyle(
        fontSize: 15.0,
        fontFamily: 'GoogleSans',
        color: AppColors.PROTEGE_GREY),
  )),
  decoration: new BoxDecoration(
    color: AppColors.PROTEGE_CYAN,
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
