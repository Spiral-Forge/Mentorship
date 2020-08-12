import 'package:dbapp/blocs/theme.dart';
import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/constants/screenConstants.dart';
import 'package:dbapp/screens/ResourceCenter/category.dart';
import 'package:dbapp/screens/ResourceCenter/resourceList.dart';
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

class ResourceCategoryList extends StatefulWidget {
  @override
  _ResourceCategoryListState createState() => _ResourceCategoryListState();
}
//"assets/images/bg2.jpg"
class _ResourceCategoryListState extends State<ResourceCategoryList> {
   var _darkTheme = true;
   final _formKey = GlobalKey<FormState>();
   String post='';
   TextEditingController titleController=new TextEditingController();
   TextEditingController linkController=new TextEditingController();
  
  String _value;

  //  String selectedName='';
  //  String selectedCollectionID='';

   @override
   void initState(){
     getPostStatus();
     super.initState();
   }


   void getPostStatus(){
     StorageServices.getUserPost().then((value) {
       setState(() {
         post=value;
       });
     });
   }

  var selectedType;
  Map<String,String> fieldMap=ScreenConstants.resourceFieldMap;
   
  List<String> fields = ScreenConstants.resourceFields;

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    // final _themeChanger = Provider.of<ThemeChanger>(context);
    _darkTheme = (_themeChanger.getTheme() == darkTheme);
    final AuthService _auth=AuthService();
    return new Scaffold(
      appBar: AppBar(
        title:Text("Resource Center"),
        backgroundColor:AppColors.COLOR_TEAL_LIGHT,
        elevation: 0.0,
        actions: post=="Mentee" || post=="" ? null: <Widget>[
          FlatButton.icon(
            icon:Icon(Icons.add,color: Colors.white,),
            label:Text(''),
            onPressed: () async{
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
                                    right: -40.0,
                                    top: -40.0,
                                    child: InkResponse(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: CircleAvatar(
                                        child: Icon(Icons.close),
                                        backgroundColor: Colors.red,
                                      ),
                                    ),
                                  ),
                                Form(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
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
                                      SizedBox(height: 15.0,),
                                      Row(
                                        children: <Widget>[
                                          Icon(Icons.adb,color:Colors.grey),
                                          SizedBox(width: 15.0,),
                                          DropdownButton(
                                            items: fields
                                                .map((value) => DropdownMenuItem(
                                                      child: Text(
                                                        value,
                                                        // style: TextStyle(color: Color(0xff11b719)),
                                                      ),
                                                      value: value,
                                                    ))
                                                .toList(),
                                            onChanged: (selectedField) {
                                              print('$selectedField');
                                              setState(() {
                                                selectedType = selectedField;
                                              });
                                            },
                                            value: selectedType,
                                            isExpanded: false,
                                            hint: Text(
                                              'Choose Resource Type',
                                              //style: TextStyle(color: Color(0xff11b719)),
                                            ),
                                          ),
                                          
                                        ],
                                      ),
                                      SizedBox(height: 15.0,),
                                      Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                              child: Text("Submitß"),
                                              onPressed: () async{
                                               // if (_formKey.currentState.validate()) {
                                                  var result=await DataBaseService().addResource(fieldMap[selectedType],titleController.text,linkController.text);
                                                  if(result==null){
                                                    //toast and close
                                                    print("some error occured");
                                                    titleController.text='';
                                                    linkController.text='';
                                                    Navigator.of(context).pop();
                                                    Toast.show("Some error occured. Please try again later.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                                                    
                                                  }else{
                                                    //toast and close
                                                    print(result);
                                                    titleController.text='';
                                                    linkController.text='';
                                                    Navigator.of(context).pop();
                                                    Toast.show("Resources successfully added!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                                                  }
                                                  //print(fieldMap[selectedType]);
                                                  //_formKey.currentState.save();
                                                //}
                                              },
                                            ),
                                          )
                                    ]
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  );
            }
          )
        ]
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new ListTile(
              title: new Text("Code of Conduct"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Guidelines()));
              }
            ),
            new ListTile(
              title: new Text("About"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new About()));
              }
            ),
            new ListTile(
              title: new Text("FAQs"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new FAQS()));
              }
            ),
            
            new ListTile(
              title: new Text("Contact us and feedback"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new MyFeedback()));
              }
            ),
             
            new Divider(),
            new ListTile(
              trailing: Transform.scale(
                scale: 1.4,
                child: Switch(
                  value: _darkTheme,
                  onChanged: (val) {
                    setState(() {
                      _darkTheme = val;
                    });
                    onThemeChanged(val, _themeChanger);
                  },
                ),
              ),
              // leading: new IconButton(
              //             onPressed: () => _themeChanger.setTheme(Theme.dark()),
              //             icon: Icon(
              //               Icons.brightness_3
              //             ),
              //             color: AppColors.PROTEGE_GREY,
              //           ),
              // title: new Text("Change Theme"),
              // onTap: () {
              //   Navigator.of(context).pop();
              //   Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ThemeChanger(ThemeData.dark())));
              // }
            ),           
            new Divider(),
            new ListTile(
              title: new Text("Logout"),
              trailing: new Icon(Icons.people),
              onTap: () async {
                await _auth.signOut();
              }
            ),
          ],
        ),
      ),
      body:SingleChildScrollView(
              child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ResourceList("Development Resources",fieldMap["Development"])
                      ));
                  },
                  child: ResourceCategoryTile("Development","assets/images/bg2.jpg")
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ResourceList("College Resources",fieldMap["College"])
                      ));
                  },
                  child: ResourceCategoryTile("College assignments and papers","assets/images/bg2.jpg")
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ResourceList("Machine Learning Resources",fieldMap["Machine Learning"])
                      ));
                  },
                  child: ResourceCategoryTile("Machine Learning","assets/images/bg2.jpg")
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ResourceList("Scholarship Resources",fieldMap["Scholarship"])
                      ));
                  },
                  child: ResourceCategoryTile("Scholarships","assets/images/bg2.jpg")
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ResourceList("Competitive Coding resources",fieldMap["Competitive Coding"])
                      ));
                  },
                  child: ResourceCategoryTile("Competitive Coding","assets/images/bg2.jpg")
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ResourceList("Open-Source Resources",fieldMap["Open-Source"])
                      ));
                  },
                  child: ResourceCategoryTile("Open-Source","assets/images/bg2.jpg")
                )
              ],
            )
          ],
        ),
      )
    );
  }
}

void onThemeChanged(bool value, ThemeChanger _themeChanger) async {
  (value) ? _themeChanger.setTheme(darkTheme) : _themeChanger.setTheme(lightTheme);
}

