import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/sidebarConstants.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/styles.dart';


class Guidelines extends StatelessWidget {
  final List guidelinelist=SidebarConstants.guidelines;

  Widget guidelineList(){
      return Center(
        child: Container(
            child:ListView.builder(
            itemCount: guidelinelist.length+1,
            itemBuilder: (context,index){
              if(index==0){
                return Container(
                  padding: EdgeInsets.all(40.0),
                  child:Text("Guildelines for Mentors and Mentees",style: headingDecoration,)
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
      appBar: new AppBar(title: new Text("Guidelines"), backgroundColor: AppColors.COLOR_TEAL_LIGHT),
      body: guidelineList()
    );
  }
}