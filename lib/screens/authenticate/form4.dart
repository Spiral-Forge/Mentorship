import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/screenConstants.dart';
import 'package:dbapp/screens/authenticate/signin.dart';
import 'package:dbapp/screens/home/home.dart';
import 'package:dbapp/screens/wrapper.dart';
import 'package:dbapp/services/auth.dart';
import 'package:dbapp/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:dbapp/shared/loading.dart';
import 'package:flutter/services.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

List domains;
List languages;
bool hosteller;

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class RegisterForm4 extends StatefulWidget {
  //taken from parent props:
  Map<String, dynamic> userMap;
  Function toggleView;
  RegisterForm4(this.userMap, {this.toggleView});

  @override
  _RegisterForm4State createState() => _RegisterForm4State(userMap);
}

class _RegisterForm4State extends State<RegisterForm4> {
  final Map<String, dynamic> userMap;
  _RegisterForm4State(this.userMap);

  final AuthService _auth = AuthService();
  final _formKey4 = GlobalKey<FormState>();

  //form fields

  String error = '';
  bool loading = false;

  void saveData() async {
    dynamic result = await _auth.register(
        userMap['name'],
        userMap['phoneNo'],
        userMap['email'],
        userMap['password'],
        userMap['year'],
        userMap['branch'],
        userMap['rollNo'],
        userMap['linkedInURL'],
        userMap['githubURL'],
        userMap['domains'],
        userMap['languages'],
        userMap['hosteller'],
        userMap['post']);
    if (result == null) {
      setState(() {
        error = 'some error message';
        loading = false;
      });
    }
    else{
      Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Wrapper(),
      ),
      (route) => false,
    );
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Wrapper()));
    }
  }

  int _hostellerValue = -1;

  void initState() {
    super.initState();
    domains = [];
    languages = [];
  }

  void _handleHostellerValue(int value) {
    setState(() {
      _hostellerValue = value;
      hosteller = _hostellerValue == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
          backgroundColor: AppColors.COLOR_TEAL_DARK,
          elevation: 0.0,
          title: Text("Register"),
          ),
      body: loading
          ? Loading()
          : Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                margin: EdgeInsets.all(8),
                child: new Container(
                    padding: EdgeInsets.all(15),
                    child: Form(
        key: _formKey4,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            new Text(userMap['post']=='Mentor'
                ? "Tell us about the domains you have worked in and the languages you know"
                : "What skills do you want in your mentor?"),
            new Divider(height: 12, color: Colors.transparent),
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
                dataSource: ScreenConstants.registerFieldData,
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
            new Divider(height: 0, color: Colors.transparent),
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
                dataSource: ScreenConstants.registerLanguageData,
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
            new Divider(height: 0, color: Colors.transparent),
            new Text(userMap['post']=='Mentor'
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
                child: RaisedButton(
                                color: AppColors.COLOR_TEAL_LIGHT,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(
                                        color: AppColors.COLOR_TEAL_LIGHT)),
                                child: Text("Next"),
                                onPressed: () {
                                  if (_formKey4.currentState.validate() &&
                        _hostellerValue != -1) {
                      setState(() {
                        userMap['domains']=domains;
                        userMap['languages']=languages;
                        userMap['hosteller']=hosteller;
                        print(userMap);
                        saveData();
                      });
                      // If the form is valid, display a Snackbar.
                      // Scaffold.of(context).showSnackBar(
                      //     SnackBar(content: Text('Data is in processing.')));
                    }
                                }),
                ),
          ],
        ),
      ),
                    ),
              ),
            ),
    );
  }
}
