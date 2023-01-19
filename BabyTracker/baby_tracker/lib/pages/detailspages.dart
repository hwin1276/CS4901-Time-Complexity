import 'package:baby_tracker/pages/calendar.dart';
import 'package:baby_tracker/pages/eventlist.dart';
import 'package:baby_tracker/pages/statistics.dart';
import 'package:baby_tracker/pages/edit_baby.dart';
import 'package:baby_tracker/objects/event.dart';
import 'package:baby_tracker/service/database_service.dart';
import 'package:flutter/material.dart';
import '../createevent.dart';

class DetailsPages extends StatefulWidget {
  final String userName;
  final String babyName;
  final String babyId;
  final String theme;
  const DetailsPages({
    Key? key,
    required this.userName,
    required this.babyName,
    required this.babyId,
    required this.theme,
  }) : super(key: key);

  @override
  State<DetailsPages> createState() => _DetailsPagesState();
}

class _DetailsPagesState extends State<DetailsPages> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.babyName),
            bottom: TabBar(
              tabs: const [
                Tab(text: 'Calendar'),
                Tab(text: 'Events'),
                Tab(text: 'Statistics'),
                Tab(text: 'Edit'),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateEvent(
                            userName: widget.userName,
                            babyName: widget.babyName,
                            babyId: widget.babyId)));
              },
              child: const Icon(Icons.add)),
          body: TabBarView(children: [
            Calendar(
                userName: widget.userName,
                babyName: widget.babyName,
                babyId: widget.babyId),
            EventList(
                userName: widget.userName,
                babyName: widget.babyName,
                babyId: widget.babyId),
            Statistics(
              babyName: widget.babyName,
              babyId: widget.babyId,
              userName: widget.userName,
            ),
            Edit(babyId: widget.babyId),
          ])),
    );
  }
}
