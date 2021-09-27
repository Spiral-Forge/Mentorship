import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dbapp/screens/authenticate/form4.dart';
import 'package:provider/provider.dart';

String year = '';
String branch = '';
String rollNo = '';
bool hosteller;

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class RegisterForm3 extends StatefulWidget {
  //taken from parent props:
  Map<String, dynamic> userMap;
  Function toggleView;
  final bool theme;
  RegisterForm3(this.userMap, this.theme, {this.toggleView});

  @override
  _RegisterForm3State createState() => _RegisterForm3State(userMap, theme);
}

class _RegisterForm3State extends State<RegisterForm3> {
  final Map<String, dynamic> userMap;
  final bool themeFlag;
  _RegisterForm3State(this.userMap, this.themeFlag);

  final _formKey3 = GlobalKey<FormState>();

  bool loading = false;
  List<ListItem> _dropdownBranch = [
    ListItem(1, "CSE-1"),
    ListItem(2, "CSE-2"),
    ListItem(3, "CSAI"),
    ListItem(4, "IT-1"),
    ListItem(5, "IT-2"),
    ListItem(6, "ECE"),
    ListItem(7, "MAE"),
    ListItem(7, "BBA"),
    ListItem(8, "B.Arch")
  ];
  List<ListItem> _dropdownYear = [
    ListItem(1, "First"),
    ListItem(2, "Second"),
    ListItem(3, "Third"),
    ListItem(4, "Fourth")
  ];

  List<DropdownMenuItem<ListItem>> _dropdownBranchItems;
  ListItem _selectedBranch;
  List<DropdownMenuItem<ListItem>> _dropdownYearItems;
  ListItem _selectedYear;

  int _hostellerValue = -1;
  void _handleHostellerValue(int value) {
    setState(() {
      _hostellerValue = value;
      hosteller = _hostellerValue == 0;
    });
  }

