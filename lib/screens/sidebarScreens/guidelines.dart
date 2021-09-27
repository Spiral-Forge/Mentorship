import 'package:dbapp/constants/colors.dart';
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
                              size: 27,
                            ),
                          )
                        ]),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            guidelineListMentors[index],
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Quicksand',
                                fontSize: 13),
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
                              size: 27,
                            ),
                          )
                        ]),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(guidelineListMentees[index],
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Quicksand',
                                  fontSize: 13)),
                        ))
                      ],
                    );
                  }
                })));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(children: [
      Positioned(
        right: 0,
        child: Image(
          image: AssetImage('assets/images/lightUpperRightPlant.png'),
        ),
      ),
      Positioned(
        left: 0,
        bottom: 0,
        child: Image(
          image: AssetImage('assets/images/Plants.png'),
        ),
      ),
      Column(children: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.only(left: 11, top: 9),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            size: 39,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Text("Code of Conduct",
                            style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w700,
                                fontSize: 27)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      new Container(
                          child: Text("For Mentors",
                              style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.COLOR_TURQUOISE,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic))),
                      guidelineList(true),
                      SizedBox(
                        height: 20,
                      ),
                      new Container(
                          child: Text("For Mentees",
                              style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.COLOR_TURQUOISE,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic))),
                      guidelineList(false),
                    ])))
      ]),
    ]));
  }
}
