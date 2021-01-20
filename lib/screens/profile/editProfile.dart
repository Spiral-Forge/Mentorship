import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/services/storage.dart';
import 'package:provider/provider.dart';
import 'package:dbapp/constants/screenConstants.dart';

String name = '';
String phoneNo = '';
String branch = '';
String year = '';
String rollNo = '';
String githubUrl = '';
String linkedInUrl = '';
List domains = [];
List languages = [];
bool hosteller = false;

class ListItem {
  int value;
  String name;
  ListItem(this.value, this.name);
}

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  EditProfilePage(this.userInfo);
  @override
  EditProfilePageState createState() => EditProfilePageState(userInfo);
}

class EditProfilePageState extends State<EditProfilePage> {
  final Map<String, dynamic> userInfo;
  EditProfilePageState(this.userInfo);

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
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text("Edit Profile",
                                  style: TextStyle(
                                      fontFamily: 'GoogleSans',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      Expanded(
                        child: Card(
                          child: new Container(
                              padding: EdgeInsets.all(12),
                              child: new RegistrationForm(userInfo)),
                          margin: EdgeInsets.all(15),
                        ),
                      )
                    ],
                  ))))
    ]));
  }
}

class RegistrationForm extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  RegistrationForm(this.userInfo);
  @override
  _RegistrationFormState createState() => _RegistrationFormState(userInfo);
}

class _RegistrationFormState extends State<RegistrationForm> {
  final Map<String, dynamic> userInfo;
  _RegistrationFormState(this.userInfo);
  @override
  final _formKey = GlobalKey<FormState>();
  int _hostellerValue = -1;
  bool loading = true;

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

  List<ListItem> _dropdownLang = [
    ListItem(1, "C++"),
    ListItem(2, "Java"),
    ListItem(3, "Python"),
    ListItem(4, "No preference")
  ];

  List<DropdownMenuItem<ListItem>> _dropdownBranchItems;
  ListItem _selectedBranch;
  List<DropdownMenuItem<ListItem>> _dropdownYearItems;
  ListItem _selectedYear;
  List<DropdownMenuItem<ListItem>> _dropdownLangItems;
  ListItem _selectedLang;

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

  void updateData() async {
    final FirebaseAuth _authUser = FirebaseAuth.instance;
    FirebaseUser user = await _authUser.currentUser();
    Map<String, dynamic> userMap = {
      'name': name,
      'contact': phoneNo,
      'email': userInfo['email'],
      'year': year,
      'branch': branch,
      'rollNo': rollNo,
      'linkedInURL': linkedInUrl,
      'githubURL': githubUrl,
      'domains': domains,
      'languages': languages,
      'hosteller': hosteller,
      'post': userInfo['post'],
      'token': userInfo['token'],
      'photoURL': userInfo['photoURL'],
      'peerID': userInfo['peerID']
    };
    await StorageServices.saveUserInfo(userMap);
  }

  void initState() {
    super.initState();
    name = userInfo['name'];
    phoneNo = userInfo['contact'];
    rollNo = userInfo['rollNo'];
    githubUrl = userInfo['githubURL'];
    linkedInUrl = userInfo['linkedInURL'];
    domains = userInfo['domains'];

    _dropdownYearItems = buildDropDownMenuItems(_dropdownYear);
    _dropdownBranchItems = buildDropDownMenuItems(_dropdownBranch);
    _dropdownLangItems = buildDropDownMenuItems(_dropdownLang);

    _dropdownBranch.forEach((element) {
      if (element.name == userInfo['branch']) {
        _selectedBranch = element;
      }
    });

    _dropdownYear.forEach((element) {
      if (element.name == userInfo['year']) {
        _selectedYear = element;
      }
    });

    if (userInfo['post'] == 'Mentee') {
      _dropdownLang.forEach((element) {
        if (element.name == userInfo['languages'][0]) {
          _selectedLang = element;
          languages.add(element);
          //break;
        }
      });
    } else {
      languages = userInfo['languages'];
    }

    branch = _selectedBranch.name;
    year = _selectedYear.name;

    if (userInfo['hosteller']) {
      _hostellerValue = 0;
    } else {
      _hostellerValue = 1;
    }
    setState(() {
      loading = false;
    });
  }

