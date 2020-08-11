import 'package:dbapp/screens/home/home.dart';
import 'package:dbapp/services/auth.dart';
import 'package:dbapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/services.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

int _radioValue = -1;
int visibleCard = 1;

bool mentor = true;
String post = '';

String name = '';
String phoneNo = '';
String email = '';
String password = '';

String year = 'First';
String branch = 'CSE-1';
String rollNo = '';

String linkedInURL = '';
String githubURL = '';
List domains = [];
List languages = [];
bool hosteller;

bool isNextEnabled = true;


class Register extends StatefulWidget {
  //taken from parent props:
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //form fields

  String error = '';
  bool loading = false;

  void saveData() async {
    dynamic result = await _auth.register(
        name,
        phoneNo,
        email,
        password,
        year,
        branch,
        rollNo,
        linkedInURL,
        githubURL,
        domains,
        languages,
        hosteller,
        post);
    if (result == null) {
      setState(() {
        error = 'some error message';
        loading = false;
      });
    }
  }

  void showToast() {
    setState(() {
      if (visibleCard == 4) {
        saveData();
      }
      visibleCard++;
      isNextEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
            backgroundColor: Colors.brown,
            elevation: 0.0,
            title: Text("Register"),
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('Sign In'),
                onPressed: () {
                  widget.toggleView();
                },
              )
            ]),
        body: loading
            ? Loading()
            : Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RaisedButton(
                      child: visibleCard == 4 ? Text('Register') : Text('Next'),
                      onPressed: (){
                        isNextEnabled ? showToast() : null;
                      }
                    ),
                    Visibility(
                      visible: visibleCard == 1,
                      child: Card(
                        child: new Container(
                            padding: EdgeInsets.all(12),
                            child: new MentorOrMenteeForm()),
                        margin: EdgeInsets.all(15),
                      ),
                    ),
                    Visibility(
                      visible: visibleCard == 2,
                      child: Card(
                        child: new Container(
                            padding: EdgeInsets.all(12),
                            child: new ContactForm()),
                        margin: EdgeInsets.all(15),
                      ),
                    ),
                    Visibility(
                      visible: visibleCard == 3,
                      child: Card(
                        child: new Container(
                            padding: EdgeInsets.all(12),
                            child: new CollegeForm()),
                        margin: EdgeInsets.all(15),
                      ),
                    ),
                    Visibility(
                      visible: visibleCard == 4,
                      child: Card(
                        child: new Container(
                            padding: EdgeInsets.all(12),
                            child: new PreferencesForm()),
                        margin: EdgeInsets.all(15),
                      ),
                    ),
                  ],
                ),
              ));
  }
}

class MentorOrMenteeForm extends StatefulWidget {
  @override
  MentorOrMenteeFormState createState() {
    return MentorOrMenteeFormState();
  }
}

// Create a corresponding State class, which holds data related to the form.
class MentorOrMenteeFormState extends State<MentorOrMenteeForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.

  final _formKey1 = GlobalKey<FormState>();
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      mentor = _radioValue == 0;
      post = mentor? 'Mentor' : 'Mentee';
    });
  }

  void initState() {
    super.initState();
    setState(() {
      _radioValue = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text('Do you want to register as a mentor or a mentee?'),
          new Divider(height: 5.0, color: Colors.white),
          new Row(
            children: <Widget>[
              new Radio(
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange),
              new Text('Mentor'),
              new Radio(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange),
              new Text('Mentee'),
            ],
          ),
          new Container(
              padding: const EdgeInsets.only(left: 175.0, top: 20.0),
              child: new RaisedButton(
                child: const Text('Submit'),
                onPressed: () {
                  print(_radioValue);
                  // It returns true if the form is valid, otherwise returns false
                  if (_formKey1.currentState.validate() && _radioValue != -1) {
                    isNextEnabled = true;
                    // If the form is valid, display a Snackbar.
                    // Scaffold.of(context).showSnackBar(
                    //     SnackBar(content: Text('Data is in processing.')));
                  } else {
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Error')));
                  }
                },
              )),
        ],
      ),
    );
  }
}

class ContactForm extends StatefulWidget {
  @override
  ContactFormState createState() {
    return ContactFormState();
  }
}

