import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/sidebarConstants.dart';
import 'package:flutter/material.dart';

class FAQS extends StatelessWidget {
  final List faqlist = SidebarConstants.faqQuestionAnswers;
  Widget faqList() {
    return Center(
        child: Container(
      child: ListView.builder(
          itemCount: faqlist.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Center(
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  // child:Text("FAQS")
                ),
              );
            } else if ((index - 1) % 2 == 0) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                color: AppColors.PROTEGE_GREY,
                child: Center(
                  child: Text(
                    faqlist[index - 1],
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'GoogleSans'),
                  ),
                ),
              );

              // return Container(
              //   padding: EdgeInsets.all(40.0),
              //   child:Text("Lorem Ipsum is simply dummy text of the printin.")
              // );
            } else {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                margin: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
                color: AppColors.PROTEGE_CYAN,
                child: Center(
                  child: Text(faqlist[index - 1],
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'GoogleSans')),
                ),
              );
              // return Container(
              //   padding: EdgeInsets.symmetric(horizontal:20.0,vertical:20.0),
              //   child:Text((index).toString()+". "+faqlist[index-1])
              // );
            }
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text(
              "FAQs",
              style: TextStyle(fontFamily: 'GoogleSans'),
            ),
            backgroundColor: AppColors.COLOR_TEAL_LIGHT),
        body: faqList());
  }
}
