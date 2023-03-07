import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:baby_tracker/widgets/showsnackbar.dart';
import 'package:flutter/material.dart';

class CreateEvent extends StatefulWidget {
  final String userName;
  final String babyName;
  final String babyId;
  const CreateEvent(
      {Key? key,
      required this.userName,
      required this.babyName,
      required this.babyId})
      : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  bool _isLoading = false;
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now();
  final formKey = GlobalKey<FormState>();
  String eventType = "";
  String eventTask = "";
  String eventDescription = "";

  @override
  void initState() {
    super.initState();
    endDateTime = endDateTime.add(Duration(minutes: 30));
  }

  @override
  Widget build(BuildContext context) {
    final hours = startDateTime.hour.toString().padLeft(2, '0');
    final minutes = startDateTime.minute.toString().padLeft(2, '0');
    final endHours = endDateTime.hour.toString().padLeft(2, '0');
    final endMinutes = endDateTime.minute.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an Event'),
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButtonFormField(
                            icon: Icon(Icons.arrow_downward),
                            hint: Text(
                              'What kind of task are you adding?',
                              style: AppTextTheme.h2.copyWith(
                                color: AppColorScheme.white,
                              ),
                            ),
                            value: eventType,
                            items: [
                              DropdownMenuItem<String>(
                                value: "",
                                child: Text(
                                  'What kind of task are you adding?',
                                  style: AppTextTheme.h2.copyWith(
                                    color: AppColorScheme.white,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "Diaper Change",
                                child: Text(
                                  'Diaper Change',
                                  style: AppTextTheme.h2.copyWith(
                                    color: AppColorScheme.white,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "Meal Time",
                                child: Text(
                                  'Meal Time',
                                  style: AppTextTheme.h2.copyWith(
                                    color: AppColorScheme.white,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "Sleep Time",
                                child: Text(
                                  'Sleep Time',
                                  style: AppTextTheme.h2.copyWith(
                                    color: AppColorScheme.white,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "Incidents",
                                child: Text(
                                  'Incidents',
                                  style: AppTextTheme.h2.copyWith(
                                    color: AppColorScheme.white,
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
                                return "Please select a event type";
                              } else {
                                return null;
                              }
                            },
                          )
                          // DropdownButtonFormField(
                          //   value: dropdownValue,
                          //   icon: Icon(Icons.arrow_downward),
                          //   hint: Text('What kind of task are you adding?'),
                          //   onChanged: (String? newValue) {
                          //     setState(() {
                          //       dropdownValue = newValue!;
                          //
                          //       switch(dropdownValue) {
                          //         case 'Diaper Change': {
                          //           eventtype = 1;
                          //         }
                          //         break;
                          //         case 'Meal Time': {
                          //           eventtype = 2;
                          //         }
                          //         break;
                          //         case 'Sleep Time': {
                          //           eventtype = 3;
                          //         }
                          //         break;
                          //         case 'Accidents': {
                          //           eventtype = 4;
                          //         }
                          //         break;
                          //       }
                          //     });
                          //   },
                          //   items: <String>[
                          //     'Diaper Change',
                          //     'Meal Time',
                          //     'Sleep Time',
                          //     'Accidents'
                          //   ].map<DropdownMenuItem<String>>((String value) {
                          //     return DropdownMenuItem<String>(
                          //       value: value,
                          //       child: Text(value),
                          //     );
                          //   }).toList(),
                          //   validator: (value) {
                          //     if (value == null) {
                          //       return 'Please enter what kind of task your adding';
                          //     }
                          //     else {
                          //       return null;
                          //     }
                          //   },
                          // ),
                          ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "What is your task?",
                            hintStyle: AppTextTheme.subtitle.copyWith(
                              color: AppColorScheme.lightGray,
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
                      Divider(
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Describe your event",
                            hintStyle: AppTextTheme.subtitle.copyWith(
                              color: AppColorScheme.lightGray,
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
                      Divider(
                        color: AppColorScheme.lightGray,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Start Time:',
                              style: AppTextTheme.h2.copyWith(
                                color: AppColorScheme.white,
                              ),
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  child: Text(
                                    '${startDateTime.year}/${startDateTime.month}/${startDateTime.day}',
                                    style: AppTextTheme.h2.copyWith(
                                      color: AppColorScheme.white,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final date = await pickDate(startDateTime);

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
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  child: Text(
                                    '$hours:$minutes',
                                    style: AppTextTheme.h2.copyWith(
                                      color: AppColorScheme.white,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final time = await pickTime(
                                        startDateTime.hour,
                                        startDateTime.minute);

                                    if (time == null) return;

                                    final newDateTime = DateTime(
                                      startDateTime.year,
                                      startDateTime.month,
                                      startDateTime.day,
                                      time.hour,
                                      time.minute,
                                    );

                                    setState(() => startDateTime = newDateTime);
                                  },
                                ),
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
                            Text('End Time:'),
                            Row(
                              children: [
                                ElevatedButton(
                                  child: Text(
                                    '${endDateTime.year}/${endDateTime.month}/${endDateTime.day}',
                                    style: AppTextTheme.h2.copyWith(
                                      color: AppColorScheme.white,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final date = await pickDate(endDateTime);

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
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  child: Text(
                                    '$endHours:$endMinutes',
                                    style: AppTextTheme.h2.copyWith(
                                      color: AppColorScheme.white,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final time = await pickTime(
                                        endDateTime.hour, endDateTime.minute);

                                    if (time == null) return;

                                    final newDateTime = DateTime(
                                      endDateTime.year,
                                      endDateTime.month,
                                      endDateTime.day,
                                      time.hour,
                                      time.minute,
                                    );

                                    setState(() => endDateTime = newDateTime);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: AppColorScheme.lightGray,
                      ),
                      SizedBox(height: 100),
                      Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                            color: AppColorScheme.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () {
                              addEvent();
                            },
                            child: Text(
                              'Confirm',
                              style: AppTextTheme.body.copyWith(
                                color: AppColorScheme.white,
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

  Future addEvent() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic> eventData = {
        "task": eventTask,
        "type": eventType,
        "description": eventDescription,
        "startTime": startDateTime,
        "endTime": endDateTime
      };
      DatabaseService().createEvent(widget.babyId, eventData).whenComplete(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
      showSnackBar(context, AppColorScheme.green, "Event Successfully Created");
    }
  }

  Future<DateTime?> pickDate(dateTime) => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> pickTime(hour, minute) => showTimePicker(
      context: context, initialTime: TimeOfDay(hour: hour, minute: minute));
}