// Create a corresponding State class, which holds data related to the form.
class ContactFormState extends State<ContactForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new TextFormField(
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.grey),
              decoration: const InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                border: UnderlineInputBorder(),
                icon: const Icon(Icons.person),
                hintText: 'Enter your full name',
                hintStyle: TextStyle(fontSize: 12),
                labelText: 'Name',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              onChanged: (val) {
                setState(() => name = val);
              }),
          TextFormField(
              keyboardType: TextInputType.phone,
              style: TextStyle(color: Colors.grey),
              decoration: const InputDecoration(
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  border: UnderlineInputBorder(),
                  icon: const Icon(Icons.phone),
                  hintText: 'Enter a phone number',
                  hintStyle: TextStyle(fontSize: 12),
                  labelText: 'Phone'),
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
          TextFormField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.grey),
              decoration: const InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                border: UnderlineInputBorder(),
                icon: const Icon(Icons.email),
                hintText: 'Enter your email id',
                hintStyle: TextStyle(fontSize: 12),
                labelText: 'Email id',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              onChanged: (val) {
                setState(() => email = val);
              }),
          TextFormField(
              style: TextStyle(color: Colors.grey),
              decoration: const InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                border: UnderlineInputBorder(),
                icon: const Icon(Icons.security),
                hintText: 'Enter your password',
                hintStyle: TextStyle(fontSize: 12),
                labelText: 'Password',
              ),
              validator: (value) {
                if (value.length < 6) {
                  return 'Enter a password 6+ chars long';
                }
                return null;
              },
              obscureText: true,
              onChanged: (val) {
                setState(() => password = val);
              }),
          new Container(
              padding: const EdgeInsets.only(left: 175.0, top: 40.0),
              child: new RaisedButton(
                child: const Text('Submit'),
                onPressed: () {
                  print(name + phoneNo + email);
                  // It returns true if the form is valid, otherwise returns false
                  if (_formKey2.currentState.validate()) {
                    setState(() {
                      isNextEnabled = true;
                    });
                    // If the form is valid, display a Snackbar.
                    // Scaffold.of(context).showSnackBar(
                    //     SnackBar(content: Text('Data is in processing.')));
                  }
                },
              )),
        ],
      ),
    );
  }
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class CollegeForm extends StatefulWidget {
  @override
  CollegeFormState createState() {
    return CollegeFormState();
  }
}

// Create a corresponding State class, which holds data related to the form.
class CollegeFormState extends State<CollegeForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey3 = GlobalKey<FormState>();

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
    _dropdownBranchItems = buildDropDownMenuItems(_dropdownBranch);
    _selectedBranch = _dropdownBranch[0];
    
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
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          new Divider(
            height: 10,
            color: Colors.white,
          ),
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
            color: Colors.white,
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
          new Divider(height: 10, color: Colors.white),
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
                setState(() => linkedInURL = val);
              }),
          new Divider(height: 10, color: Colors.white),
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
              padding: const EdgeInsets.only(left: 175.0, top: 40.0),
              child: new RaisedButton(
                child: const Text('Submit'),
                onPressed: () {
                  print(branch.toString() + year.toString() + rollNo);
                  // It returns true if the form is valid, otherwise returns false
                  if (_formKey3.currentState.validate()) {
                    setState(() {
                      isNextEnabled = true;
                    });
                    // If the form is valid, display a Snackbar.
                    // Scaffold.of(context).showSnackBar(
                    //     SnackBar(content: Text('Data is in processing.')));
                  }
                },
              )),
          
        ],
      ),
    );
  }
}

class PreferencesForm extends StatefulWidget {
  @override
  PreferencesFormState createState() {
    return PreferencesFormState();
  }
}

