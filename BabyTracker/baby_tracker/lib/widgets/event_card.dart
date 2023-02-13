import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    Key? key,
    required this.taskName,
    required this.taskType,
    required this.taskDescription,
    required this.taskStartTime,
    required this.taskEndTime,
    required this.calories,
    required this.babyExcreta,
    required this.duration,
  }) : super(key: key);
  final String taskName;
  final String taskType;
  final String taskDescription;
  final DateTime taskStartTime;
  final DateTime taskEndTime;
  final String calories;
  final String babyExcreta;
  final int duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(taskType),
              content: (taskType == "Diaper Change")
                  ? Text(
                      "TITLE: $taskName\nDESCRIPTION: $taskDescription\nTYPE: $babyExcreta\nSTART TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskStartTime)}\nEND TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskEndTime)}")
                  : (taskType == "Meal Time")
                      ? Text(
                          "TITLE: $taskName\nDESCRIPTION: $taskDescription\nCALORIES: $calories\nSTART TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskStartTime)}\nEND TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskEndTime)}")
                      : (taskType == "Sleep Time")
                          ? Text(
                              "TITLE: $taskName\nDESCRIPTION: $taskDescription\nDURATION: $duration\nSTART TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskStartTime)}\nEND TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskEndTime)}")
                          : Text(
                              "TITLE: $taskName\nDESCRIPTION: $taskDescription\nSTART TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskStartTime)}\nEND TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskEndTime)}"),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text("Edit"),
                ),
              ],
            ),
          );
        },
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
