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

  void getDeadlines() async {
    Map<DateTime, List<dynamic>> tempMap =
        await DataBaseService().mapDeadlines();
    setState(() {
      _events = tempMap;
    });

    print("events are");
    print(_events);
  }

  void getPost() async {
    StorageServices.getUserPost().then((val) {
      setState(() {
        post = val;
      });
    });
  }

  Widget deadlineList() {
    return _selectedEvents.length == null || _selectedEvents.length == 0
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
                  return ResourceTile(
                      _selectedEvents[index][0], _selectedEvents[index][1]);
                },
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    _showDialogue() {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Stack(overflow: Overflow.visible, children: <Widget>[
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
                      backgroundColor: AppColors.PROTEGE_GREY,
                      foregroundColor: Colors.white,
                      radius: 15,
                    ),
                  ),
                ),
                Form(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
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
                                    getDeadlines();
                                    _eventController.text = '';
                                    _linkController.text = '';
                                    Navigator.of(context).pop();
                                  }),
                            ),
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel"))
                          ])
                    ]))
              ]);
            }));
          });
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
                                  print(_events[date]);
                                  _events[date] == null
                                      ? _selectedEvents = []
                                      : _selectedEvents = _events[date];
                                  print("Today's events:");
                                  print(_selectedEvents);
                                });
                              },
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
                          child:
                              SizedBox(height: 150.0, child: deadlineList())),
                    ])))
      ]),
      floatingActionButton: post == 'Mentor'
          ? FloatingActionButton(
              onPressed: _showDialogue, child: Icon(Icons.add))
          : null,
    );
  }
}
