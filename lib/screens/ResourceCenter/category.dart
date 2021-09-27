import 'package:dbapp/blocs/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResourceCategoryTile extends StatelessWidget {
  final String categoryName;
  final String imagePath;

  ResourceCategoryTile(this.categoryName, this.imagePath);

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    return Container(
        child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1,
                  color: themeFlag
                      ? Colors.white
                      : Color(
                          0xffE8E8E8,
                        )),
              borderRadius: BorderRadius.circular(11.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(imagePath),
                    radius: MediaQuery.of(context).size.width / 6,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.4,
                  child: ListTile(
                    title: Center(
                        child: Text(
                      categoryName,
                      style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    )),
                  ),
                )
              ],
            )));
  }
}
