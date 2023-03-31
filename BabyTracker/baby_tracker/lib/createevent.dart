import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/widgets/showsnackbar.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String babyExcreta = "";
  String calories = "";

  @override
  void initState() {
    super.initState();
    startDateTime = startDateTime.add(Duration(minutes: -30));
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
                            hint: Text(
                              'What kind of task are you adding?',
                              style: AppTextTheme.subtitle.copyWith(
                                color: AppColorScheme.white,
                              ),
                            ),
                            value: eventType,
                            items: [
                              DropdownMenuItem<String>(
                                value: "",
                                child: Text(
                                  'What kind of task are you adding?',
                                  style: AppTextTheme.h3.copyWith(
                                    color: AppColorScheme.white,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "Diaper Change",
                                child: Text(
                                  'Diaper Change',
                                  style: AppTextTheme.h3.copyWith(
                                    color: AppColorScheme.white,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "Meal Time",
                                child: Text(
                                  'Meal Time',
                                  style: AppTextTheme.h3.copyWith(
                                    color: AppColorScheme.white,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "Sleep Time",
                                child: Text(
                                  'Sleep Time',
                                  style: AppTextTheme.h3.copyWith(
                                    color: AppColorScheme.white,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "Incidents",
                                child: Text(
                                  'Incidents',
                                  style: AppTextTheme.h3.copyWith(
                                    color: AppColorScheme.white,
                                  ),
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "Appointments",
                                child: Text(
                                  'Appointments',
                                  style: AppTextTheme.h3.copyWith(
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
                          )),
                      SizedBox(height: 15),
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
                      SizedBox(height: 15),
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
                                color: AppColorScheme.white,
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
                                color: AppColorScheme.white,
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
                color: AppColorScheme.white,
              ),
            ),
            value: babyExcreta,
            items: [
              DropdownMenuItem<String>(
                  value: "",
                  child: Text('What kind of stool did the baby have?',
                      style: AppTextTheme.h3.copyWith(
                        color: AppColorScheme.white,
                      ))),
              DropdownMenuItem<String>(
                  value: "pee",
                  child: Text(
                    'pee',
                    style: AppTextTheme.h3.copyWith(
                      color: AppColorScheme.white,
                    ),
                  )),
              DropdownMenuItem<String>(
                  value: "poop",
                  child: Text(
                    'poop',
                    style: AppTextTheme.h3.copyWith(
                      color: AppColorScheme.white,
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
                color: AppColorScheme.lightGray,
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
          color: AppColorScheme.white,
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

  Future addEvent() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic> eventData = {
        "task": eventTask,
        "type": eventType,
        "description": eventDescription,
        "babyExcreta": babyExcreta,
        "calories": calories,
        "duration": endDateTime.difference(startDateTime).inMinutes,
        "startTime": startDateTime,
        "endTime": endDateTime,
        "completed": (eventType == 'Appointments') ? false : true,
      };
      DatabaseService().createEvent(widget.babyId, eventData).whenComplete(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
      showSnackBar(context, AppColorScheme.green, "Event Successfully Created");
    }
  }

  Future<TimeOfDay?> pickTime(hour, minute) => showTimePicker(
      context: context, initialTime: TimeOfDay(hour: hour, minute: minute));
}
