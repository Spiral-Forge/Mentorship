import 'package:dbapp/blocs/theme.dart';
import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/screenConstants.dart';
import 'package:dbapp/screens/ResourceCenter/category.dart';
import 'package:dbapp/screens/ResourceCenter/resourceList.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dbapp/screens/authenticate/authenticate.dart';
import 'package:dbapp/screens/sidebarScreens/about.dart';
import 'package:dbapp/screens/sidebarScreens/faqs.dart';
import 'package:dbapp/screens/sidebarScreens/feedback.dart';
import 'package:dbapp/screens/sidebarScreens/guidelines.dart';
import 'package:dbapp/services/auth.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:dbapp/screens/myDrawer.dart';

final myDrawer _drawer = new myDrawer();

class ResourceCategoryList extends StatefulWidget {
  @override
  _ResourceCategoryListState createState() => _ResourceCategoryListState();
}

//"assets/images/bg2.jpg"
class _ResourceCategoryListState extends State<ResourceCategoryList> {
  final _formKey = GlobalKey<FormState>();
  String post = '';
  TextEditingController titleController = new TextEditingController();
  TextEditingController linkController = new TextEditingController();

  String _value;

  //  String selectedName='';
  //  String selectedCollectionID='';

  @override
  void initState() {
    getPostStatus();
    super.initState();
  }

  void getPostStatus() {
    StorageServices.getUserPost().then((value) {
      setState(() {
        post = value;
      });
    });
  }

  var selectedType;
  Map<String, String> fieldMap = ScreenConstants.resourceFieldMap;

  List<String> fields = ScreenConstants.resourceFields;

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    // final _themeChanger = Provider.of<ThemeChanger>(context);
    return new Scaffold(
        appBar: AppBar(
            title: Text("Resource Center"),
            backgroundColor: AppColors.COLOR_TEAL_LIGHT,
            elevation: 0.0,
            actions: post == "Mentee" || post == ""
                ? null
                : <Widget>[
                    FlatButton.icon(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: Text(''),
                        onPressed: () async {
                          await showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Stack(
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        Positioned(
                                          right: -35.0,
                                          top: -35.0,
                                          child: InkResponse(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: CircleAvatar(
                                              child: Icon(
                                                Icons.close,
                                                size: 15,
                                              ),
                                              backgroundColor:
                                                  AppColors.PROTEGE_GREY,
                                              foregroundColor: Colors.white,
                                              radius: 15,
                                            ),
                                          ),
                                        ),
                                        Form(
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                TextField(
                                                  controller: titleController,
                                                  decoration: InputDecoration(
                                                    icon: Icon(Icons.title),
                                                    labelText: 'Title',
                                                  ),
                                                ),
                                                TextField(
                                                  controller: linkController,
                                                  decoration: InputDecoration(
                                                    icon: Icon(Icons.link),
                                                    labelText: 'Link',
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(Icons.adb,
                                                        color: Colors.grey),
                                                    SizedBox(
                                                      width: 15.0,
                                                    ),
                                                    DropdownButton(
                                                      items: fields
                                                          .map((value) =>
                                                              DropdownMenuItem(
                                                                child: Text(
                                                                  value,
                                                                  // style: TextStyle(color: Color(0xff11b719)),
                                                                ),
                                                                value: value,
                                                              ))
                                                          .toList(),
                                                      onChanged:
                                                          (selectedField) {
                                                        print('$selectedField');
                                                        setState(() {
                                                          selectedType =
                                                              selectedField;
                                                        });
                                                      },
                                                      value: selectedType,
                                                      isExpanded: false,
                                                      hint: Text(
                                                        'Resource Category',
                                                        //style: TextStyle(color: Color(0xff11b719)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                    color: AppColors
                                                        .COLOR_TEAL_LIGHT,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            side: BorderSide(
                                                              color: AppColors
                                                                  .COLOR_TEAL_LIGHT,
                                                            )),
                                                    child: Text("Submit"),
                                                    onPressed: () async {
                                                      // if (_formKey.currentState.validate()) {
                                                      var result =
                                                          await DataBaseService()
                                                              .addResource(
                                                                  fieldMap[
                                                                      selectedType],
                                                                  titleController
                                                                      .text,
                                                                  linkController
                                                                      .text);
                                                      if (result == null) {
                                                        //toast and close
                                                        print(
                                                            "some error occured");
                                                        titleController.text =
                                                            '';
                                                        linkController.text =
                                                            '';
                                                        Navigator.of(context)
                                                            .pop();
                                                        Toast.show(
                                                            "Some error occured. Please try again later.",
                                                            context,
                                                            duration: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                Toast.BOTTOM);
                                                      } else {
                                                        //toast and close
                                                        print(result);
                                                        titleController.text =
                                                            '';
                                                        linkController.text =
                                                            '';
                                                        Navigator.of(context)
                                                            .pop();
                                                        Toast.show(
                                                            "Resources successfully added!",
                                                            context,
                                                            duration: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                Toast.BOTTOM);
                                                      }
                                                      //print(fieldMap[selectedType]);
                                                      //_formKey.currentState.save();
                                                      //}
                                                    },
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        })
                  ]),
        drawer: _drawer,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResourceList(
                                    "Development Resources",
                                    fieldMap["Development"])));
                      },
                      child: ResourceCategoryTile(
                          "Development", "assets/images/development.png")),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResourceList(
                                    "College Resources", fieldMap["College"])));
                      },
                      child: ResourceCategoryTile(
                          "College Resources", "assets/images/book.jpg"))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResourceList(
                                    "Machine Learning Resources",
                                    fieldMap["Machine Learning"])));
                      },
                      child: ResourceCategoryTile(
                          "Machine Learning", "assets/images/ml.png")),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResourceList(
                                    "Scholarship Resources",
                                    fieldMap["Scholarship"])));
                      },
                      child: ResourceCategoryTile(
                          "Scholarships", "assets/images/scholar.jpg"))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResourceList(
                                    "Competitive Coding resources",
                                    fieldMap["Competitive Coding"])));
                      },
                      child: ResourceCategoryTile(
                          "Competitive Coding", "assets/images/code.jpg")),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResourceList(
                                    "Open-Source Resources",
                                    fieldMap["Open-Source"])));
                      },
                      child: ResourceCategoryTile(
                          "Open-Source", "assets/images/opensrc.png"))
                ],
              )
            ],
          ),
        ));
  }
}

void onThemeChanged(bool value, ThemeChanger _themeChanger) async {
  (value)
      ? _themeChanger.setTheme(darkTheme)
      : _themeChanger.setTheme(lightTheme);
}
