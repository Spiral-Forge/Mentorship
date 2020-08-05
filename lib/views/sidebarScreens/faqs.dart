import 'package:flutter/material.dart';

class FAQS extends StatelessWidget {

final List faqlist=["fffffffffffffffff","aLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, 1","q2","a2","q3","ans3","q4","q5","1","2","q1","a1","q2","a2","q3","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, ","q4","q5","1","2","q1","a1","q2","a2","q3","ans3","q4","q5","1","2"];
 Widget faqList(){
      return Center(
        child: Container(
            child:ListView.builder(
            itemCount: faqlist.length+1,
            itemBuilder: (context,index){
              if(index==0){
                  return Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal:20.0,vertical:20.0),
                      child:Text("FAQS")
                    ),
                  );

              }
              else if((index-1)%2==0){
                return Container(
                  padding: EdgeInsets.symmetric(horizontal:10.0,vertical:10.0),
                  margin: EdgeInsets.only(left:10.0,right:10.0),
                  color: Colors.blueGrey,
                  child: Center(
                    child: Text(faqlist[index-1]) ,
                  ),
                  );

                // return Container(
                //   padding: EdgeInsets.all(40.0),
                //   child:Text("Lorem Ipsum is simply dummy text of the printin.")
                // );
              }
              else{
                 return Container(
                   padding: EdgeInsets.symmetric(horizontal:10.0,vertical:10.0),
                  margin: EdgeInsets.only(bottom:20.0,left:10.0,right:10.0),
                  color: Colors.grey,
                  child: Center(
                    child: Text(faqlist[index-1]) ,
                  ),
                  );
                // return Container(
                //   padding: EdgeInsets.symmetric(horizontal:20.0,vertical:20.0),
                //   child:Text((index).toString()+". "+faqlist[index-1])
                // );
              }
            }
            ),
        )
      );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("FAQs"), backgroundColor: Colors.redAccent),
     body:  faqList()
    );
  }
} 