import 'package:dbapp/shared/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    final myDrawer _drawer = new myDrawer();
    return Scaffold(
      drawer: _drawer,
      key: _scaffoldKey,
      
      body:Column(children: [
        Expanded(
            child: Container(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                        children: [
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
                          Expanded(
                            child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Center(
              child: Container(
                width: 5000.0,
                height: 400.0,
                decoration: new BoxDecoration(
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new AssetImage('assets/images/wait_for_it.png')
                  )
              )),
            ),
          ),
          Text("WAIT FOR IT...",style:GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),
            )
          )
        ],
      )
                            )
                           
                        ])
                        )
                        )
                        )
        ])
    );
  }
}