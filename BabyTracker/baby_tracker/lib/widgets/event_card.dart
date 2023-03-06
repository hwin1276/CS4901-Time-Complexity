import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: AppColorScheme.white,
        // leading: Icon(
        //     Icons.abc,
        //     color: Colors.blue),
        title: Text(
          taskName,
          style: AppTextTheme.body.copyWith(
            color: AppColorScheme.black,
          ),
        ),
        subtitle: Text(
          taskStartTime.toString(),
          style: AppTextTheme.subtitle.copyWith(
            color: AppColorScheme.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
