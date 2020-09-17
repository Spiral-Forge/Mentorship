import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/sidebarConstants.dart';
import 'package:dbapp/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:toast/toast.dart';

enum FeedbackOption { login, suggestion, complaint, other }
var feedbackopt = 1;

class MyFeedback extends StatefulWidget {
  @override
  _MyFeedbackState createState() => _MyFeedbackState();
}

class _MyFeedbackState extends State<MyFeedback> {
  final TextEditingController textController = new TextEditingController();
  Map<String, dynamic> user;

  Map<int, String> feedbackOption = SidebarConstants.feedbackOptionsMap;
  String uid = "";

  @override
  void initState() {
    super.initState();
    setUser();
  }

  void setUser() async {
    await StorageServices.getUserInfo().then((userInfo) {
      setState(() {
        user = userInfo;
      });
    });
  }

  submitFeedback() {
    if (textController.text.isNotEmpty) {
      sendMail();
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
      Toast.show("Some error occured. Please try again later.", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } catch (error) {
      Toast.show("Some error occured. Please try again later.", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

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
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
                        child: Text("Feedback",
                            style: TextStyle(
                                fontFamily: 'GoogleSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 32)),
                      ),
                      SizedBox(height: 25),
                      Expanded(
                          child: SizedBox(
                              height: 120.0,
                              child: ListView(
                                padding:
                                    const EdgeInsets.fromLTRB(32, 0, 32, 0),
                                children: <Widget>[
                                  Text(
                                    "Select type of feedback:",
                                    style: TextStyle(
                                      fontFamily: 'GoogleSans',
                                      fontStyle: FontStyle.italic,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 30.0),
                                  BuildCheckBox(),
                                  buildFeedbackForm(),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        90, 8.0, 90, 0),
                                    child: Container(
                                      height: 45,
                                      child: FlatButton(
                                          color: AppColors.COLOR_TEAL_LIGHT,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              side: BorderSide(
                                                color:
                                                    AppColors.COLOR_TEAL_LIGHT,
                                              )),
                                          child: Text("Submit",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'GoogleSans',
                                                  fontSize: 15)),
                                          onPressed: () {
                                            submitFeedback();
                                          }),
                                    ),
                                  ),
                                ],
                              )))
                    ],
                  ))))
    ])
        );
  }

  buildFeedbackForm() {
    return Container(
        height: 200.0,
        child: Stack(children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 32, 0, 32),
            child: TextField(
              controller: textController,
              maxLines: 10,
              decoration: InputDecoration(
                  hintText: "Please breifly describe the issue",
                  hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xffc5c5c5),
                      fontStyle: FontStyle.italic,
                      fontFamily: 'GoogleSans'),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffe5e5e5)),
                  )),
            ),
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
              style: TextStyle(fontFamily: 'GoogleSans', fontSize: 18)),
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
            style: TextStyle(fontFamily: 'GoogleSans', fontSize: 18),
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
              style: TextStyle(fontFamily: 'GoogleSans', fontSize: 18)),
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
              style: TextStyle(fontFamily: 'GoogleSans', fontSize: 18)),
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
