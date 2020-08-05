import 'package:chatApp/common/constants.dart';
import 'package:flutter/material.dart';


class Guidelines extends StatelessWidget {
  final List guidelinelist=["Lorem Ipsum is simply dummy text of the printin.Lorem Ipsum is simply dummy text of the printin.Lorem Ipsum is simply dummy text of the printin.Lorem Ipsum is simply dummy text of the printin.Lorem Ipsum is simply dummy text of the printin.Lorem Ipsum is simply dummy text of the printin.Lorem Ipsum is simply dummy text of the printin.Lorem Ipsum is simply dummy text of the printin.","Guideline2","Guideline3","Guideline4","guideline5S","Guideline2","Guideline3","Guideline4","guideline5S","Guideline2","Guideline3","Guideline4","guideline5S","Guideline2","Guideline3","Guideline4","guideline5S","Guideline2","Guideline3","Guideline4","guideline5S"];

  Widget guidelineList(){
      return Center(
        child: Container(
            child:ListView.builder(
            itemCount: guidelinelist.length+1,
            itemBuilder: (context,index){
              if(index==0){
                return Container(
                  padding: EdgeInsets.all(40.0),
                  child:Text("Lorem Ipsum is simply dummy text of the printin.",style: headingDecoration,)
                );
              }
              else{
                return Container(
                  padding: EdgeInsets.symmetric(horizontal:20.0,vertical:20.0),
                  child:Text((index).toString()+". "+guidelinelist[index-1])
                );
              }
            }
            ),
        )
      );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Guidelines"), backgroundColor: Colors.redAccent),
      body: guidelineList()
      // Container(
      //   padding: EdgeInsets.symmetric(horizontal:20.0,vertical:10.0),
      //   child: Center(
      //     child: Column(
      //       children:<Widget>[
      //         Text("Code Of Conduct for Mentors and Mentees",style:headingDecoration),
      //         SizedBox(height:20.0),
      //         Text("1. orem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an"),
      //         SizedBox(height:10.0),
      //         Text("Guideline 2"),
      //         SizedBox(height:10.0),
      //         Text("Guideline 3"),
      //         SizedBox(height:10.0),
      //         Text("Guideline 4"),
      //         SizedBox(height:10.0),
      //         Text("Guideline 5"),
      //         SizedBox(height:10.0),
      //         Text("Guideline 2"),
      //         SizedBox(height:10.0),
      //         Text("Guideline 3"),
      //         SizedBox(height:10.0),
      //         Text("Guideline 4"),
      //         SizedBox(height:10.0),
      //         Text("Guideline 5"),
      //         SizedBox(height:10.0),
      //         Text("Guideline 2"),
      //         SizedBox(height:10.0),
      //         Text("Guideline 3"),
      //         SizedBox(height:10.0),
      //         Text("Guideline 4"),
      //         SizedBox(height:10.0),
      //         Text("Guideline 5"),
      //         SizedBox(height:10.0),
      //         Text("Guideline 2"),
      //         SizedBox(height:10.0),
      //         Text("Guideline 3"),
      //         SizedBox(height:10.0),
      //         Text("Guideline 4"),
      //         SizedBox(height:10.0),
      //         Text("Guideline 5"),
      //       ]
      //     ),
      //   ),
      // )
      // new Center(
      //   child: Text("Code of conduct for mentors and mentees"),
      // ),
    );
  }
}