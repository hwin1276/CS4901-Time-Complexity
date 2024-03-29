import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/widgets/showsnackbar.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditEvent extends StatefulWidget {
  final String babyId;
  final String taskName;
  final String taskType;
  final String taskDescription;
  final DateTime taskStartTime;
  final DateTime taskEndTime;
  final String calories;
  final String babyExcreta;
  final bool completed;
  final String eventId;
  const EditEvent(
      {Key? key,
      required this.babyId,
      required this.taskName,
      required this.taskType,
      required this.taskDescription,
      required this.taskStartTime,
      required this.taskEndTime,
      required this.calories,
      required this.babyExcreta,
      required this.completed,
      required this.eventId})
      : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  bool _isLoading = false;
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now();
  final formKey = GlobalKey<FormState>();
  String eventType = "";
  String eventTask = "";
  String eventDescription = "";
  String babyExcreta = "";
  String calories = "";

  @override
  void initState() {
    super.initState();
    startDateTime = widget.taskStartTime;
    endDateTime = widget.taskEndTime;
    eventType = widget.taskType;
    eventTask = widget.taskName;
    eventDescription = widget.taskDescription;
    babyExcreta = widget.babyExcreta;
    calories = widget.calories;
  }

  @override
  Widget build(BuildContext context) {
    final hours = startDateTime.hour.toString().padLeft(2, '0');
    final minutes = startDateTime.minute.toString().padLeft(2, '0');
    final endHours = endDateTime.hour.toString().padLeft(2, '0');
    final endMinutes = endDateTime.minute.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Form(
                  //autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButtonFormField(
                            icon: Icon(Icons.arrow_downward),
                            value: eventType,
                            items: [
                              DropdownMenuItem<String>(
                                value: "",
                                child: Text(
                                  'What kind of task?',
                                  style: AppTextTheme.h3.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.color,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "Diaper Change",
                                child: Text(
                                  'Diaper Change',
                                  style: AppTextTheme.h3.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.color,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "Meal Time",
                                child: Text(
                                  'Meal Time',
                                  style: AppTextTheme.h3.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.color,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "Sleep Time",
                                child: Text(
                                  'Sleep Time',
                                  style: AppTextTheme.h3.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.color,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "Incidents",
                                child: Text(
                                  'Incidents',
                                  style: AppTextTheme.h3.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.color,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "Appointments",
                                child: Text(
                                  'Appointments',
                                  style: AppTextTheme.h3.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.color,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(
                                () {
                                  eventType = value!;
                                },
                              );
                            },
                            validator: (value) {
                              if (eventType == '') {
                                return "Please select an event type";
                              } else {
                                return null;
                              }
                            },
                          )),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          initialValue: eventTask,
                          decoration: InputDecoration(
                            hintText: "What is your task?",
                            hintStyle: AppTextTheme.subtitle.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                          onChanged: (value) {
                            setState(
                              () {
                                eventTask = value;
                              },
                            );
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your task';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          initialValue: eventDescription,
                          decoration: InputDecoration(
                            hintText: "Describe your event",
                            hintStyle: AppTextTheme.subtitle.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                          onChanged: (value) {
                            setState(
                              () {
                                eventDescription = value;
                              },
                            );
                          },
                        ),
                      ),
                      if (eventType == "Diaper Change")
                        conditionalDiaperInput(),
                      if (eventType == "Meal Time") conditionalMealInput(),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Start Time:',
                              style: AppTextTheme.h3.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.color,
                              ),
                            ),
                            Row(
                              children: [
                                startDateButton(context),
                                SizedBox(width: 10),
                                startTimeButton(hours, minutes),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'End Time:',
                              style: AppTextTheme.h3.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.color,
                              ),
                            ),
                            Row(
                              children: [
                                endDateButton(context),
                                SizedBox(width: 10),
                                endTimeButton(endHours, endMinutes),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () {
                              updateEvent();
                            },
                            child: Text(
                              'Confirm',
                              style: AppTextTheme.body.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Column conditionalDiaperInput() {
    return Column(
      children: [
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: DropdownButtonFormField(
            icon: Icon(Icons.arrow_downward),
            decoration: InputDecoration(
              hintText: "What kind of stool did the baby have",
              hintStyle: AppTextTheme.subtitle.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            value: babyExcreta,
            items: [
              DropdownMenuItem<String>(
                  value: "",
                  child: Text('What kind of stool did the baby have?',
                      style: AppTextTheme.h3.copyWith(
                        color: Theme.of(context).textTheme.titleSmall?.color,
                      ))),
              DropdownMenuItem<String>(
                  value: "pee",
                  child: Text(
                    'pee',
                    style: AppTextTheme.h3.copyWith(
                      color: Theme.of(context).textTheme.titleSmall?.color,
                    ),
                  )),
              DropdownMenuItem<String>(
                  value: "poop",
                  child: Text(
                    'poop',
                    style: AppTextTheme.h3.copyWith(
                      color: Theme.of(context).textTheme.titleSmall?.color,
                    ),
                  )),
              DropdownMenuItem<String>(
                  value: "diarrhea",
                  child: Text(
                    'diarrhea',
                    style: AppTextTheme.h3.copyWith(
                      color: AppColorScheme.white,
                    ),
                  )),
            ],
            onChanged: (value) {
              setState(() {
                babyExcreta = value!;
              });
            },
            validator: (value) {
              if (babyExcreta == '') {
                return "Please select a diaper change type";
              } else {
                return null;
              }
            },
          ),
        ),
      ],
    );
  }

  Column conditionalMealInput() {
    return Column(
      children: [
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "How many calories did the baby eat?",
              hintStyle: AppTextTheme.subtitle.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              setState(() {
                calories = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty || value == "0") {
                return 'Please enter how many calories did your baby eat';
              } else {
                return null;
              }
            },
          ),
        ),
      ],
    );
  }

  ElevatedButton startTimeButton(String hours, String minutes) {
    return ElevatedButton(
      child: Text(
        '$hours:$minutes',
        style: AppTextTheme.h3.copyWith(
          color: Theme.of(context).textTheme.titleSmall?.color,
        ),
      ),
      onPressed: () async {
        final time = await pickTime(startDateTime.hour, startDateTime.minute);

        if (time == null) return;

        final newDateTime = DateTime(
          startDateTime.year,
          startDateTime.month,
          startDateTime.day,
          time.hour,
          time.minute,
        );

        setState(() => startDateTime = newDateTime);

        // if invalid times sets default duration to 30 min
        if (startDateTime.isAfter(endDateTime)) {
          setState(
              () => endDateTime = startDateTime.add(Duration(minutes: 30)));
        }
      },
    );
  }

  ElevatedButton startDateButton(BuildContext context) {
    return ElevatedButton(
      child: Text(
        '${startDateTime.year}/${startDateTime.month}/${startDateTime.day}',
        style: AppTextTheme.h3.copyWith(
          color: AppColorScheme.white,
        ),
      ),
      onPressed: () async {
        final date = await showDatePicker(
            context: context,
            initialDate: startDateTime,
            firstDate: DateTime(2000),
            lastDate: (eventType == 'Appointments')
                ? DateTime.now().add(Duration(days: 365))
                : DateTime.now());
        // conditonal for date validation

        if (date == null) return;

        final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          startDateTime.hour,
          startDateTime.minute,
        );

        setState(() => startDateTime = newDateTime);
      },
    );
  }

  ElevatedButton endTimeButton(String endHours, String endMinutes) {
    return ElevatedButton(
      child: Text(
        '$endHours:$endMinutes',
        style: AppTextTheme.h3.copyWith(
          color: AppColorScheme.white,
        ),
      ),
      onPressed: () async {
        final time = await pickTime(endDateTime.hour, endDateTime.minute);

        if (time == null) return;

        final newDateTime = DateTime(
          endDateTime.year,
          endDateTime.month,
          endDateTime.day,
          time.hour,
          time.minute,
        );

        setState(() => endDateTime = newDateTime);

        // if time is invalid sets default time to 30 min
        if (endDateTime.isBefore(startDateTime)) {
          setState(
              () => startDateTime = endDateTime.add(Duration(minutes: -30)));
        }
      },
    );
  }

  ElevatedButton endDateButton(BuildContext context) {
    return ElevatedButton(
      child: Text(
        '${endDateTime.year}/${endDateTime.month}/${endDateTime.day}',
        style: AppTextTheme.h3.copyWith(
          color: AppColorScheme.white,
        ),
      ),
      onPressed: () async {
        final date = await showDatePicker(
            context: context,
            initialDate: startDateTime,
            firstDate: startDateTime,
            lastDate: (eventType == 'Appointments')
                ? DateTime.now().add(Duration(days: 365))
                : DateTime.now());
        // conditional for date validation

        if (date == null) return;

        final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          endDateTime.hour,
          endDateTime.minute,
        );

        setState(() => endDateTime = newDateTime);
      },
    );
  }

  Future updateEvent() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic> eventData = {
        "babyId": widget.babyId,
        "task": eventTask,
        "type": eventType,
        "description": eventDescription,
        "babyExcreta": babyExcreta,
        "calories": calories,
        "duration": endDateTime.difference(startDateTime).inMinutes,
        "startTime": startDateTime,
        "endTime": endDateTime,
        "completed": widget.completed,
      };
      DatabaseService()
          .editEvent(widget.babyId, widget.eventId, eventData)
          .whenComplete(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
      showSnackBar(context, AppColorScheme.green, "Event Successfully Updated");
    }
  }

  Future<TimeOfDay?> pickTime(hour, minute) => showTimePicker(
      context: context, initialTime: TimeOfDay(hour: hour, minute: minute));
}
