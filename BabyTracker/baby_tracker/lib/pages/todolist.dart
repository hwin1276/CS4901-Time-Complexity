import 'package:baby_tracker/objects/task.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:flutter/material.dart';

class ToDoList extends StatelessWidget {
  final Task task;
  final taskComplete;
  final taskDelete;

  const ToDoList(
      {Key? key,
      required this.task,
      required this.taskComplete,
      required this.taskDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          // When the user clicks on the task
          taskComplete(task);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: AppColorScheme.white,
        leading: Icon(
            task.isDone ? Icons.check_box : Icons.check_box_outline_blank,
            color: AppColorScheme.blue),
        title: Text(
          task.taskText!,
          style: AppTextTheme.h1.copyWith(
            color: AppColorScheme.black,
            fontSize: 20,
          ),
        ),
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
              taskDelete(task.id);
            },
          ),
        ),
      ),
    );
  }
}
