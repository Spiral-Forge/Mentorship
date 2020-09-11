import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/sidebarConstants.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dbapp/shared/styles.dart';

class Guidelines extends StatefulWidget {
  @override
  _GuidelinesState createState() => _GuidelinesState();
}

class _GuidelinesState extends State<Guidelines>
    with SingleTickerProviderStateMixin {
  final List guidelineListMentors = SidebarConstants.guidelinesMentors;
  final List guidelineListMentees = SidebarConstants.guidelinesMentees;

  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // appBar: new AppBar(
        //     title:
        //         new Text("About", style: TextStyle(fontFamily: 'GoogleSans')),
        //     backgroundColor: AppColors.COLOR_TEAL_LIGHT),
        // backgroundColor: Colors.white,
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: new Column(
                  children: [],
                ))));
  }
}
// Widget guidelineList(bool isMentors) {
//   return Expanded(
//       child: SizedBox(
//           height: 100.0,
//           child: ListView.builder(
//               itemCount: guidelineListMentors.length,
//               itemBuilder: (context, index) {
//                 if (isMentors) {
//                   return Row(
//                     children: [
//                       Column(children: [
//                         Align(
//                           alignment: Alignment.center,
//                           child: Icon(
//                             Icons.arrow_right,
//                             size: 30,
//                           ),
//                         )
//                       ]),
//                       Expanded(
//                           child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           guidelineListMentors[index],
//                           style: TextStyle(
//                               fontFamily: 'GoogleSans', fontSize: 18),
//                         ),
//                       ))
//                     ],
//                   );
//                   // return Container(
//                   //     // padding: EdgeInsets.symmetric(
//                   //     //     horizontal: 32.0, vertical: 8.0),
//                   //     margin: EdgeInsets.symmetric(
//                   //         vertical: 5.0, horizontal: 10.0),
//                   //     child: );
//                 } else {
//                   return Container(
//                       // padding: EdgeInsets.symmetric(
//                       //     horizontal: 32.0, vertical: 8.0),
//                       margin: EdgeInsets.symmetric(
//                           vertical: 5.0, horizontal: 10.0),
//                       child: Text(guidelineListMentees[index],
//                           style: TextStyle(
//                               fontFamily: 'GoogleSans', fontSize: 18)));
//                 }
//               })));
// }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//       body: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Padding(
//               padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
//               child: new Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     SizedBox(height: 32),
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(32, 32, 0, 0),
//                       child: IconButton(
//                         icon: Icon(Icons.arrow_back),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 25),
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
//                       child: Text("Frequently Asked Questions",
//                           style: TextStyle(
//                               fontFamily: 'GoogleSans',
//                               fontWeight: FontWeight.bold,
//                               fontSize: 32)),
//                     ),

// Padding(
//   padding: EdgeInsets.only(top: 20),
//   child: TabBar(
//     controller: tabController,
//     indicatorColor: Colors.transparent,
//     labelColor: AppColors.COLOR_TEAL_LIGHT,
//     unselectedLabelColor: Colors.grey.withOpacity(0.6),
//     isScrollable: true,
//     tabs: <Widget>[
//       Tab(
//           child: Text("For Mentors",
//               style: TextStyle(
//                 fontFamily: 'GoogleSans',
//                 fontWeight: FontWeight.bold,
//                 // color: Hexcolor('#d89279'),
//                 fontSize: 25,
//                 // fontStyle: FontStyle.italic
//               ))),
//       Tab(
//           child: Text("For Mentees",
//               style: TextStyle(
//                 fontFamily: 'GoogleSans',
//                 fontWeight: FontWeight.bold,
//                 // color: Hexcolor('#d89279'),
//                 fontSize: 25,
//                 // fontStyle: FontStyle.italic
//               ))),
//     ],
//   ),
// ),
// Container(
//   child: TabBarView(controller: tabController, children: [
// guidelineList(true),
// guidelineList(false),
// ]),
// )
// ]))

// new Container(
//     margin: EdgeInsets.symmetric(
//         vertical: 20.0, horizontal: 10.0),
//     child: Text("For Mentors",
//         style: TextStyle(
//             fontFamily: 'GoogleSans',
//             fontWeight: FontWeight.bold,
//             color: Hexcolor('#d89279'),
//             fontSize: 25,
//             fontStyle: FontStyle.italic))),
// guidelineList(true),
// new Container(
//     margin: EdgeInsets.symmetric(
//         vertical: 20.0, horizontal: 10.0),
//     child: Text("For Mentees",
//         style: TextStyle(
//             fontFamily: 'GoogleSans',
//             fontWeight: FontWeight.bold,
//             color: Hexcolor('#d89279'),
//             fontSize: 25,
//             fontStyle: FontStyle.italic))),
// guidelineList(false),
// ])
//             ));
//   }
// }
