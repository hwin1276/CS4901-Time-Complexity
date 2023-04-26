import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:collection';
import 'package:baby_tracker/widgets/event_card.dart';
import '../service/database_service.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    Key? key,
    required this.babyName,
    required this.babyId,
    required this.userName,
  }) : super(key: key);
  final String babyName;
  final String babyId;
  final String userName;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<dynamic>> _events;
  Stream<QuerySnapshot>? events;
  List<DocumentSnapshot> documents = [];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    getEventData();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  List _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  getEventData() async {
    DatabaseService().getEventData(widget.babyId).then((val) {
      setState(() {
        events = val;
      });
    });
    final snap = await FirebaseFirestore.instance
        .collection("babies")
        .doc(widget.babyId)
        .collection("events")
        .orderBy("startTime", descending: true)
        .get();
    _events.clear();
    for (var doc in snap.docs) {
      final event = doc.data();
      event["id"] = doc.id;
      final day = DateTime.utc(event["startTime"].toDate().year,
          event["startTime"].toDate().month, event["startTime"].toDate().day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(event);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: calendar(),
    );
  }

  Widget calendar() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 25),
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                calendarStyle: CalendarStyle(
                    isTodayHighlighted: true,
                    selectedTextStyle: AppTextTheme.body.copyWith(
                      color: AppColorScheme.white,
                    ),
                    markersAlignment: Alignment.bottomRight),
                availableGestures: AvailableGestures.horizontalSwipe,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(
                    () {
                      getEventData();
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    },
                  );
                },
                onFormatChanged: (format) {
                  setState(
                    () {
                      getEventData();
                      _calendarFormat = format;
                    },
                  );
                },
                eventLoader: _getEventsForTheDay,
                // Custom marker to display number instead of dots
                calendarBuilders: calendarBase(),
              ),
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Text(
                "Events for: ${_focusedDay.toString().split(" ")[0]}",
                style: AppTextTheme.h3.copyWith(
                  color: AppColorScheme.white,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: events,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      documents = snapshot.data.docs;
                      documents = documents.where((element) {
                        final day = DateTime.utc(
                            element.get("startTime").toDate().year,
                            element.get("startTime").toDate().month,
                            element.get("startTime").toDate().day);
                        if (day == _selectedDay) {
                          return true;
                        } else {
                          return false;
                        }
                      }).toList();
                      return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          return EventCard(
                              taskName: documents[index]['task'],
                              taskType: documents[index]['type'],
                              taskDescription: documents[index]['description'],
                              taskStartTime:
                                  documents[index]['startTime'].toDate(),
                              taskEndTime: documents[index]['endTime'].toDate(),
                              calories: documents[index]['calories'],
                              babyExcreta: documents[index]['babyExcreta'],
                              completed: documents[index]['completed'],
                              duration: documents[index]['duration'],
                              babyId: widget.babyId,
                              eventId: documents[index].id);
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
            )
          ],
        ),
      ),
    );
  }

  CalendarBuilders<Object?> calendarBase() {
    return CalendarBuilders(
      markerBuilder: (context, day, events) => events.isNotEmpty
          ? Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Colors.lightBlue),
              child: Text('${events.length}',
                  style: const TextStyle(color: Colors.white)))
          : null,
    );
  }
}
