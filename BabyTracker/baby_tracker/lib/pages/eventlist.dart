import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:baby_tracker/widgets/event_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../service/database_service.dart';

class EventList extends StatefulWidget {
  const EventList({
    Key? key,
    required this.babyName,
    required this.babyId,
    required this.userName,
  }) : super(key: key);
  final String babyName;
  final String babyId;
  final String userName;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  Stream<QuerySnapshot>? events;

  @override
  void initState() {
    super.initState();
    getEventData();
  }

  getEventData() {
    DatabaseService().getEventData(widget.babyId).then((val) {
      setState(() {
        events = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: events,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return EventCard(
                      taskName: snapshot.data.docs[index]['task'],
                      taskType: snapshot.data.docs[index]['type'],
                      taskDescription: snapshot.data.docs[index]['description'],
                      taskStartTime:
                          snapshot.data.docs[index]['startTime'].toDate(),
                      taskEndTime:
                          snapshot.data.docs[index]['endTime'].toDate(),
                      calories: snapshot.data.docs[index]['calories'],
                      babyExcreta: snapshot.data.docs[index]['babyExcreta'],
                      duration: snapshot.data.docs[index]['duration']);
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'No data available right now',
                  style: AppTextTheme.body.copyWith(
                    color: AppColorScheme.white,
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColorScheme.white,
                ),
              );
            }
          }),
    );
  }
}
