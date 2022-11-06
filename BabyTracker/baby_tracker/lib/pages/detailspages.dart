import 'package:baby_tracker/pages/calendar.dart';
import 'package:baby_tracker/pages/eventlist.dart';
import 'package:baby_tracker/pages/statistics.dart';
import 'package:flutter/material.dart';
import '../createevent.dart';

class DetailsPages extends StatelessWidget {
  const DetailsPages({Key? key}) : super(key: key);

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
