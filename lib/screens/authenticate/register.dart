import 'package:dbapp/screens/home/home.dart';
import 'package:dbapp/services/auth.dart';
import 'package:dbapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/services.dart';


int _radioValue = -1;
int visibleCard = 1;
String email='';
  String password='';
  String name='';
  String phoneNo = '';
  String year='';
  int rollNo=0;
  String branch='';
  int contact=0;
  String linkedInURL='';
  String githubURL='';
  List<String> domains = [];
  bool hosteller;
  List<String> languages=[];

class Register extends StatefulWidget {

   //taken from parent props:
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth=AuthService();
  final _formKey=GlobalKey<FormState>();

 
  //form fields
  
  String error='';
  bool loading=false;

  

  void showToast() {
    setState(() {
      
      if(visibleCard==4){
        visibleCard =0;
      }
      visibleCard++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0.0,
        title:Text("Register"),
        actions: <Widget>[
          FlatButton.icon(
            icon:Icon(Icons.person),
            label:Text('Sign In'),
            onPressed: (){
               widget.toggleView();
            },
          )
        ]
      ),
      body: loading? Loading() : Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
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
                        padding: EdgeInsets.all(12), child: new ContactForm()),
                    margin: EdgeInsets.all(15),
                  ),
                ),
                Visibility(
                  visible: visibleCard == 3,
                  child: Card(
                    child: new Container(
                        padding: EdgeInsets.all(12), child: new CollegeForm()),
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
                RaisedButton(
                  child: Text('Next'),
                  onPressed: showToast,
                ),
              ],
            ),
          )

      );
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
              new Radio(value: 0, groupValue: _radioValue, onChanged: _handleRadioValueChange),
              new Text('Mentor'),
              new Radio(value: 1, groupValue: _radioValue, onChanged: _handleRadioValueChange),
              new Text('Mentee'),
            ],
          ),
          new Container(
              padding: const EdgeInsets.only(left: 175.0, top: 20.0),
              child: new RaisedButton(
                child: const Text('Submit'),
                onPressed: () {
                  // It returns true if the form is valid, otherwise returns false
                  if (_formKey1.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Data is in processing.')));
                    
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
                keyboardType : TextInputType.text,
                decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    hintText: 'Enter your full name',
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: 'Name',
                    labelStyle: TextStyle(fontSize: 15)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                onChanged: (val){
                setState(()=>name= val);
            }
              ),
          TextFormField(
            keyboardType : TextInputType.phone,
            decoration: const InputDecoration(
                icon: const Icon(Icons.phone),
                hintText: 'Enter a phone number',
                hintStyle: TextStyle(fontSize: 12),
                labelText: 'Phone',
                labelStyle: TextStyle(fontSize: 15)),
            validator: (value) {
              if (value.isEmpty) {
                return 'Required';
              }
              return null;
            },
            onChanged: (val){
                setState(()=>phoneNo = val);
            }
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                icon: const Icon(Icons.email),
                hintText: 'Enter your email id',
                hintStyle: TextStyle(fontSize: 12),
                labelText: 'Email id',
                labelStyle: TextStyle(fontSize: 15)),
            validator: (value) {
              if (value.isEmpty) {
                return 'Required';
              }
              return null;
            },
            onChanged: (val){
                setState(()=>email= val);
            }
          ),
          TextFormField(
            
            decoration: const InputDecoration(
                icon: const Icon(Icons.security),
                hintText: 'Enter your password',
                hintStyle: TextStyle(fontSize: 12),
                labelText: 'Password',
                labelStyle: TextStyle(fontSize: 15)),
            validator: (value) {
              if(value.length<6){
                return 'Enter an password 6+ chars long';
              }
                return null;
            },
            obscureText: true,
            onChanged: (val){
                setState(()=>password= val);
            }
          ),
          new Container(
              padding: const EdgeInsets.only(left: 175.0, top: 40.0),
              child: new RaisedButton(
                child: const Text('Submit'),
                onPressed: () {
                  // It returns true if the form is valid, otherwise returns false
                  if (_formKey2.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Data is in processing.')));
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
    _selectedYear = _dropdownYearItems[0].value;
    _dropdownBranchItems = buildDropDownMenuItems(_dropdownBranch);
    _selectedBranch = _dropdownBranchItems[0].value;

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
              branch = value.toString();
              setState(() {
                _selectedBranch = value;
              });
            }),
          // TextFormField(
          //   decoration: const InputDecoration(
          //       icon: const Icon(Icons.keyboard_arrow_right),
          //       // hintText: 'Enter your branch',
          //       // hintStyle: TextStyle(fontSize: 12),
          //       labelText: 'Branch',
          //       labelStyle: TextStyle(fontSize: 15)),
          //   validator: (value) {
          //     if (value.isEmpty) {
          //       return 'Required';
          //     }
          //     return null;
          //   },
          // ),
          new Divider(height:10, color: Colors.white,),
          Text("Select your year"),
          DropdownButton<ListItem>(
            value: _selectedYear,
            items: _dropdownYearItems,
            onChanged: (value) {
              year = value.toString();
              setState(() {
                _selectedYear = value;
              });
            }),
          // TextFormField(
          //   decoration: const InputDecoration(
          //       icon: const Icon(Icons.keyboard_arrow_right),
          //       // hintText: 'Enter your year',
          //       // hintStyle: TextStyle(fontSize: 12),
          //       labelText: 'Year',
          //       labelStyle: TextStyle(fontSize: 15)),
          //   validator: (value) {
          //     if (value.isEmpty) {
          //       return 'Required';
          //     }
          //     return null;
          //   },
          // ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                //icon: const Icon(Icons.keyboard_arrow_right),
                // hintText: 'Enter your roll number',
                // hintStyle: TextStyle(fontSize: 12),
                labelText: 'Roll Number',
                labelStyle: TextStyle(fontSize: 15)),
            validator: (value) {
              if (value.length != 11) {
                return 'Incorrect Roll No.';
              }
              return null;
            },
          ),
          new Container(
              padding: const EdgeInsets.only(left: 175.0, top: 40.0),
              child: new RaisedButton(
                child: const Text('Submit'),
                onPressed: () {
                  // It returns true if the form is valid, otherwise returns false
                  if (_formKey3.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Data is in processing.')));
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
  int _hostellerValue = -1;
  final _formKey4 = GlobalKey<FormState>();
  void _handleHostellerValue(int value){
    setState(() {
      _hostellerValue = value;
    });
  }

  List<ListItem> _dropdownDomain = [
    ListItem(1, "Web development"),
    ListItem(2, "App development"),
    ListItem(3, "Machine Learning"),
    ListItem(4, "IOT"),
    ListItem(5, "Blockchain"),
    ListItem(6, "Competitive Programming")
  ];

  List<ListItem> _dropdownLanguage = [
    ListItem(1, "C/C++"),
    ListItem(2, "Java"),
    ListItem(3, "Python")
  ];


  List<DropdownMenuItem<ListItem>> _dropdownDomainItems;
  ListItem _selectedDomain;
  List<DropdownMenuItem<ListItem>> _dropdownLanguageItems;
  ListItem _selectedLanguage;

  void initState() {
    super.initState();
    _dropdownLanguageItems = buildDropDownMenuItems(_dropdownLanguage);
    _selectedLanguage = _dropdownLanguageItems[0].value;
    _dropdownDomainItems = buildDropDownMenuItems(_dropdownDomain);
    _selectedDomain = _dropdownDomainItems[0].value;

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
      key: _formKey4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
                icon: const Icon(Icons.keyboard_arrow_right),
                // hintText: 'Enter your branch',
                // hintStyle: TextStyle(fontSize: 12),
                labelText: 'Domain',
                labelStyle: TextStyle(fontSize: 15)),
            validator: (value) {
              if (value.isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
                icon: const Icon(Icons.keyboard_arrow_right),
                // hintText: 'Enter your year',
                // hintStyle: TextStyle(fontSize: 12),
                labelText: 'Languages',
                labelStyle: TextStyle(fontSize: 15)),
            validator: (value) {
              if (value.isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
          new Divider(height : 30, color : Colors.white),
          new Text(_radioValue==0? "Are you a hosteller?" : "Do you want your mentor to be a hosteller?"),
          new Row(
            children: <Widget>[
              new Radio(value: 0, groupValue: _hostellerValue, onChanged: _handleHostellerValue),
              new Text('Yes'),
              new Radio(value: 1, groupValue: _hostellerValue, onChanged: _handleHostellerValue),
              new Text('No'),
            ]
          ),
          new Container(
              padding: const EdgeInsets.only(left: 175.0, top: 20.0),
              child: new RaisedButton(
                child: const Text('Submit'),
                onPressed: () {
                  // It returns true if the form is valid, otherwise returns false
                  if (_formKey4.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Data is in processing.')));
                  }
                },
              )),
        ],
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