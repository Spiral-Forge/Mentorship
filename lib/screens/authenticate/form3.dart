import 'package:dbapp/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dbapp/screens/authenticate/form4.dart';

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
  RegisterForm3(this.userMap, {this.toggleView});

  @override
  _RegisterForm3State createState() => _RegisterForm3State(userMap);
}

class _RegisterForm3State extends State<RegisterForm3> {
  final Map<String, dynamic> userMap;
  _RegisterForm3State(this.userMap);

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
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                                      icon: Icon(Icons.arrow_back),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 25),
                                  Expanded(
                                      child: SizedBox(
                                          child: Padding(
                                    padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                                    child: Form(
                                      key: _formKey3,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: <Widget>[
                                          new Divider(
                                              height: 35.0,
                                              color: Colors.transparent),
                                          new Text(
                                            'College info',
                                            style: TextStyle(
                                              fontFamily: 'GoogleSans',
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          new Divider(
                                              height: 35.0,
                                              color: Colors.transparent),
                                          Text(
                                            "Select your branch",
                                            style: TextStyle(
                                                fontFamily: 'GoogleSans',
                                                fontSize: 13,
                                                color: Hexcolor('#959595')),
                                          ),
                                          DropdownButton<ListItem>(
                                              hint: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12.0, 0, 16, 0),
                                                child: Text(
                                                  "Pick your branch",
                                                  style: TextStyle(
                                                      color:
                                                          Hexcolor('#a9a9a9')),
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
                                              isExpanded: false),
                                          new Divider(
                                              height: 10,
                                              color: Colors.transparent),
                                          Text(
                                            "Select your year",
                                            style: TextStyle(
                                                fontFamily: 'GoogleSans',
                                                fontSize: 13,
                                                color: Hexcolor('#959595')),
                                          ),
                                          DropdownButton<ListItem>(
                                              hint: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12.0, 0, 16, 0),
                                                child: Text(
                                                  "Current year of study",
                                                  style: TextStyle(
                                                      color:
                                                          Hexcolor('#a9a9a9')),
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
                                              isExpanded: false),
                                          new Divider(
                                            height: 10,
                                            color: Colors.transparent,
                                          ),
                                          new TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              style:
                                                  TextStyle(color: Colors.grey),
                                              decoration: const InputDecoration(
                                                
                                                labelStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontFamily: 'GoogleSans'),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey),
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
                                              height: 20,
                                              color: Colors.transparent),
                                          new Text(
                                            userMap['post'] == 'Mentor'
                                                ? "Are you a hosteller?"
                                                : "Do you want your mentor to be a hosteller?",
                                            style: TextStyle(
                                              fontFamily: 'GoogleSans',
                                              fontSize: 13,
                                              color: Colors.grey
                                            ),
                                          ),
                                          new Row(children: <Widget>[
                                            new Radio(
                                                value: 0,
                                                groupValue: _hostellerValue,
                                                onChanged:
                                                    _handleHostellerValue),
                                            new Text(
                                              'Yes',
                                              style: TextStyle(
                                                fontFamily: 'GoogleSans',
                                                fontSize: 15,
                                              ),
                                            ),
                                            new Radio(
                                                value: 1,
                                                groupValue: _hostellerValue,
                                                onChanged:
                                                    _handleHostellerValue),
                                            new Text(
                                              'No',
                                              style: TextStyle(
                                                fontFamily: 'GoogleSans',
                                                fontSize: 15,
                                              ),
                                            ),
                                          ]),
                                          new Divider(
                                              height: 35.0,
                                              color: Colors.transparent),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                    height: 40,
                                                    child: new MaterialButton(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        color: AppColors
                                                            .COLOR_TEAL_LIGHT,
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
                                                                    'GoogleSans',
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600))))
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
