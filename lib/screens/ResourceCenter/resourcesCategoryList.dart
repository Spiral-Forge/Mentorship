import 'package:dbapp/blocs/theme.dart';
import 'package:dbapp/blocs/values.dart';
import 'package:dbapp/screens/ResourceCenter/category.dart';
import 'package:dbapp/screens/ResourceCenter/resourceList.dart';
import 'package:dbapp/screens/sidebarScreens/about.dart';
import 'package:dbapp/screens/sidebarScreens/faqs.dart';
import 'package:dbapp/screens/sidebarScreens/feedback.dart';
import 'package:dbapp/screens/sidebarScreens/guidelines.dart';
import 'package:dbapp/services/auth.dart';
import 'package:dbapp/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResourceCategoryList extends StatefulWidget {
  @override
  _ResourceCategoryListState createState() => _ResourceCategoryListState();
}
//"assets/images/bg2.jpg"
class _ResourceCategoryListState extends State<ResourceCategoryList> {
   var _darkTheme = true;
   final _formKey = GlobalKey<FormState>();
   String post='';

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

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    // final _themeChanger = Provider.of<ThemeChanger>(context);
    _darkTheme = (_themeChanger.getTheme() == darkTheme);
    final AuthService _auth=AuthService();
    return new Scaffold(
      appBar: AppBar(
        title:Text("Resource Center"),
        backgroundColor:Colors.teal[300] ,
        elevation: 0.0,
        actions: post=="Mentee" || post=="" ? null: <Widget>[
          FlatButton.icon(
            icon:Icon(Icons.add,color: Colors.white,),
            label:Text(''),
            onPressed: (){
               showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Stack(
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
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                               TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.title),
                                  labelText: 'Title',
                                ),
                              ),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.description),
                                  labelText: 'Description',
                                ),
                              ),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.link),
                                  labelText: 'Link',
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.all(8.0),
                              //   child: TextFormField(),
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.all(8.0),
                              //   child: TextFormField(),
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text("Submitß"),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
            },
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
              //             color: Hexcolor('#565656'),
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
              onTap: () async => await _auth.signOut()
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
                      builder: (context) => ResourceList("App Development Resources","AppDev")
                      ));
                  },
                  child: ResourceCategoryTile("App Development","assets/images/bg2.jpg")
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ResourceList("College Resources","College")
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
                      builder: (context) => ResourceList("Machine Learning Resources","ML")
                      ));
                  },
                  child: ResourceCategoryTile("Machine Learning","assets/images/bg2.jpg")
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ResourceList("AR/VR Resources","ARVR")
                      ));
                  },
                  child: ResourceCategoryTile("AR/VR","assets/images/bg2.jpg")
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ResourceList("Competitive Coding resources","CompCoding")
                      ));
                  },
                  child: ResourceCategoryTile("Competitive Coding","assets/images/bg2.jpg")
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ResourceList("Web Development Resources","WebDev")
                      ));
                  },
                  child: ResourceCategoryTile("Web Development","assets/images/bg2.jpg")
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
    // var prefs = await SharedPreferences.getInstance();
    // prefs.setBool('darkMode', value);
}

