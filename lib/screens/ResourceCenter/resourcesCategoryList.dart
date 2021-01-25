import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/screenConstants.dart';
import 'package:dbapp/screens/ResourceCenter/category.dart';
import 'package:dbapp/screens/ResourceCenter/resourceList.dart';
import 'package:dbapp/services/database.dart';
import 'package:dbapp/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:dbapp/shared/MyDrawer.dart';

final MyDrawer _drawer = new MyDrawer();

class ResourceCategoryList extends StatefulWidget {
  @override
  _ResourceCategoryListState createState() => _ResourceCategoryListState();
}

class _ResourceCategoryListState extends State<ResourceCategoryList> {
  String post = '';
  TextEditingController titleController = new TextEditingController();
  TextEditingController linkController = new TextEditingController();
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
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    return new Scaffold(
      drawer: _drawer,
      key: _scaffoldKey,
      body: Column(children: [
        Expanded(
            child: Container(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 42, 0, 0),
                        child: Row(children: [
                          IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () {
                                _scaffoldKey.currentState.openDrawer();
                              }),
                          Text(
                            "Resource Center",
                            style: TextStyle(
                                fontFamily: 'GoogleSans', fontSize: 23),
                          )
                        ]),
                      ),
                      Expanded(
                        child: ListView(children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              width: MediaQuery.of(context).size.width,
                              child: Column(children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ResourceList(
                                                          "Development Resources",
                                                          fieldMap[
                                                              "Development"])));
                                        },
                                        child: ResourceCategoryTile(
                                            "Development",
                                            "assets/images/development.png")),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ResourceList(
                                                          "College Resources",
                                                          fieldMap[
                                                              "College"])));
                                        },
                                        child: ResourceCategoryTile(
                                            "College Resources",
                                            "assets/images/book.jpg"))
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
                                                      fieldMap[
                                                          "Machine Learning"])));
                                        },
                                        child: ResourceCategoryTile(
                                            "Machine Learning",
                                            "assets/images/ml.png")),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ResourceList(
                                                          "Scholarship Resources",
                                                          fieldMap[
                                                              "Scholarship"])));
                                        },
                                        child: ResourceCategoryTile(
                                            "Scholarships",
                                            "assets/images/scholar.jpg"))
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
                                                        fieldMap[
                                                            "Competitive Coding"])));
                                          },
                                          child: ResourceCategoryTile(
                                              "Competitive Coding",
                                              "assets/images/code.jpg")),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ResourceList(
                                                            "Open-Source Resources",
                                                            fieldMap[
                                                                "Open-Source"])));
                                          },
                                          child: ResourceCategoryTile(
                                              "Open-Source",
                                              "assets/images/opensrc.png"))
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ResourceList(
                                                            "Blogs and Articles",
                                                            fieldMap[
                                                                "Blogs and Articles"])));
                                          },
                                          child: ResourceCategoryTile(
                                              "Blogs and Articles",
                                              "assets/images/blogs.png")),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ResourceList(
                                                        "Miscellaneous Resources",
                                                        fieldMap[
                                                            "Miscellaneous"])));
                                          },
                                          child: ResourceCategoryTile(
                                              "Miscellaneous",
                                              "assets/images/other.png"))
                                    ]),
                                SizedBox(height: 40),
                              ])),
                        ]),
                      )
                    ]))))
      ]),
      floatingActionButton: post == 'Mentor'
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                await showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
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
                                    backgroundColor: AppColors.protegeGrey,
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
                                          Icon(Icons.adb, color: Colors.grey),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          DropdownButton(
                                            items: fields
                                                .map(
                                                    (value) => DropdownMenuItem(
                                                          child: Text(
                                                            value,
                                                          ),
                                                          value: value,
                                                        ))
                                                .toList(),
                                            onChanged: (selectedField) {
                                              setState(() {
                                                selectedType = selectedField;
                                              });
                                            },
                                            value: selectedType,
                                            isExpanded: false,
                                            hint: Text(
                                              'Resource Category',
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          color: AppColors.colorTealLight,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              side: BorderSide(
                                                color: AppColors.colorTealLight,
                                              )),
                                          child: Text(
                                            "Submit",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () async {
                                            var result = await DataBaseService()
                                                .addResource(
                                                    fieldMap[selectedType],
                                                    titleController.text,
                                                    linkController.text);
                                            if (result == null) {
                                              titleController.text = '';
                                              linkController.text = '';
                                              Navigator.of(context).pop();
                                              Toast.show(
                                                  "Some error occured. Please try again later.",
                                                  context,
                                                  duration: Toast.LENGTH_SHORT,
                                                  gravity: Toast.BOTTOM);
                                            } else {
                                              titleController.text = '';
                                              linkController.text = '';
                                              Navigator.of(context).pop();
                                              Toast.show(
                                                  "Resources successfully added!",
                                                  context,
                                                  duration: Toast.LENGTH_SHORT,
                                                  gravity: Toast.BOTTOM);
                                            }
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
          : null,
    );
  }
}
