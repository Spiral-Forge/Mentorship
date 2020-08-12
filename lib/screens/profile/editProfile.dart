import 'package:dbapp/screens/home/home.dart';
import 'package:dbapp/screens/profile/profile.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/services/storage.dart';



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
    return Scaffold(
        appBar: new AppBar(
            title: new Text("Edit Profile"), backgroundColor: Colors.teal),
        body: Card(
          child: new Container(
              padding: EdgeInsets.all(12),
              child: new RegistrationForm(userInfo)),
          margin: EdgeInsets.all(15),
        ));
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
    Map<String,dynamic> userMap = {'name':name,
        'contact': phoneNo,
        'email' : userInfo['email'],
        'year': year,
        'branch':branch,
        'rollNo':rollNo,
        'linkedInURL': linkedInUrl,
        'githubURL': githubUrl,
        'domains': domains,
        'languages': languages,
        'hosteller': hosteller,
        'post' : userInfo['post']};
        dynamic result = await DataBaseService(uid: user.uid).updateUserData(name,
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
        userInfo['post']);
        await StorageServices.saveUserInfo(userMap).then((value) { 
        print('saved in storage'); 
        //setState(() {});
        StorageServices.getUserInfo().then((value){
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

  Widget build(BuildContext context) {
    return loading? Loading() : Form(
        key: _formKey,
        child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            children: <Widget>[
              Text('Name'),
              new TextFormField(
                  initialValue: name,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.grey),
                  decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
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
                color: Colors.white,
              ),
              Text('Phone Number'),
              TextFormField(
                  initialValue: phoneNo,
                  keyboardType: TextInputType.phone,
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
                color: Colors.white,
              ),
              Text('Branch'),
              DropdownButton<ListItem>(
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
                color: Colors.white,
              ),
              Text('Year'),
              DropdownButton<ListItem>(
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
                color: Colors.white,
              ),
              Text('Roll Number'),
              TextFormField(
                initialValue: rollNo,
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
              Divider(
                height: 20,
                color: Colors.white,
              ),
              Text('LinkedIn Profile URL'),
              TextFormField(
                  initialValue: linkedInUrl,
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
                  onChanged: (val) {
                    setState(() => linkedInUrl = val);
                  }),
              Divider(
                height: 20,
                color: Colors.white,
              ),
              Text('GitHub Profile URL'),
              TextFormField(
                  initialValue: githubUrl,
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
                  onChanged: (val) {
                    setState(() => githubUrl = val);
                  }),
              Divider(
                height: 20,
                color: Colors.white,
              ),
              Text('Domains'),
              Container(
                padding: EdgeInsets.all(4),
                child: MultiSelectFormField(
                  fillColor: Colors.transparent,
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
              new Divider(height: 0, color: Colors.white),
              Divider(
                height: 20,
                color: Colors.white,
              ),
              Text('Languages'),
              Container(
                padding: EdgeInsets.all(6),
                child: MultiSelectFormField(
                  fillColor: Colors.transparent,
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
                color: Colors.white,
              ),
              Text('Hosteller'),
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
                  child: new RaisedButton(
                    child: const Text('Save'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await updateData();
                        print("this is getting printed");
                        Navigator.of(context).pop();
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home(0)));
                      }
                    },
                  )),
            ]));
  }
}
