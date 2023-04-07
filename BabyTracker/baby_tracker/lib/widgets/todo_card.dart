import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:baby_tracker/widgets/showsnackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class TodoCard extends StatefulWidget {
  TodoCard({
    Key? key,
    required this.babyId,
    required this.eventId,
    required this.taskName,
    required this.taskType,
    required this.taskDescription,
    required this.completed,
    required this.taskStartTime,
    required this.taskEndTime,
    required this.duration,
  }) : super(key: key);
  final String babyId;
  final String eventId;
  final String taskName;
  final String taskType;
  final String taskDescription;
  bool completed;
  final DateTime taskStartTime;
  final DateTime taskEndTime;
  final int duration;

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    // display how long ago the event was created
    DateTime timeAgoDay = DateTime.now().subtract(
        Duration(days: (DateTime.now().day - widget.taskStartTime.day)));

    DateTime timeAgoHr = DateTime.now().subtract(
        Duration(hours: (DateTime.now().hour - widget.taskStartTime.hour)));

    Duration duration = Duration(
        hours: widget.taskEndTime.hour - widget.taskStartTime.hour,
        minutes: widget.taskEndTime.minute - widget.taskStartTime.minute);

    // method to display how long ago event was created in hours/days
    timeAgo() {
      return timeago.format(widget.taskStartTime, allowFromNow: true);
    }

    // method to display duration depending on how many hours/minutes
    showTime() {
      if (duration.inHours == 0) {
        return Text(
          "${duration.inMinutes}min • ${timeAgo()}",
          style: AppTextTheme.subtitle.copyWith(
            color: AppColorScheme.black,
          ),
        );
      } else {
        return Text(
          "${duration.inHours}hr ${duration.inMinutes}min • ${timeAgo()}}",
          style: AppTextTheme.subtitle.copyWith(
            color: AppColorScheme.black,
          ),
        );
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          // checkbox
          setState(() {
            widget.completed = !widget.completed;
          });
          // change database
          DatabaseService()
              .setTaskStatus(widget.eventId, widget.babyId, widget.completed);
          showSnackBar(context, AppColorScheme.green, "Nice Job!");
        },
        leading: SizedBox(
            height: double.infinity,
            child: Icon(
                widget.completed
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: AppColorScheme.blue)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: AppColorScheme.white,
        title: Text(
          widget.taskName,
          style: AppTextTheme.body.copyWith(
            color: AppColorScheme.black,
          ),
        ),
        subtitle: showTime(),
        trailing: Container(
          padding: EdgeInsets.all(0),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: AppColorScheme.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: AppColorScheme.white,
            iconSize: 18,
            icon: Icon(Icons.delete),
            onPressed: () {
              // Delete task from the list
              DatabaseService().finishTask(widget.eventId, widget.babyId);
              showSnackBar(
                  context, AppColorScheme.green, "Removed from Todo List");
            },
          ),
        ),
      ),
    );
  }

  Text futureEventDetails() {
    return Text(
        "TITLE: ${widget.taskName}\nDESCRIPTION: ${widget.taskDescription}\nSTART TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(widget.taskStartTime)}\nEND TIME: ${DateFormat('yyyy-MM-dd - kk:mm').format(widget.taskEndTime)}");
  }
}
