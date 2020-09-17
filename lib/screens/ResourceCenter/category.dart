import 'package:flutter/material.dart';

class ResourceCategoryTile extends StatelessWidget {
  final String categoryName;
  final String imagePath;

  ResourceCategoryTile(this.categoryName, this.imagePath);

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
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.4,
                      height: MediaQuery.of(context).size.width / 2.4,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill, image: AssetImage(imagePath))),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width / 2.4,
                  child: ListTile(
                    title: Center(
                        child: Text(
                      categoryName,
                      style: TextStyle(fontSize: 18, fontFamily: 'GoogleSans'),
                      textAlign: TextAlign.center,
                    )),
                  ),
                )
              ],
            )));
  }
}
