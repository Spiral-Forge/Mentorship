import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/sidebarConstants.dart';
import 'package:dbapp/services/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:toast/toast.dart';
import '../../services/auth.dart';

enum FeedbackOption { login, suggestion, complaint, other }
var feedbackopt = 1;

class MyFeedback extends StatefulWidget {
  @override
  _MyFeedbackState createState() => _MyFeedbackState();
}

class _MyFeedbackState extends State<MyFeedback> {
  final TextEditingController textController = new TextEditingController();

  final AuthService _auth = AuthService();
  Map<String, dynamic> user;
  final FirebaseAuth _authUser = FirebaseAuth.instance;
  Future<FirebaseUser> getCurrentUser() {
    return _authUser.currentUser();
  }

  Map<int, String> feedbackOption = SidebarConstants.feedbackOptionsMap;
  String uid = "";

  @override
  void initState() {
    super.initState();
    setUser();
  }

  void setUser() async {
    await StorageServices.getUserInfo().then((userInfo) {
      print(userInfo);
      setState(() {
        user = userInfo;
      });
    });
  }

  submitFeedback() {
    if (textController.text.isNotEmpty) {
      sendMail();
      /**
       * Uncomment for saving into DB
       */
      //  DataBaseService().addFeedback(feedbackMap).then((value) {
      //    if(value!=null){
      //      Toast.show("Thank you for your feedback", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      //    }else{
      //      Toast.show("Some error occured. Please try again later.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      //    }
      //  });
    } else {
      Toast.show("Feedback cannot be empty. Please try again.", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void sendMail() async {
    String mailBody = "<br><br>" +
        user["name"] +
        "<br>" +
        user["year"] +
        " year " +
        user["branch"] +
        "<br>";
    final MailOptions mailOptions = MailOptions(
      body: textController.text + mailBody,
      subject: "Protege App Feedback: " + feedbackOption[feedbackopt],
      recipients: SidebarConstants.feedbackRecipients,
      isHTML: true,
      ccRecipients: SidebarConstants.feedbackCCRecipients,
    );
    try {
      await FlutterMailer.send(mailOptions);
      setState(() {
        textController.text = "";
        feedbackopt = 1;
      });
      Toast.show("Thank you for your feedback", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } on PlatformException catch (error) {
      print(error.toString());
      Toast.show("Some error occured. Please try again later.", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } catch (error) {
      print(error.toString());
      Toast.show("Some error occured. Please try again later.", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Feedback"),
          backgroundColor: AppColors.COLOR_TEAL_LIGHT),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(32, 32, 32, 32),
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Select type of feedback:",
            style: TextStyle(
              //color: Colors.black,
              fontFamily: 'GoogleSans',
              fontStyle: FontStyle.italic,
              fontSize: 25,
            ),
          ),
          SizedBox(height: 20.0),
          BuildCheckBox(),
          SizedBox(height: 20.0),
          buildFeedbackForm(),
          SizedBox(height: 20.0),
          Spacer(),
          Row(children: <Widget>[
            Expanded(
                child: FlatButton(
              onPressed: () {
                submitFeedback();
                //sendMail();
              },
              color: AppColors.COLOR_TEAL_LIGHT,
              padding: EdgeInsets.all(16.0),
              child: Text(
                "SUBMIT",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'GoogleSans',
                    fontSize: 20),
              ),
            ))
          ])
        ],
      ),
    );
  }

  buildFeedbackForm() {
    return Container(
        height: 200.0,
        child: Stack(children: <Widget>[
          TextField(
            controller: textController,
            maxLines: 10,
            decoration: InputDecoration(
                hintText: "Please breifly describe the issue",
                hintStyle: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xffc5c5c5),
                    fontStyle: FontStyle.italic,
                    fontFamily: 'GoogleSans'),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffe5e5e5)),
                )),
          ),
        ]));
  }
}

class BuildCheckBox extends StatefulWidget {
  BuildCheckBox({Key key}) : super(key: key);

  @override
  _BuildCheckBoxState createState() => _BuildCheckBoxState();
}

class _BuildCheckBoxState extends State<BuildCheckBox> {
  FeedbackOption _character = FeedbackOption.login;

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Login Problem',
              style: TextStyle(fontFamily: 'GoogleSans', fontSize: 20)),
          leading: Radio(
            value: FeedbackOption.login,
            groupValue: _character,
            onChanged: (FeedbackOption value) {
              setState(() {
                _character = value;
                feedbackopt = 1;
              });
            },
          ),
        ),
        ListTile(
          title: const Text(
            'Suggestions',
            style: TextStyle(fontFamily: 'GoogleSans', fontSize: 20),
          ),
          leading: Radio(
            value: FeedbackOption.suggestion,
            groupValue: _character,
            onChanged: (FeedbackOption value) {
              setState(() {
                _character = value;
                feedbackopt = 2;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Complaints',
              style: TextStyle(fontFamily: 'GoogleSans', fontSize: 20)),
          leading: Radio(
            value: FeedbackOption.complaint,
            groupValue: _character,
            onChanged: (FeedbackOption value) {
              setState(() {
                _character = value;
                feedbackopt = 3;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Other issues',
              style: TextStyle(fontFamily: 'GoogleSans', fontSize: 20)),
          leading: Radio(
            value: FeedbackOption.other,
            groupValue: _character,
            onChanged: (FeedbackOption value) {
              setState(() {
                _character = value;
                feedbackopt = 4;
              });
            },
          ),
        ),
      ],
    );
  }
}