  void initState() {
    super.initState();
    _dropdownYearItems = buildDropDownMenuItems(_dropdownYear);
    _dropdownBranchItems = buildDropDownMenuItems(_dropdownBranch);
    rollNo = '';
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = [];
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(
            listItem.name,
            style: TextStyle(
                fontFamily: 'Quicksand',
                color: themeFlag ? Colors.white : Color(0xff777777),
                fontSize: 15),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    return new Scaffold(
        backgroundColor: themeFlag ? AppColors.COLOR_DARK : Colors.white,
        body: loading
            ? Loading()
            : Column(children: [
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
                                      icon: Icon(
                                        Icons.arrow_back,
                                        size: 32,
                                        color: themeFlag
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 25),
                                  Expanded(
                                      child: SizedBox(
                                          child: Padding(
                                    padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                                    child: Form(
                                      key: _formKey3,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: <Widget>[
                                          new Divider(
                                              height: 35.0,
                                              color: Colors.transparent),
                                          new Text(
                                            'College information',
                                            style: TextStyle(
                                              fontFamily: 'Quicksand',
                                              fontSize: 23,
                                              fontWeight: FontWeight.w700,
                                              color: themeFlag
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          new Divider(
                                              height: 35.0,
                                              color: Colors.transparent),
                                          Theme(
                                            data: Theme.of(context).copyWith(
                                                canvasColor: themeFlag
                                                    ? Colors.black
                                                    : Colors.white),
                                            child: DropdownButton<ListItem>(
                                                iconEnabledColor: themeFlag
                                                    ? Colors.white
                                                    : Color(0xff777777),
                                                underline: Container(
                                                  height: 1,
                                                  color: themeFlag
                                                      ? Colors.white
                                                      : Color(0xff777777),
                                                ),
                                                hint: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          12.0, 0, 16, 0),
                                                  child: Text(
                                                    "Select your branch",
                                                    style: TextStyle(
                                                      fontFamily: 'Quicksand',
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: themeFlag
                                                          ? Colors.white
                                                          : Color(0xff777777),
                                                    ),
                                                  ),
                                                ),
                                                items: _dropdownBranchItems,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedBranch = value;
                                                    branch = value.name;
                                                  });
                                                },
                                                value: _selectedBranch,
                                                isExpanded: true),
                                          ),
                                          new Divider(
                                              height: 10,
                                              color: Colors.transparent),
                                          Theme(
                                            data: Theme.of(context).copyWith(
                                              canvasColor: themeFlag
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                            child: DropdownButton<ListItem>(
                                                underline: Container(
                                                  height: 1,
                                                  color: themeFlag
                                                      ? Colors.white
                                                      : Color(0xff777777),
                                                ),
                                                iconEnabledColor: themeFlag
                                                    ? Colors.white
                                                    : Color(0xff777777),
                                                hint: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          12.0, 0, 16, 0),
                                                  child: Text(
                                                    "Select your year",
                                                    style: TextStyle(
                                                      fontFamily: 'Quicksand',
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: themeFlag
                                                          ? Colors.white
                                                          : Color(0xff777777),
                                                    ),
                                                  ),
                                                ),
                                                items: _dropdownYearItems,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedYear = value;
                                                    year = value.name;
                                                  });
                                                },
                                                value: _selectedYear,
                                                isExpanded: true),
                                          ),
                                          new Divider(
                                            height: 10,
                                            color: Colors.transparent,
                                          ),
                                          new TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              style: TextStyle(
                                                  fontFamily: 'Quicksand',
                                                  color: themeFlag
                                                      ? Colors.white
                                                      : Color(0xff777777),
                                                  fontSize: 15),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.only(left: 0),
                                                labelStyle: TextStyle(
                                                  color: themeFlag
                                                      ? Colors.white
                                                      : Color(0xff777777),
                                                  fontFamily: 'Quicksand',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: themeFlag
                                                          ? Colors.white
                                                          : Color(0xff777777)),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blue),
                                                ),
                                                border: UnderlineInputBorder(),
                                                labelText: 'Enter Roll Number',
                                              ),
                                              validator: (value) {
                                                if (value.length != 11) {
                                                  return 'Incorrect Roll Number';
                                                }
                                                return null;
                                              },
                                              onChanged: (val) {
                                                setState(() {
                                                  rollNo = val;
                                                });
                                              }),
                                          new Divider(
                                              height: 30,
                                              color: Colors.transparent),
                                          new Text(
                                            userMap['post'] == 'Mentor'
                                                ? "Are you a hosteller?"
                                                : "Do you want your mentor to be a hosteller?",
                                            style: TextStyle(
                                                fontFamily: 'Quicksand',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: themeFlag
                                                    ? Colors.white
                                                    : Color(0xff777777)),
                                          ),
                                          Theme(
                                            data: ThemeData(
                                              unselectedWidgetColor: themeFlag
                                                  ? Colors.white
                                                  : Color(0xff777777),
                                            ),
                                            child: new Row(children: <Widget>[
                                              Transform.scale(
                                                scale: 0.8,
                                                child: new Radio(
                                                    activeColor: themeFlag
                                                        ? Colors.white
                                                        : Color(0xff777777),
                                                    value: 0,
                                                    groupValue: _hostellerValue,
                                                    onChanged:
                                                        _handleHostellerValue),
                                              ),
                                              new Text(
                                                'Yes',
                                                style: TextStyle(
                                                  fontFamily: 'Quicksand',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: themeFlag
                                                      ? Colors.white
                                                      : Color(0xff777777),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Transform.scale(
                                                scale: 0.9,
                                                child: new Radio(
                                                    activeColor: themeFlag
                                                        ? Colors.white
                                                        : Color(0xff777777),
                                                    value: 1,
                                                    groupValue: _hostellerValue,
                                                    onChanged:
                                                        _handleHostellerValue),
                                              ),
                                              new Text(
                                                'No',
                                                style: TextStyle(
                                                    fontFamily: 'Quicksanf',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: themeFlag
                                                        ? Colors.white
                                                        : Color(0xff777777)),
                                              ),
                                            ]),
                                          ),
                                          new Divider(
                                              height: 40.0,
                                              color: Colors.transparent),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                    width: 140,
                                                    height: 34,
                                                    child: new MaterialButton(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        color: AppColors
                                                            .COLOR_TURQUOISE,
                                                        onPressed: () async {
                                                          if (_formKey3
                                                                  .currentState
                                                                  .validate() &&
                                                              _hostellerValue !=
                                                                  -1) {
                                                            setState(() {
                                                              userMap['year'] =
                                                                  year;
                                                              userMap['branch'] =
                                                                  branch;
                                                              userMap['rollNo'] =
                                                                  rollNo;
                                                              userMap['hosteller'] =
                                                                  hosteller;
                                                            });
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        RegisterForm4(
                                                                            userMap)));
                                                          }
                                                        },
                                                        child: Text('Next',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'Quicksand',
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700))))
                                              ]),
                                          new Divider(
                                              height: 18.0,
                                              color: Colors.transparent),
                                        ],
                                      ),
                                    ),
                                  )))
                                ]))))
              ]));
  }
}
