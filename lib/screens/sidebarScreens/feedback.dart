import 'package:flutter/material.dart';

class MyFeedback extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Feedback"), backgroundColor: Colors.redAccent),
      body: Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
          
        Text(
          "Please select type of feedback",style: TextStyle(
            color: Color(0xFFC5C5C5)),
        ),

        SizedBox(height: 25.0),
        buildCheckItem("Login Trouble"),
        buildCheckItem("Other Issues"),
        buildCheckItem("Suggestions"),
        buildCheckItem("Complaints"),
        SizedBox(height: 20.0),
        buildFeedbackForm(),
        SizedBox(height:20.0),
        buildNumberField(),
        Spacer(),
        Row(
          children:<Widget>[
            Expanded(
              child: FlatButton(
                onPressed: (){},
                color: Color(0xffe5e5e5),
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "SUBMIT",
                  style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                ),
              )
            )
          ]
        )
      ],
    ),
  ),
    );
  }
}

buildNumberField(){
  return TextField(
    style: TextStyle(
      color: Colors.black,

    ),
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(0.0),
      prefixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(border: Border(
              right: BorderSide(width: 1.0,color: Color(0xffc5c5c5))

            ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:<Widget>[
                SizedBox(width: 10.0),
                Text("+91",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:Color(0xffc5c5c5),
                ),
                ),
                Icon(Icons.arrow_drop_down,color: Colors.cyan,),
                SizedBox(width:10.0),

              ],
            ),

          ),

          SizedBox(width: 10.0),
        ],
        ),

        hintStyle: TextStyle(
          fontSize:14.0,
          color: Color(0xffc5c5c5),

        ),
        hintText: "Phone Number",
        border: OutlineInputBorder(),
    ),
  );
}

buildFeedbackForm(){
  return Container(
    height: 200.0,
    child: Stack(
      children:<Widget>[
        TextField(
          maxLines: 10,
          decoration: InputDecoration(
            hintText: "Please breifly describe the issue",
            hintStyle: TextStyle(
              fontSize:13.0,
              color: Color(0xffc5c5c5),

               ),
               border: OutlineInputBorder(
                 borderSide: BorderSide(color: Color(0xffe5e5e5)),

               )
          ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1.0,
                    color: Color(0xffa6a6a6),

                  ),
                   ),

              ),
              padding: EdgeInsets.all(8.0),
              child: Row(
                children:<Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xffe5e5e5),
                      borderRadius: BorderRadius.circular(5.0),

                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.add,
                        color: Color(0xffa5a5a5),

                      ),
                      ),
                    ),
                    SizedBox(width:10.0),
                    Text("Upload screenshot (OPTIONAL)",style: TextStyle(
                      color:Color(0xffc5c5c5),
                     ),
                    ),
                ]
              ),
              ),

          )
      ]
    )
  );
}

buildCheckItem(title){
  return Padding(
    padding: EdgeInsets.only(bottom: 15.0),
    child: Row(
     children: <Widget>[
       Icon(Icons.check_circle,color: Colors.blue),
       SizedBox(width: 10.0),
       Text(
         title,
         style: TextStyle(
           fontWeight: FontWeight.bold,
           color: Colors.blue,
         ),
        ),
      ]
    ),
  );
}