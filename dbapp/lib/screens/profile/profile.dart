import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dbapp/services/auth.dart';
import 'package:dbapp/screens/sidebarScreens/about.dart';
import 'package:dbapp/screens/sidebarScreens/faqs.dart';
import 'package:dbapp/screens/sidebarScreens/feedback.dart';
import 'package:dbapp/screens/sidebarScreens/guidelines.dart';

// void main() => runApp(profile());

// class myapp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,   
//       theme: ThemeData(fontFamily: 'GoogleSans'),
//       home: new profile(),
//     );
//   }
// }

class profile extends StatefulWidget {
  @override
  _profileState createState() => new _profileState();
}

class _profileState extends State<profile> {
   final AuthService _auth=AuthService();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title:Text("Your Profile"),
        backgroundColor:Colors.brown[400] ,
        elevation: 0.0,
        // actions: <Widget>[
        //   FlatButton.icon(
        //     onPressed: () async{
        //       await _auth.signOut();
        //     }, 
        //     icon: Icon(Icons.person),
        //     label:Text('logout')
        //     )
        // ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
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
              title: new Text("Guidelines"),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Guidelines()));
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
              title: new Text("Logout"),
              trailing: new Icon(Icons.people),
              onTap: () async => await _auth.signOut()
            ),
          ],
        ),
      ),
      body: new Stack(
        children: <Widget>[
          
          ClipPath(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/profilebg.jpg"),
                ),
              ),
              // color: Hexcolor('#565656'),
            ),

            clipper: getClipper(),
          ),
          Positioned(
            
            width: MediaQuery.of(context).size.width ,
            top: MediaQuery.of(context).size.height / 4.5,
            child: Column(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                      image: AssetImage("assets/images/profilebg.jpg"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(175.0)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7.0,
                        color: Colors.black,
                      )
                    ]
                  ),
                ),
                SizedBox( height: 40),
                Text(
                  'Your Name',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Hexcolor('#565656'),
                      //fontFamily: GoogleFonts,
                      fontSize: 28,
                    ),
                  ),
                ),
                SizedBox( height: 8),
                Text(
                  'Mentee',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Hexcolor('#96ece7'),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                SizedBox( height: 15),
                Text(
                  'myemail@gmail.com',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),
                
                SizedBox( height: 12),
                Text(
                  '9758548569',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 12),
                Text(
                  'Year, Branch',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 12),
                Text(
                  '00001032018',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 12),
                Text(
                  'linkedin.com/mylinkedin',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 12),
                Text(
                  'github.com/mygithub',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 12),
                Text(
                  'Languages: C++',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox( height: 12),
                Text(
                  'Domains: Android Development',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 12),
                Text(
                  'Hosteller: Yes',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Hexcolor('#565656'),
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox( height: 30),
                Container(
                  height: 30,
                  width: 95,
                  child: Material(
                    borderRadius: BorderRadius.circular(25),
                    shadowColor: Colors.blueGrey,
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Center(
                        child: Text(
                          'Edit Info',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Hexcolor('#96ece7'),
                            ),
                          ),
                        ),
                      ),
                      
                    ),
                  ),
                ),
              ],
            ) 
          )
          
        ],        
      ),
    );
  }
}

class getClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    var path = new Path();
    path.lineTo(0.0, size.height/2.3);
    path.lineTo(size.width + 350, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return true;
  }
}