  void _handleHostellerValue(int value) {
    setState(() {
      _hostellerValue = value;
      hosteller = _hostellerValue == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    return loading
        ? Loading()
        : Form(
            key: _formKey,
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  Text('Name',
                      style: TextStyle(
                          fontFamily: 'GoogleSans',
                          fontSize: 13,
                          color: Hexcolor("#959595"))),
                  new TextFormField(
                      initialValue: name,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: themeFlag ? Colors.grey[300] : Colors.grey[700],
                        fontFamily: 'GoogleSans',
                      ),
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          border: UnderlineInputBorder()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() => name = val);
                      }),
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  Text('Phone Number',
                      style: TextStyle(
                          fontFamily: 'GoogleSans',
                          fontSize: 13,
                          color: Hexcolor("#959595"))),
                  TextFormField(
                      initialValue: phoneNo,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        color: themeFlag ? Colors.grey[300] : Colors.grey[700],
                        fontFamily: 'GoogleSans',
                      ),
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        border: UnderlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Required';
                        } else if (value.length != 10) {
                          return 'Incorrect';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() => phoneNo = val);
                      }),
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  Text('Branch',
                      style: TextStyle(
                          fontFamily: 'GoogleSans',
                          fontSize: 13,
                          color: Hexcolor("#959595"))),
                  DropdownButton<ListItem>(
                      style: TextStyle(
                        color: themeFlag ? Colors.grey[300] : Colors.grey[700],
                        fontFamily: 'GoogleSans',
                      ),
                      value: _selectedBranch,
                      items: _dropdownBranchItems,
                      onChanged: (value) {
                        setState(() {
                          _selectedBranch = value;
                          branch = value.name;
                        });
                      }),
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  Text('Year',
                      style: TextStyle(
                          fontFamily: 'GoogleSans',
                          fontSize: 13,
                          color: Hexcolor("#959595"))),
                  DropdownButton<ListItem>(
                      style: TextStyle(
                        color: themeFlag ? Colors.grey[300] : Colors.grey[700],
                        fontFamily: 'GoogleSans',
                      ),
                      value: _selectedYear,
                      items: _dropdownYearItems,
                      onChanged: (value) {
                        setState(() {
                          _selectedYear = value;
                          year = value.name;
                        });
                      }),
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  Text('Roll Number',
                      style: TextStyle(
                          fontFamily: 'GoogleSans',
                          fontSize: 13,
                          color: Hexcolor("#959595"))),
                  TextFormField(
                    initialValue: rollNo,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: themeFlag ? Colors.grey[300] : Colors.grey[700],
                      fontFamily: 'GoogleSans',
                    ),
                    decoration: new InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
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
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  Text('LinkedIn URL',
                      style: TextStyle(
                          fontFamily: 'GoogleSans',
                          fontSize: 13,
                          color: Hexcolor("#959595"))),
                  TextFormField(
                      initialValue: linkedInUrl,
                      style: TextStyle(
                        color: themeFlag ? Colors.grey[300] : Colors.grey[700],
                        fontFamily: 'GoogleSans',
                      ),
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        border: UnderlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setState(() => linkedInUrl = val);
                      }),
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  Text('GitHub URL',
                      style: TextStyle(
                          fontFamily: 'GoogleSans',
                          fontSize: 13,
                          color: Hexcolor("#959595"))),
                  TextFormField(
                      initialValue: githubUrl,
                      style: TextStyle(
                        color: themeFlag ? Colors.grey[300] : Colors.grey[700],
                        fontFamily: 'GoogleSans',
                      ),
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        border: UnderlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setState(() => githubUrl = val);
                      }),
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  Text('Domains',
                      style: TextStyle(
                          fontFamily: 'GoogleSans',
                          fontSize: 13,
                          color: Hexcolor("#959595"))),
                  Divider(
                    height: 10,
                    color: Colors.transparent,
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    child: MultiSelectFormField(
                      fillColor:
                          themeFlag ? Colors.grey[700] : Colors.transparent,
                      autovalidate: false,
                      titleText: 'Select domains',
                      validator: (value) {
                        if (value == null || value.length == 0) {
                          return 'Please select one or more options';
                        }
                      },
                      dataSource: ScreenConstants.registerFieldData,
                      textField: 'display',
                      valueField: 'value',
                      okButtonLabel: 'OK',
                      cancelButtonLabel: 'CANCEL',
                      hintText: '',
                      initialValue: domains,
                      onSaved: (value) {
                        if (value == null) return;
                        setState(() {
                          domains = value;
                        });
                      },
                    ),
                  ),
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  Text('Languages',
                      style: TextStyle(
                          fontFamily: 'GoogleSans',
                          fontSize: 13,
                          color: Hexcolor("#959595"))),
                  Divider(
                    height: 10,
                    color: Colors.transparent,
                  ),
                  Container(
                      child: userInfo['post'] == 'Mentee'
                          ? Container(
                              padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                              child: DropdownButton<ListItem>(
                                  style: TextStyle(
                                    color: themeFlag
                                        ? Colors.grey[300]
                                        : Colors.grey[700],
                                    fontFamily: 'GoogleSans',
                                  ),
                                  value: _selectedLang,
                                  items: _dropdownLangItems,
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedLang = val;
                                      languages = [];
                                      languages.add(val.name);
                                    });
                                  },
                                  isExpanded: false))
                          : Container(
                              padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
                              child: MultiSelectFormField(
                                fillColor: themeFlag
                                    ? Colors.grey[700]
                                    : Colors.transparent,
                                autovalidate: false,
                                titleText: 'Languages',
                                validator: (value) {
                                  if (value == null || value.length == 0) {
                                    return 'Please select one or more options';
                                  }
                                },
                                dataSource:
                                    ScreenConstants.registerLanguageData,
                                textField: 'display',
                                valueField: 'value',
                                okButtonLabel: 'OK',
                                cancelButtonLabel: 'CANCEL',
                                hintText: 'Choose one or more',
                                initialValue: languages,
                                onSaved: (value) {
                                  if (value == null) return;
                                  setState(() {
                                    languages = value;
                                  });
                                },
                              ),
                            )),
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  Text('Hosteller',
                      style: TextStyle(
                          fontFamily: 'GoogleSans',
                          fontSize: 13,
                          color: Hexcolor("#959595"))),
                  new Row(children: <Widget>[
                    new Radio(
                        value: 0,
                        groupValue: _hostellerValue,
                        onChanged: _handleHostellerValue),
                    new Text('Yes',
                        style:
                            TextStyle(fontFamily: 'GoogleSans', fontSize: 15)),
                    new Radio(
                        value: 1,
                        groupValue: _hostellerValue,
                        onChanged: _handleHostellerValue),
                    new Text('No',
                        style:
                            TextStyle(fontFamily: 'GoogleSans', fontSize: 15)),
                  ]),
                  Divider(
                    height: 25,
                    color: Colors.transparent,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 35,
                          child: new FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: AppColors.PROTEGE_GREY,
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  await updateData();
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text('Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'GoogleSans',
                                    fontSize: 15,
                                  ))),
                        ),
                      ]),
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  ),
                ]));
  }
}
