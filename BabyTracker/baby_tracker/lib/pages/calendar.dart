import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_tracker/widgets/event_card.dart';
import 'package:intl/intl.dart';

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
  DateTime today = DateTime.now();
  Stream<QuerySnapshot>? events;
  // Select date function
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

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
      body: calendar(),
    );
  }

  Widget calendar() {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TableCalendar(
            focusedDay: today,
            headerStyle:
                HeaderStyle(formatButtonVisible: false, titleCentered: true),
            selectedDayPredicate: ((day) => isSameDay(day, today)),
            // Date range of calendar
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 25),
            onDaySelected: _onDaySelected,
            daysOfWeekVisible: true,
            // Style the calendar
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedTextStyle: TextStyle(color: Colors.white),
            ),
          ),
          Divider(
            height: 20,
            thickness: 1,
          ),
          SizedBox(height: 10),
          Text("Events for: ${today.toString().split(" ")[0]}"),
          StreamBuilder(
              stream: events,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  for (var index = 0;
                      index < snapshot.data.docs.length;
                      index++) {
                    if (DateFormat('EEEE').format(
                            snapshot.data.docs[index]['startTime'].toDate()) ==
                        DateFormat('EEEE').format(today)) {
                      return Text(
                          "${index + 1}. ${snapshot.data.docs[index]['task']}");
                    } else {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                  }
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    'No data available right now',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ));
                }
                return Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              })
        ],
      ),
    ));
  }
}
