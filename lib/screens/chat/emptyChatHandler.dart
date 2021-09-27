import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/shared/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EmptyChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    final myDrawer _drawer = new myDrawer();
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
                          padding: const EdgeInsets.fromLTRB(19.0, 30, 0, 0),
                          child: Row(children: [
                            IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  size: 28,
                                  color:
                                      themeFlag ? Colors.white : Colors.black,
                                ),
                                onPressed: () {
                                  _scaffoldKey.currentState.openDrawer();
                                }),
                            Text(
                              "Chat Room",
                              style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      themeFlag ? Colors.white : Colors.black),
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
                                            image: new AssetImage(
                                                'assets/images/wait_for_it.png')))),
                              ),
                            ),
                            Text(
                              "WAIT FOR IT...",
                              style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 37,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ))
                      ]))))
        ]));
  }
}
