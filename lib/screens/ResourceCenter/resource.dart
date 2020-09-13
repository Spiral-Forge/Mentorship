import 'package:dbapp/constants/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dbapp/blocs/values.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceTile extends StatelessWidget {
  final String resourceName;
  final String link;

  ResourceTile(this.resourceName, this.link);

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;
    return Container(
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  // color: Hexcolor('#eae8e0'),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: themeFlag ? Colors.white : AppColors.PROTEGE_GREY),
                  child: ExpansionTile(
                      // trailing: Icon(Icons.more),
                      title: Text(resourceName,
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'GoogleSans',
                              color: themeFlag ? Colors.black : Colors.white)),
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
