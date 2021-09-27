import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/sidebarConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
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
            child: Container(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 27, 0, 0),
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
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.fromLTRB(27, 0, 0, 0),
              child: Text("Our Vision",
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w700,
                      fontSize: 27)),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 25.0),
                      child: Text(
                        SidebarConstants.aboutSoc,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.4,
                          child: Container(
                            child: _buildCard(
                                context,
                                SidebarConstants.nitasha["Name"],
                                SidebarConstants.nitasha["Image"],
                                SidebarConstants.nitasha["LinkedIN"],
                                1),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.4,
                          child: Container(
                            child: _buildCard(
                                context,
                                SidebarConstants.suhani["Name"],
                                SidebarConstants.suhani["Image"],
                                SidebarConstants.suhani["LinkedIN"],
                                2),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.4,
                          child: Container(
                            child: _buildCard(
                                context,
                                SidebarConstants.urvi["Name"],
                                SidebarConstants.urvi["Image"],
                                SidebarConstants.urvi["LinkedIN"],
                                3),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.4,
                          child: Container(
                            child: _buildCard(
                                context,
                                SidebarConstants.oshin["Name"],
                                SidebarConstants.oshin["Image"],
                                SidebarConstants.oshin["LinkedIN"],
                                4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        )))
      ]),
    ]));
  }
}

Widget _buildCard(
    BuildContext context, String name, String img, String link, int index) {
  ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
  var themeFlag = _themeNotifier.darkTheme;
  return Container(
    width: MediaQuery.of(context).size.width / 3,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        child: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.center,
                child: Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black12,
                      image: DecorationImage(
                        image: new AssetImage(img),
                      )),
                )),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                name,
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                    color: AppColors.COLOR_TURQUOISE,
                    fontSize: 13),
              ),
            ),
            Center(
                child: TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () => launch(link),
              child: Text(
                "Connect",
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: themeFlag ? Colors.white : Colors.grey),
              ),
            )),
          ],
        ),
      ),
    ),
  );
}
