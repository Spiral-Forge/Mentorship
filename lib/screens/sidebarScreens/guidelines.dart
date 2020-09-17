import 'package:dbapp/constants/sidebarConstants.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Guidelines extends StatelessWidget {
  final List guidelineListMentors = SidebarConstants.guidelinesMentors;
  final List guidelineListMentees = SidebarConstants.guidelinesMentees;

  Widget guidelineList(bool isMentors) {
    return Expanded(
        child: SizedBox(
            height: 100.0,
            child: ListView.builder(
                itemCount: guidelineListMentors.length,
                itemBuilder: (context, index) {
                  if (isMentors) {
                    return Row(
                      children: [
                        Column(children: [
                          Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.arrow_right,
                              size: 30,
                            ),
                          )
                        ]),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            guidelineListMentors[index],
                            style: TextStyle(
                                fontFamily: 'GoogleSans', fontSize: 16),
                          ),
                        ))
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Column(children: [
                          Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.arrow_right,
                              size: 30,
                            ),
                          )
                        ]),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            guidelineListMentees[index],
                            style: TextStyle(
                                fontFamily: 'GoogleSans', fontSize: 16),
                          ),
                        ))
                      ],
                    );
                  }
                })));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Column(children: [
      Expanded(
          child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 32),
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(height: 25),
                    Text("Code of Conduct",
                        style: TextStyle(
                            fontFamily: 'GoogleSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 32)),
                    new Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: Text("For Mentors",
                            style: TextStyle(
                                fontFamily: 'GoogleSans',
                                fontWeight: FontWeight.bold,
                                color: Hexcolor('#d89279'),
                                fontSize: 25,
                                fontStyle: FontStyle.italic))),
                    guidelineList(true),
                    new Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: Text("For Mentees",
                            style: TextStyle(
                                fontFamily: 'GoogleSans',
                                fontWeight: FontWeight.bold,
                                color: Hexcolor('#d89279'),
                                fontSize: 25,
                                fontStyle: FontStyle.italic))),
                    guidelineList(false),
                  ])))
    ]));
  }
}
