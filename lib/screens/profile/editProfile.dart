import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/services/storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

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
    ThemeNotifier _themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = _themeNotifier.darkTheme;

    return Scaffold(
      appBar: new AppBar(
          title: new Text("Edit Profile"),
          backgroundColor: AppColors.COLOR_TEAL_DARK),
      // body: newDP == null ? getChooseButton() : getUploadButton(),
      backgroundColor: themeFlag ? AppColors.PROTEGE_GREY : Colors.white,
      body: Card(
        child: new Container(
            padding: EdgeInsets.all(12), child: new RegistrationForm(userInfo)),
        margin: EdgeInsets.all(15),
      ),
    );
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
  String error = '';
  bool loading = true;

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

  void initState() {
    super.initState();
    name = userInfo['name'];
    phoneNo = userInfo['contact'];
    rollNo = userInfo['rollNo'];
    githubUrl = userInfo['githubURL'];
    linkedInUrl = userInfo['linkedInURL'];
    domains = userInfo['domains'];
    languages = userInfo['languages'];

    _dropdownYearItems = buildDropDownMenuItems(_dropdownYear);
    _dropdownBranchItems = buildDropDownMenuItems(_dropdownBranch);

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

  void updateData() async {
    final FirebaseAuth _authUser = FirebaseAuth.instance;
    FirebaseUser user = await _authUser.currentUser();
    print(user.uid);
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
      'photoURL': userInfo['photoURL']
    };
    dynamic result = await DataBaseService(uid: user.uid).updateUserData(
        name,
        phoneNo,
        userInfo['email'],
        year,
        branch,
        rollNo,
        linkedInUrl,
        githubUrl,
        domains,
        languages,
        hosteller,
        userInfo['post'],
        userInfo['photoUrl']);
    await StorageServices.saveUserInfo(userMap).then((value) {
      print('saved in storage');
      //setState(() {});
      StorageServices.getUserInfo().then((value) {
        print("this is getting printed inside get info");
        print(value);
      });
    });
    if (result == null) {
      setState(() {
        error = 'some error message';
        loading = false;
      });
    }
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
                  Text('Name', style: TextStyle (fontFamily: 'GoogleSans',)),
                  new TextFormField(
                      initialValue: name,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          color:
                              themeFlag ? Colors.grey[300] : Colors.grey[700], fontFamily: 'GoogleSans',),
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
                  Text('Phone Number', style: TextStyle (fontFamily: 'GoogleSans',)),
                  TextFormField(
                      initialValue: phoneNo,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                          color:
                              themeFlag ? Colors.grey[300] : Colors.grey[700], fontFamily: 'GoogleSans',),
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
                  Text('Branch', style: TextStyle (fontFamily: 'GoogleSans',)),
                  DropdownButton<ListItem>(
                      style: TextStyle(
                          color:
                              themeFlag ? Colors.grey[300] : Colors.grey[700], fontFamily: 'GoogleSans',
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
                  Text('Year', style: TextStyle (fontFamily: 'GoogleSans',)),
                  DropdownButton<ListItem>(
                      style: TextStyle(
                          color:
                              themeFlag ? Colors.grey[300] : Colors.grey[700], fontFamily: 'GoogleSans',),
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
                  Text('Roll Number', style: TextStyle (fontFamily: 'GoogleSans',)),
                  TextFormField(
                    initialValue: rollNo,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: themeFlag ? Colors.grey[300] : Colors.grey[700], fontFamily: 'GoogleSans',),
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
                  Text('LinkedIn Profile URL', style: TextStyle (fontFamily: 'GoogleSans',)),
                  TextFormField(
                      initialValue: linkedInUrl,
                      style: TextStyle(
                          color:
                              themeFlag ? Colors.grey[300] : Colors.grey[700], fontFamily: 'GoogleSans',),
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
                  Text('GitHub Profile URL', style: TextStyle (fontFamily: 'GoogleSans',)),
                  TextFormField(
                      initialValue: githubUrl,
                      style: TextStyle(
                          color:
                              themeFlag ? Colors.grey[300] : Colors.grey[700], fontFamily: 'GoogleSans',),
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
                  Text('Domains', style: TextStyle (fontFamily: 'GoogleSans',)),
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
                      dataSource: [
                        {
                          "display": "Web Development",
                          "value": "Web Development",
                        },
                        {
                          "display": "App Development",
                          "value": "App Development",
                        },
                        {
                          "display": "Machine Learning",
                          "value": "Machine Learning",
                        },
                        {
                          "display": "IOT",
                          "value": "IOT",
                        },
                        {
                          "display": "BlockChain",
                          "value": "BlockChain",
                        },
                        {
                          "display": "Competitive Programming",
                          "value": "Competitive Programming",
                        }
                      ],
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
                  Text('Languages', style: TextStyle (fontFamily: 'GoogleSans',)),
                  Container(
                    padding: EdgeInsets.all(6),
                    child: MultiSelectFormField(
                      fillColor:
                          themeFlag ? Colors.grey[700] : Colors.transparent,
                      autovalidate: false,
                      titleText: 'Select languages',
                      validator: (value) {
                        if (value == null || value.length == 0) {
                          return 'Please select one or more options';
                        }
                      },
                      dataSource: [
                        {
                          "display": "C/C++",
                          "value": "C/C++",
                        },
                        {
                          "display": "Java",
                          "value": "Java",
                        },
                        {
                          "display": "Python",
                          "value": "Python",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                      okButtonLabel: 'OK',
                      cancelButtonLabel: 'CANCEL',
                      hintText: '',
                      initialValue: languages,
                      onSaved: (value) {
                        if (value == null) return;
                        setState(() {
                          languages = value;
                        });
                      },
                    ),
                  ),
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  ),
                  Text('Hosteller', style: TextStyle (fontFamily: 'GoogleSans',)),
                  new Row(children: <Widget>[
                    new Radio(
                        value: 0,
                        groupValue: _hostellerValue,
                        onChanged: _handleHostellerValue),
                    new Text('Yes'),
                    new Radio(
                        value: 1,
                        groupValue: _hostellerValue,
                        onChanged: _handleHostellerValue),
                    new Text('No'),
                  ]),
                  new Container(
                    padding: const EdgeInsets.only(left: 175.0, top: 20.0),
                    child: new FloatingActionButton.extended(
                        heroTag: "btn1",
                        backgroundColor: AppColors.PROTEGE_GREY,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            await updateData();
                            print("this is getting printed");
                            Navigator.of(context).pop();
                            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home(0)));
                          }
                        },
                        label: Text('Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'GoogleSans',
                            ))),
                   
                  ),
                ]));
  }
}