// Create a corresponding State class, which holds data related to the form.
class PreferencesFormState extends State<PreferencesForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  String _domainsResult;
  String _languagesResult;
  int _hostellerValue = -1;
  final _formKey4 = GlobalKey<FormState>();
  void _handleHostellerValue(int value) {
    setState(() {
      _hostellerValue = value;
      hosteller = _hostellerValue == 0;
    });
  }

  void initState() {
    super.initState();
    domains = [];
    languages = [];
    _domainsResult = '';
    _languagesResult = '';
  }

  // _saveDomains() {
  //   var form = _formKey4.currentState;
  //   if (form.validate()) {
  //     form.save();
  //     setState(() {
  //       _domainsResult = _domains.toString();
  //       _languagesResult = _languages.toString();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SingleChildScrollView(
      child: Form(
        key: _formKey4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(_radioValue == 0
                ? "Tell us about the domains you have worked in and the languages you know"
                : "What skills do you want in your mentor?"),
            new Divider(height: 12, color: Colors.white),
            Container(
              padding: EdgeInsets.all(6),
              child: MultiSelectFormField(
                autovalidate: false,
                titleText: 'Domains',
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
                hintText: 'Choose one or more',
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
            Container(
              padding: EdgeInsets.all(6),
              child: MultiSelectFormField(
                autovalidate: false,
                titleText: 'Languages',
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
                hintText: 'Choose one or more',
                initialValue: languages,
                onSaved: (value) {
                  if (value == null) return;
                  setState(() {
                    languages = value;
                  });
                },
              ),
            ),
            new Divider(height: 0, color: Colors.white),
            new Text(_radioValue == 0
                ? "Are you a hosteller?"
                : "Do you want your mentor to be a hosteller?"),
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
                  child: const Text('Submit'),
                  onPressed: () {
                    print(domains);
                    print(hosteller);
                    // It returns true if the form is valid, otherwise returns false
                    if (_formKey4.currentState.validate() &&
                        _hostellerValue != -1) {
                      print("hyyy");
                      setState(() {
                        isNextEnabled = true;
                      });
                      // If the form is valid, display a Snackbar.
                      // Scaffold.of(context).showSnackBar(
                      //     SnackBar(content: Text('Data is in processing.')));
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}

// body: loading? Loading() : Container(
//         padding: EdgeInsets.symmetric(vertical:20.0,horizontal:50.0),
//           child:Form(
//               key:_formKey,
//               child: Column(
//                 children: <Widget>[
//                   SizedBox(height:20.0),
//                   TextFormField(
//                     decoration: textInputDecorations.copyWith(
//                          labelText: "Enter Email",
//                     ),
//                      validator: (val) => val.isEmpty ? 'Enter an email' :null,
//                     onChanged: (val){
//                       setState(()=>email=val);
//                     }
//                   ),
//                   SizedBox(height:20.0),
//                   TextFormField(
//                     decoration: textInputDecorations.copyWith(
//                          labelText: "Enter Password",
//                     ),
//                     validator: (val) => val.length<6 ? 'Enter an password 6+ chars long' :null,
//                     obscureText: true,
//                     onChanged: (val){
//                       setState(()=>password=val);
//                     }
//                   ),
//                   new TextField(
//                       decoration: new InputDecoration(labelText: "Enter your number"),
//                       keyboardType: TextInputType.number,
//                       inputFormatters: <TextInputFormatter>[
//                           WhitelistingTextInputFormatter.digitsOnly
//                       ],
//                       onChanged: (val){
//                         setState(()=>year=int.parse(val));
//                       } // Only numbers can be entered
//                   ),
//                   SizedBox(height:20.0),
//                   RaisedButton(
//                     color:Colors.green,
//                     child:Text(
//                       'Sign up',
//                       style: TextStyle(color:Colors.white),
//                       ),
//                       onPressed: () async{
//                         if(_formKey.currentState.validate()){
//                           setState(() {
//                             loading=true;
//                           });
//                             name='Suhani';
//                             rollNo=021;
//                             branch='IT';
//                             contact=99;
//                             linkedInURL='suhanichawla';
//                             githubURL='suhanichawla';
//                             domains = ["web","android"];
//                             hosteller=false;
//                             languages=["cpp","java"];
//                             dynamic result=await _auth.register(email, password,name,year,rollNo,branch,contact,linkedInURL,githubURL,domains,hosteller,languages,false);
//                             if(result == null){
//                                 setState(() {
//                                   error='some error message';
//                                   loading=false;
//                                 });
//                             }
//                         }
//                       },
//                   ),
//                   SizedBox(height:20.0),
//                   Text(
//                     error,
//                     style:TextStyle(
//                       color:Colors.red,
//                       fontSize: 14.0
//                     )
//                   )
//                 ],
//               ),
//             )
//           )

//       );
//   }
// }
