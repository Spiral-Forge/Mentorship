import 'package:dbapp/blocs/values.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
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
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                        trailing: Icon(
                          Icons.arrow_drop_down_sharp,
                          size: 20,
                          color: themeFlag ? Colors.white : Colors.black,
                        ),
                        title: Text(resourceName,
                            style: TextStyle(
                              color: themeFlag ? Colors.white : null,
                              fontSize: 18,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w400,
                            )),
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
                                            ..onTap = () async {
                                              if (await canLaunch(link)) {
                                                await launch(link);
                                              } else {
                                                Toast.show(
                                                    "Could not launch $link",
                                                    context,
                                                    duration:
                                                        Toast.LENGTH_SHORT,
                                                    gravity: Toast.BOTTOM);
                                              }
                                            },
                                        ),
                                      ],
                                    ),
                                  )))
                        ]),
                  ),
                ),
              ],
            )));
  }
}
