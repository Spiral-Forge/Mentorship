import 'package:dbapp/screens/ResourceCenter/resource.dart';
import 'package:flutter/material.dart';

final List resourcesList=["fffffffffffffffff","aLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, 1","q2","a2","q3","ans3","q4","q5","1","2","q1","a1","q2","a2","q3","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, ","q4","q5","1","2","q1","a1","q2","a2","q3","ans3","q4","q5","1","2"];
 Widget resourceList(){
      return Center(
        child: Container(
            child:ListView.builder(
            itemCount: resourcesList.length,
            itemBuilder: (context,index){
              return ResourceTile(resourcesList[index], "def");
            }
            ),
        )
      );
  }

class ResourceList extends StatefulWidget {
  final String resourceField;
  ResourceList(this.resourceField);
  @override
  _ResourceListState createState() => _ResourceListState();
}
class _ResourceListState extends State<ResourceList> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.resourceField), 
        backgroundColor: Colors.teal
      ),
     body:  resourceList()
    );
  }
}