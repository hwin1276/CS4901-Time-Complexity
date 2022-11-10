import 'package:baby_tracker/pages/calendar.dart';
import 'package:baby_tracker/pages/eventlist.dart';
import 'package:baby_tracker/pages/statistics.dart';
import 'package:baby_tracker/objects/event.dart';
import 'package:flutter/material.dart';
import '../createevent.dart';

class DetailsPages extends StatefulWidget {
  const DetailsPages({Key? key}) : super(key: key);

  @override
  State<DetailsPages> createState() => _DetailsPagesState();
}

class _DetailsPagesState extends State<DetailsPages> {

  //Sample Data To be made into a pull from a database
  List<Event> events = [
    Event(id: 0, description: "blank1", startTime: DateTime.utc(2022,12,1,20,30), length: Duration(hours: 1, minutes: 30)),
    Event(id: 1, description: "blank2", startTime: DateTime.utc(2022,12,2,21,30), length: Duration(hours: 1, minutes: 30)),
    Event(id: 2, description: "blank3", startTime: DateTime.utc(2022,12,3,22,30), length: Duration(hours: 1, minutes: 30)),
    Event(id: 3, description: "blank4", startTime: DateTime.utc(2022,12,4,10,30), length: Duration(hours: 1)),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Baby\'s Details'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Calendar'),
              Tab(text: 'Events'),
              Tab(text: 'Statistics'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateEvent()
                  )
              );
            },
          child: const Icon(Icons.add)
        ),
        body: TabBarView(
          children: [
            Calendar(),
            EventList(),
            Statistics(),
          ]
        )
      ),
    );
  }
}
