import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/sidebarConstants.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../constants/colors.dart';

class FAQS extends StatelessWidget {
  final List faqlist = SidebarConstants.faqQuestionAnswers;
  Widget faqList() {
    return Expanded(
        child: SizedBox(
      height: 120.0,
      child: ListView.builder(
          itemCount: faqlist.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Center(child: Container());
            } else if ((index - 1) % 2 == 0) {
              return Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                decoration: BoxDecoration(
                    color: AppColors.colorTealLight,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 150,
                        minHeight: 35,
                      ),
                      child: Text(
                        faqlist[index - 1],
                        style: TextStyle(
                            color: Hexcolor("#303030"),
                            fontFamily: 'GoogleSans',
                            fontSize: 18,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 150,
                        minHeight: 35,
                      ),
                      child: Text(
                        faqlist[index],
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'GoogleSans',
                            fontSize: 18,
                            fontWeight: FontWeight.w200),
                      ),
                    ),
                  ),
                ]),
              );
            } else {
              return Center(
                  child: Container(
                margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              ));
            }
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Column(children: [
      Expanded(
          child: Container(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32),
                      Padding(
                        padding: EdgeInsets.fromLTRB(32, 32, 0, 0),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
                        child: Text("Frequently Asked Questions",
                            style: TextStyle(
                                fontFamily: 'GoogleSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 32)),
                      ),
                      faqList()
                    ],
                  ))))
    ]));
  }
}
