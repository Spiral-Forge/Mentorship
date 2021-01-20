import 'package:dbapp/constants/colors.dart';
import 'package:dbapp/screens/ResourceCenter/resource.dart';
import 'package:dbapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dbapp/services/storage.dart';

class DateView extends StatefulWidget {
  @override
  _DateViewState createState() => _DateViewState();
}

class _DateViewState extends State<DateView> {
  String post = '';

  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  TextEditingController _linkController;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = new TextEditingController();
    _linkController = new TextEditingController();
    _selectedEvents = [];
    setState(() {});
    getDeadlines();
    getPost();
  }

  Map<DateTime, List<dynamic>> decodeMap(Map<String, List<dynamic>> map) {
    print("HELLO?");
    print(map);
    Map<DateTime, List<dynamic>> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    print("IM HERE");
    print(newMap);
    return newMap;
  }

  void getDeadlines() async {
    var tempMap = await DataBaseService().mapDeadlines();
    _events = decodeMap(tempMap);
  }

  void getPost() async {
    StorageServices.getUserPost().then((val) {
      setState(() {
        post = val;
      });
    });
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> events) {
    Map<String, dynamic> newMap = {};
    events.forEach((key, value) {
      newMap[key.toString()] = events[key];
    });
    return newMap;
  }

  Widget deadlineList() {
    return _selectedEvents.length == 0
        ? Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "No deadlines on this day",
                style: TextStyle(fontFamily: 'GoogleSans', fontSize: 18),
              ),
            ),
          )
        : Expanded(
            child: SizedBox(
              height: 20.0,
              child: new ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _selectedEvents.length,
                itemBuilder: (context, index) {
                  return ResourceTile(_selectedEvents[index].data["Title"],
                      _selectedEvents[index].data["Link"]);
                },
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    _showDialogue() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  content: Column(children: [
                    TextField(
                      controller: _eventController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.title),
                        labelText: 'Title',
                      ),
                    ),
                    TextField(
                      controller: _linkController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.link),
                        labelText: 'Link',
                      ),
                    ),
                  ]),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          color: AppColors.COLOR_TEAL_LIGHT,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: AppColors.COLOR_TEAL_LIGHT,
                              )),
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            print(_controller.selectedDay);
                            DataBaseService().addDeadline(
                                _controller.selectedDay,
                                _eventController.text,
                                _linkController.text);
                            _eventController.text = '';
                            _linkController.text = '';
                            Navigator.of(context).pop();
                          }),
                    ),
                    FlatButton(
                        onPressed: () {
                          // if (_eventController.text.isEmpty) return;
                          // setState(() {
                          //   if (_events[_controller.selectedDay] != null) {
                          //     _events[_controller.selectedDay]
                          //         .add({_eventController.text, link});
                          //   } else {
                          //     _events[_controller.selectedDay] = [
                          //       _eventController.text
                          //     ];
                          //   }
                          //   _eventController.clear();
                          Navigator.pop(context);
                          // })
                        },
                        child: Text("Cancel"))
                  ]));
    }

    return Scaffold(
      body: Column(children: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 32),
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),

                      SizedBox(height: 25),
                      Text("Don't Miss Deadlines!",
                          style: TextStyle(
                              fontFamily: 'GoogleSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 32)),
                      Center(
                          child: TableCalendar(
                              events: _events,
                              headerStyle: HeaderStyle(),
                              onDaySelected: (date, events, hols) {
                                print(date);
                                setState(() {
                                  DataBaseService()
                                      .getTodaysDeadlines(
                                          date.toIso8601String())
                                      .then((value) {
                                    setState(() {
                                      _selectedEvents = value.documents;
                                    });
                                  });
                                  print("EVENTS:");
                                  print(_selectedEvents);
                                });
                              },
                              // onDayLongPressed: (day, events, holidays) {
                              //   print(day.toIso8601String());
                              // },
                              calendarStyle: CalendarStyle(
                                  todayColor: AppColors.COLOR_TEAL_DARK),
                              builders: CalendarBuilders(
                                  selectedDayBuilder: (context, date, events) =>
                                      Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: AppColors.COLOR_TEAL_LIGHT,
                                              shape: BoxShape.circle),
                                          child: Text(date.day.toString()))),
                              calendarController: _controller)),

                      Expanded(
                          child: SizedBox(height: 100.0, child: deadlineList()
                              // ListView.builder(
                              //     itemCount: _selectedEvents.length,
                              //     itemBuilder: (context, index) {
                              //       return ListTile(
                              //           title: Text(
                              //         _selectedEvents[index],
                              //         style: TextStyle(color: Colors.black),
                              //       ));
                              //     })
                              )),
                      SizedBox(height: 25),
                      // Expanded(
                      //     child: SizedBox(
                      //         height: 120.0,
                      //         child: ListView(
                      //             padding: const EdgeInsets.fromLTRB(
                      //                 32, 0, 32, 0),
                      //             children: <Widget>[
                      //               _selectedEvents.map((e) => ListTile(
                      //                 title: Text(e),
                      //               ))

                      //             )
                      //             ]))),
                      //   Expanded(
                      //       child: SizedBox(
                      //           height: 120.0,
                      //           child: ListView(
                      //               padding:
                      //                   const EdgeInsets.fromLTRB(32, 0, 32, 0),
                      //               children: <Widget>[
                      //                 Center(child: Text("Title: ")),
                      //                 Row(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.spaceEvenly,
                      //                   children: [
                      //                     Text("Start Date"),
                      //                     Text("End Date")
                      //                   ],
                      //                 ),
                      //                 Center(
                      //                   child: RaisedButton(
                      //                       child: Text("Dates"),
                      //                       onPressed: () async {
                      //                         // await dateRangePicker(context);
                      //                       }),
                      //                 )
                      //               ])))
                      // ])))
                    ])))
      ]),
      floatingActionButton: post == 'Mentor'
          ? FloatingActionButton(
              onPressed: _showDialogue, child: Icon(Icons.add))
          : null,
    );
  }
}
