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
String linkedinURL = '';
String githubURL = '';

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

  void initState() {
    super.initState();
    _dropdownYearItems = buildDropDownMenuItems(_dropdownYear);
    _selectedYear = _dropdownYear[0];
    year = _selectedYear.name;
    _dropdownBranchItems = buildDropDownMenuItems(_dropdownBranch);
    _selectedBranch = _dropdownBranch[0];
    branch = _selectedBranch.name;
    rollNo='';
    linkedinURL='';
    githubURL='';
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
      backgroundColor: AppColors.PROTEGE_CYAN,
      appBar: AppBar(
          backgroundColor: AppColors.COLOR_TEAL_DARK,
          elevation: 0.0,
          title: Text("Register"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Sign In'),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => SignIn()));
              },
            )
          ]),
      body: loading
          ? Loading()
          : Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                margin: EdgeInsets.all(8),
                child: new Container(
                    padding: EdgeInsets.all(15),
                    child: Form(
                      key: _formKey3,
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Text("Select your branch"),
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
                          Text("Select your year"),
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
                          Text('Enter your Roll Number'),
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
                          Text('Enter your Linkedin Profile URL'),
                          TextFormField(
                              style: TextStyle(color: Colors.grey),
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                border: UnderlineInputBorder(),
                              ),
                              // validator: (val) {
                              //   if (val.length == 0) {
                              //     return 'Required';
                              //   }
                              //   return '';
                              // },
                              onChanged: (val) {
                                setState(() => linkedinURL = val);
                              }),
                          new Divider(height: 10, color: Colors.transparent),
                          Text('Enter your GitHub Profile URL'),
                          TextFormField(
                              style: TextStyle(color: Colors.grey),
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                border: UnderlineInputBorder(),
                              ),
                              // validator: (val) {
                              //   if (val.length == 0) {
                              //     return 'Required';
                              //   }
                              //   return '';
                              // },
                              onChanged: (val) {
                                setState(() => githubURL = val);
                              }),
                          new Container(
                              padding:
                                  const EdgeInsets.only(left: 175.0, top: 40.0),
                              child: new RaisedButton(
                                child: const Text('Next'),
                                onPressed: () {
                                  // It returns true if the form is valid, otherwise returns false
                                  if (_formKey3.currentState.validate()) {
                                    setState(() {
                                      userMap['year'] = year;
                                      userMap['branch'] = branch;
                                      userMap['rollNo'] = rollNo;
                                      userMap['linkedInURL'] = linkedinURL;
                                      userMap['githubURL'] = githubURL;
                                    });
                                    print(userMap);
                                    Navigator.push( context, MaterialPageRoute( builder: (context) => RegisterForm4(userMap)));
                                    // If the form is valid, display a Snackbar.
                                    // Scaffold.of(context).showSnackBar(
                                    //     SnackBar(content: Text('Data is in processing.')));
                                  }
                                },
                              )),
                        ],
                      ),
                    )),
              ),
            ),
    );
  }
}
