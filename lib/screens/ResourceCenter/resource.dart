import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceTile extends StatelessWidget {
  final String resourceName;
  final String link;

  ResourceTile(this.resourceName, this.link);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ExpansionTile(
                      // trailing: Icon(Icons.more),
                      title: Center(
                          child: Text(resourceName,
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'GoogleSans'))),
                      //subtitle: Center(child: Text("link here")),
                      children: <Widget>[
                        new Center(
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                                child: new RichText(
                                  text: new TextSpan(
                                    children: [
                                      new TextSpan(
                                        text: link,
                                        style:
                                            new TextStyle(color: Colors.blue),
                                        recognizer: new TapGestureRecognizer()
                                          ..onTap = () {
                                            launch(link);
                                          },
                                      ),
                                    ],
                                  ),
                                )))
                      ]),
                ),
              ],
            )));
  }
}
