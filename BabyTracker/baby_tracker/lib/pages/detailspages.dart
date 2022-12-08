import 'package:baby_tracker/pages/babyinfopage.dart';
import 'package:baby_tracker/pages/calendar.dart';
import 'package:baby_tracker/pages/eventlist.dart';
import 'package:baby_tracker/pages/statistics.dart';
import 'package:flutter/material.dart';
import '../createevent.dart';

class DetailsPages extends StatefulWidget {
  final String userName;
  final String babyName;
  final String babyId;
  const DetailsPages({Key? key, required this.userName, required this.babyName, required this.babyId}) : super(key: key);

  @override
  State<DetailsPages> createState() => _DetailsPagesState();
}

class _DetailsPagesState extends State<DetailsPages> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.babyName),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Calendar'),
                Tab(text: 'Events'),
                Tab(text: 'Statistics'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.info),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BabyInfoPage(userName: widget.userName, babyName: widget.babyName, babyId: widget.babyId)));
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateEvent(userName: widget.userName, babyName: widget.babyName, babyId: widget.babyId)));
              },
              child: const Icon(Icons.add)),
          body: TabBarView(children: [
            Calendar(),
            EventList(userName: widget.userName, babyName: widget.babyName, babyId: widget.babyId),
            Statistics(),
          ])),
    );
  }
}
