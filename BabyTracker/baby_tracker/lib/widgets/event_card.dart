import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    // display how long ago the event was created
    DateTime timeAgoDay = DateTime.now()
        .subtract(Duration(days: (DateTime.now().day - taskStartTime.day)));

    DateTime timeAgoHr = DateTime.now()
        .subtract(Duration(hours: (DateTime.now().hour - taskStartTime.hour)));

    Duration duration = Duration(
        hours: taskEndTime.hour - taskStartTime.hour,
        minutes: taskEndTime.minute - taskStartTime.minute);

    // method to display how long ago event was created in hours/days
    timeAgo() {
      if (DateTime.now().day - taskStartTime.day == 0) {
        return timeago.format(timeAgoHr);
      } else {
        return timeago.format(timeAgoDay);
      }
    }

    // method to display duration depending on how many hours/minutes
    showTime() {
      if (duration.inHours == 0) {
        return Text(
          "${duration.inMinutes}min • ${timeAgo()}",
          style: TextStyle(
              fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
        );
      } else {
        return Text(
          "${duration.inHours}hr ${duration.inMinutes}min • ${timeAgo()}}",
          style: TextStyle(
              fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
        );
      }
    }

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
                              "TITLE: $taskName\nDESCRIPTION: $taskDescription\nDURATION: ${duration.inMinutes} Minutes\nSTART TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskStartTime)}\nEND TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskEndTime)}")
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
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: showTime(),
        trailing: Text(">", style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
