import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime today = DateTime.now();
  // Select date function
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: calendar(),
    );
  }

  Widget calendar() {
    return Padding(
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
          Text("Events for: " + today.toString().split(" ")[0]),
        ],
      ),
    );
  }
}
