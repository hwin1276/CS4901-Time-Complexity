import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    Key? key,
    required this.taskName,
    required this.taskType,
    required this.taskDescription,
    required this.taskStartTime,
    required this.taskEndTime,
  }) : super(key: key);
  final String taskName;
  final String taskType;
  final String taskDescription;
  final DateTime taskStartTime;
  final DateTime taskEndTime;

  // Display appropriate icon for each task type
  eventIcon() {
    if (taskType == 'Sleep Time') {
      return Container(
          color: Colors.green,
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.crib, size: 30));
    } else if (taskType == 'Meal Time') {
      return Container(
          color: Colors.blue,
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.dining, size: 30));
    } else if (taskType == 'Diaper Change') {
      return Container(
          color: Colors.brown,
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.baby_changing_station, size: 30));
    } else if (taskType == 'Incidents') {
      return Container(
          color: Colors.red,
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.medical_services, size: 30));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {},
        leading: eventIcon(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        // leading: Icon(
        //     Icons.abc,
        //     color: Colors.blue),
        title: Text(
          taskName,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          taskStartTime.toString(),
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
