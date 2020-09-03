import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/screenConstants.dart';
import 'package:dbapp/screens/authenticate/signin.dart';
import 'package:dbapp/screens/home/home.dart';
import 'package:dbapp/services/auth.dart';
import 'package:dbapp/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/services.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
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

  final AuthService _auth = AuthService();
  final _formKey3 = GlobalKey<FormState>();

  //form fields
  bool loading = false;

  List<ListItem> _dropdownBranch = [
    ListItem(1, "CSE-1"),
    ListItem(2, "CSE-2"),
    ListItem(3, "IT-1"),
    ListItem(4, "IT-2"),
    ListItem(5, "ECE"),
    ListItem(6, "MAE"),
    ListItem(7, "BBA"),
    ListItem(8, "B.Arch")
  ];

  List<ListItem> _dropdownYear = [
    ListItem(1, "First"),
    ListItem(2, "Second"),
    ListItem(3, "Third")
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
      print(hosteller);
      print(_hostellerValue);
    });
  }

  void initState() {
    super.initState();
    _dropdownYearItems = buildDropDownMenuItems(_dropdownYear);
    _selectedYear = _dropdownYear[0];
    year = _selectedYear.name;
    _dropdownBranchItems = buildDropDownMenuItems(_dropdownBranch);
    _selectedBranch = _dropdownBranch[0];
    branch = _selectedBranch.name;
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.COLOR_TEAL_LIGHT,
        elevation: 0.0,
        title: Text("Register"),
      ),
      body: loading
          ? Loading()
          : Padding(
              padding: EdgeInsets.all(18.0),
              child: Card(
                margin: EdgeInsets.all(8),
                child: new Container(
                    padding: EdgeInsets.all(15),
                    child: Form(
                      key: _formKey3,
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          new Divider(height: 35.0, color: Colors.transparent),
                          new Text(
                            'College info',
                            style: TextStyle(
                              fontFamily: 'GoogleSans',
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          new Divider(height: 35.0, color: Colors.transparent),
                          Text(
                            "Select your branch",
                            style: TextStyle(
                              fontFamily: 'GoogleSans',
                              fontSize: 13,
                            ),
                          ),
                          DropdownButton<ListItem>(
                              value: _selectedBranch,
                              items: _dropdownBranchItems,
                              onChanged: (value) {
                                setState(() {
                                  _selectedBranch = value;
                                  branch = value.name;
                                });
                              }),
                          new Divider(height: 10, color: Colors.transparent),
                          Text(
                            "Select your year",
                            style: TextStyle(
                              fontFamily: 'GoogleSans',
                              fontSize: 13,
                            ),
                          ),
                          DropdownButton<ListItem>(
                              value: _selectedYear,
                              items: _dropdownYearItems,
                              onChanged: (value) {
                                setState(() {
                                  _selectedYear = value;
                                  year = value.name;
                                });
                              }),
                          new Divider(
                            height: 10,
                            color: Colors.transparent,
                          ),
                          Text(
                            'Enter your Roll Number',
                            style: TextStyle(
                              fontFamily: 'GoogleSans',
                              fontSize: 13,
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.grey),
                            decoration: new InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                border: UnderlineInputBorder()),
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
                            },
                          ),
                          new Divider(height: 10, color: Colors.transparent),
                          new Text(
                            userMap['post'] == 'Mentor'
                                ? "Are you a hosteller?"
                                : "Do you want your mentor to be a hosteller?",
                            style: TextStyle(
                              fontFamily: 'GoogleSans',
                              fontSize: 13,
                            ),
                          ),
                          new Row(children: <Widget>[
                            new Radio(
                                value: 0,
                                groupValue: _hostellerValue,
                                onChanged: _handleHostellerValue),
                            new Text(
                              'Yes',
                              style: TextStyle(
                                fontFamily: 'GoogleSans',
                                fontSize: 16,
                              ),
                            ),
                            new Radio(
                                value: 1,
                                groupValue: _hostellerValue,
                                onChanged: _handleHostellerValue),
                            new Text(
                              'No',
                              style: TextStyle(
                                fontFamily: 'GoogleSans',
                                fontSize: 16,
                              ),
                            ),
                          ]),
                          new Divider(height: 35.0, color: Colors.transparent),
                          new Container(
                            padding: EdgeInsets.fromLTRB(120, 5, 120, 5),
                            child: RaisedButton(
                                color: AppColors.COLOR_TEAL_LIGHT,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                      color: AppColors.COLOR_TEAL_LIGHT,
                                    )),
                                child: Text("Next",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'GoogleSans'),
                                    textAlign: TextAlign.center),
                                onPressed: () {
                                  if (_formKey3.currentState.validate() &&
                                      _hostellerValue != -1) {
                                    setState(() {
                                      userMap['year'] = year;
                                      userMap['branch'] = branch;
                                      userMap['rollNo'] = rollNo;
                                      userMap['hosteller'] = hosteller;
                                    });
                                    print(userMap);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterForm4(userMap)));
                                    // If the form is valid, display a Snackbar.
                                    // Scaffold.of(context).showSnackBar(
                                    //     SnackBar(content: Text('Data is in processing.')));
                                  }
                                }),
                          ),
                          new Divider(height: 18.0, color: Colors.transparent),
                        ],
                      ),
                    )),
              ),
            ),
    );
  }
}
