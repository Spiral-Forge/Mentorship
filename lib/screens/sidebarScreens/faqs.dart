import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/sidebarConstants.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';

class FAQS extends StatefulWidget {
  @override
  _FAQSState createState() => _FAQSState();
}

class _FAQSState extends State<FAQS> {
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
              return Column(
                children: [
                  CustomExpansionTile(
                    title: faqlist[index - 1],
                    desc: faqlist[index],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  )
                ],
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(31, 29, 0, 0),
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
                      SizedBox(height: 10),
                      Center(
                        child: Text("FAQ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w700,
                                fontSize: 48)),
                      ),
                      faqList()
                    ],
                  ))))
    ]));
  }
}

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final String desc;

  const CustomExpansionTile({Key key, this.title, this.desc}) : super(key: key);

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          backgroundColor: themeFlag
              ? null
              : isExpanded
                  ? AppColors.COLOR_TURQUOISE
                  : null,
        ),
        child: ExpansionTile(
          trailing: Icon(
            isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            size: 20,
            color: themeFlag
                ? isExpanded
                    ? Colors.black
                    : Colors.white
                : Colors.black,
          ),
          backgroundColor: themeFlag
              ? null
              : isExpanded
                  ? AppColors.COLOR_TURQUOISE
                  : null,
          title: Text(
            widget.title,
            style: TextStyle(
              color: themeFlag
                  ? isExpanded
                      ? AppColors.COLOR_TURQUOISE
                      : Colors.white
                  : Colors.black,
              fontFamily: 'Googlesans',
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              fontSize: 15,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.desc,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            )
          ],
          onExpansionChanged: (expanded) {
            isExpanded = expanded;
            setState(() {});
          },
        ),
      ),
    );
  }
}
