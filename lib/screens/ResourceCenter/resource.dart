import 'package:flutter/material.dart';

class ResourceTile extends StatelessWidget {
 final String resourceName;
 final String link;


  ResourceTile(this.resourceName,this.link);

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
            Container(
              width: MediaQuery.of(context).size.width,
              child: 
              ExpansionTile(
                // trailing: Icon(Icons.more),
                title: Center(child: Text(resourceName,style: TextStyle(fontSize: 15))),
                //subtitle: Center(child: Text("link here")),
                children: <Widget>[
                  Text(link)
                ]
                
                ),
            ),
          ],
          )
      )
    );
  }
}