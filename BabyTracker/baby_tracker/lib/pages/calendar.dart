import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:collection';
import 'package:baby_tracker/widgets/event_card.dart';

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
  DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<dynamic>> _events;
  Stream<QuerySnapshot>? eventData;

  @override
  void initState() {
    super.initState();
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
    /*
    DatabaseService().getEventData(widget.babyId).then((val) {
      setState(() {
        eventData = val;
      });
    });
    */

    final snap = await FirebaseFirestore.instance
        .collection("babies")
        .doc(widget.babyId)
        .collection("events")
        .orderBy("startTime", descending: true)
        .get();
    for (var doc in snap.docs) {
      final event = doc.data();
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
      child: ListView(
        children: [
          TableCalendar(
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
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: _getEventsForTheDay,
            // Custom marker to display number instead of dots
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) => events.isNotEmpty
                  ? Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: Colors.lightBlue),
                      child: Text('${events.length}',
                          style: const TextStyle(color: Colors.white)))
                  : null,
            ),
          ),
          Text("Events for: ${_focusedDay.toString().split(" ")[0]}",
              style: AppTextTheme.h3.copyWith(
                color: AppColorScheme.white,
              )),
          // Event List
          for (var event in _getEventsForTheDay(_selectedDay))
            EventCard(
                taskName: event["task"],
                taskType: event["type"],
                taskDescription: event["description"],
                taskStartTime: event["startTime"].toDate(),
                taskEndTime: event["endTime"].toDate(),
                calories: event["calories"],
                babyExcreta: event["babyExcreta"],
                duration: event["duration"])
        ],
      ),
    ));
  }
}
