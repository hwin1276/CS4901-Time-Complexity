import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/widgets/showsnackbar.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../editevent.dart';

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
    required this.completed,
    required this.duration,
    required this.babyId,
    required this.eventId,
  }) : super(key: key);
  final String taskName;
  final String taskType;
  final String taskDescription;
  final DateTime taskStartTime;
  final DateTime taskEndTime;
  final String calories;
  final String babyExcreta;
  final bool completed;
  final int duration;
  final String babyId;
  final String eventId;

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
    } else if (taskType == 'Appointments') {
      return Container(
          color: AppColorScheme.yellow,
          padding: const EdgeInsets.all(10),
          child: const Icon(Icons.alarm, size: 30));
    }
  }

  @override
  Widget build(BuildContext context) {
    Duration duration = Duration(
        hours: taskEndTime.hour - taskStartTime.hour,
        minutes: taskEndTime.minute - taskStartTime.minute);

    // method to display how long ago event was created in hours/days
    timeAgo() {
      return timeago.format(taskStartTime, allowFromNow: true);
    }

    // method to display duration depending on how many hours/minutes
    showTime() {
      if (duration.inHours == 0) {
        return Text(
          "${duration.inMinutes}min • ${timeAgo()}",
          style: AppTextTheme.subtitle.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        );
      } else {
        return Text(
          "${duration.inHours}hr ${duration.inMinutes}min • ${timeAgo()}}",
          style: AppTextTheme.subtitle.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        );
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(taskType),
              content: (taskType == "Diaper Change")
                  ? diaperEventDetails()
                  : (taskType == "Meal Time")
                      ? mealEventDetails()
                      : (taskType == "Sleep Time")
                          ? sleepEventDetails(duration)
                          : futureEventDetails(),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditEvent(
                                  babyId: babyId,
                                  taskName: taskName,
                                  taskType: taskType,
                                  taskDescription: taskDescription,
                                  taskStartTime: taskStartTime,
                                  taskEndTime: taskEndTime,
                                  calories: calories,
                                  babyExcreta: babyExcreta,
                                  completed: completed,
                                  eventId: eventId,
                                )));
                  },
                  child: const Text("Edit"),
                ),
                TextButton(
                  onPressed: () {
                    DatabaseService().deleteEvent(babyId, eventId);
                    Navigator.pop(context);
                    showSnackBar(context, AppColorScheme.green,
                        "Event Successfully Deleted");
                  },
                  child: const Text("Delete"),
                ),
              ],
            ),
          );
        },
        leading: eventIcon(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: AppColorScheme.white,
        // leading: Icon(
        //     Icons.abc,
        //     color: Colors.blue),
        title: Text(
          taskName,
          style: AppTextTheme.body.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        subtitle: showTime(),
        trailing: Text(">", style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Text futureEventDetails() {
    return Text(
        "TITLE: $taskName\nDESCRIPTION: $taskDescription\nSTART TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskStartTime)}\nEND TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskEndTime)}");
  }

  Text sleepEventDetails(Duration duration) {
    return Text(
        "TITLE: $taskName\nDESCRIPTION: $taskDescription\nDURATION: ${duration.inMinutes} Minutes\nSTART TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskStartTime)}\nEND TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskEndTime)}");
  }

  Text mealEventDetails() {
    return Text(
        "TITLE: $taskName\nDESCRIPTION: $taskDescription\nCALORIES: $calories\nSTART TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskStartTime)}\nEND TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskEndTime)}");
  }

  Text diaperEventDetails() {
    return Text(
        "TITLE: $taskName\nDESCRIPTION: $taskDescription\nTYPE: $babyExcreta\nSTART TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskStartTime)}\nEND TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(taskEndTime)}");
  }
}
