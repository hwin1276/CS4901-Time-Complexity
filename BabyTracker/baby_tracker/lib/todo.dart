import 'dart:async';
import 'package:baby_tracker/helper/helper_functions.dart';
import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:baby_tracker/widgets/todo_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ToDo extends StatefulWidget {
  const ToDo({Key? key}) : super(key: key);

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  String username = "";
  Map<String, String> eventidBabyid = {};
  List<DocumentSnapshot> events = [];

  final StreamController<List<DocumentSnapshot>> _controller =
      StreamController<List<DocumentSnapshot>>();
  Stream<List<DocumentSnapshot>> get _streamController => _controller.stream;

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  // Fills map event eventId keys and babyId values
  getEventIdandBabyIdMap() async {
    await HelperFunctions.getUserNameFromSF().then(
      (value) {
        setState(() {
          username = value!;
        });
      },
    );
    await DatabaseService()
        .getFutureEvent(FirebaseAuth.instance.currentUser!.uid, username)
        .then(
      (snapshot) {
        setState(() {
          eventidBabyid = snapshot;
        });
      },
    );
  }

  // populates list with event query snapshots
  getEventData() async {
    for (var eventBabyId in eventidBabyid.entries) {
      events.add(await DatabaseService()
          .getSpecificEventData(eventBabyId.key, eventBabyId.value));
    }
  }

  // sorts the events by time
  sortEvents() {
    events.sort((a, b) {
      return a["startTime"].compareTo(b["startTime"]);
    });
  }

  getEvents() async {
    // clears events for refreshing
    eventidBabyid = {};
    events = [];

    // gets data
    await getEventIdandBabyIdMap();
    await getEventData();
    sortEvents();
    _controller.sink.add(events);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        centerTitle: true,
      ),
      body: Scaffold(
        body: StreamBuilder<List<DocumentSnapshot>>(
            stream: _streamController,
            builder: (scontext, snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                  onRefresh: () async {
                    getEvents();
                  },
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return TodoCard(
                          babyId: snapshot.data![index]["babyId"],
                          eventId: snapshot.data![index].id,
                          taskName: snapshot.data![index]['task'],
                          taskType: snapshot.data![index]['type'],
                          taskDescription: snapshot.data![index]['description'],
                          taskStartTime:
                              snapshot.data![index]['startTime'].toDate(),
                          completed: snapshot.data![index]['completed'],
                          taskEndTime:
                              snapshot.data![index]['endTime'].toDate(),
                          duration: snapshot.data![index]['duration']);
                    },
                  ),
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
      ),
    );
  }
}
