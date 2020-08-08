
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbapp/screens/ResourceCenter/resource.dart';
import 'package:dbapp/services/database.dart';
import 'package:flutter/material.dart';



class ResourceList extends StatefulWidget {
  final String resourceField;
  final String collectionName;
  ResourceList(this.resourceField,this.collectionName);
  @override
  _ResourceListState createState() => _ResourceListState();
}


class _ResourceListState extends State<ResourceList> {
  final _formKey = GlobalKey<FormState>();
  List<DocumentSnapshot> resourcesList=[];

  @override
  void initState(){
    DataBaseService().getCurrentCollectionData(widget.collectionName).then((value){
      print("getting data");
      print(value.documents[0].data.runtimeType);
      setState(() {
        resourcesList=value.documents;
        //print(resourcesList.length);
      });
      
    });
    super.initState();
  }

  
  Widget resourceList(){
        return Center(
          child: Container(
              child:ListView.builder(
              itemCount: resourcesList.length,
              itemBuilder: (context,index){
                return ResourceTile(resourcesList[index].data["Title"], resourcesList[index].data["Link"]);
              }
              ),
          )
        );
    }
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