import 'package:flutter/material.dart';


class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? dropdownValue;
  int? eventtype;


  @override
  Widget build(BuildContext context) {
    endDateTime = endDateTime.add(Duration(minutes:30));

    final hours = startDateTime.hour.toString().padLeft(2,'0');
    final minutes = startDateTime.minute.toString().padLeft(2,'0');
    final endHours = endDateTime.hour.toString().padLeft(2,'0');
    final endMinutes = endDateTime.minute.toString().padLeft(2,'0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an Event'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:10, vertical: 15),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:15),
                  child: DropdownButtonFormField(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    hint: Text('What kind of task are you adding?'),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;

                        switch(dropdownValue) {
                          case 'Diaper Change': {
                            eventtype = 1;
                          }
                          break;
                          case 'Meal Time': {
                            eventtype = 2;
                          }
                          break;
                          case 'Sleep Time': {
                            eventtype = 3;
                          }
                          break;
                          case 'Accidents': {
                            eventtype = 4;
                          }
                          break;
                        }
                      });
                    },
                    items: <String>[
                      'Diaper Change',
                      'Meal Time',
                      'Sleep Time',
                      'Accidents'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter what kind of task your adding';
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:15),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "What is your task?",
                    ),
                    controller: titleController,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
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
                  padding: EdgeInsets.symmetric(horizontal:15),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Description"
                    ),
                    maxLines: 5,
                    controller: descriptionController,
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Start Time:'),
                      Row(
                        children: [
                          ElevatedButton(
                            child: Text(
                              '${startDateTime.year}/${startDateTime.month}/${startDateTime.day}',
                              style: TextStyle(fontSize: 24),
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
                              style: TextStyle(fontSize: 24),
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('End Time:'),
                      Row(
                        children: [
                          ElevatedButton(
                            child: Text(
                              '${endDateTime.year}/${endDateTime.month}/${endDateTime.day}',
                              style: TextStyle(fontSize: 24),
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
                              style: TextStyle(fontSize: 24),
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(height: 100),
                Container(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: () {
                        final isValidForm = formKey.currentState!.validate();
                        if (isValidForm) {
                          final task = titleController.text;
                          final description = descriptionController.text;
                          //add event to database
                        }
                      },
                      child: const Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.white,
                          )
                      ),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> pickDate(dateTime) => showDatePicker (
    context: context,
    initialDate:dateTime,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );

  Future<TimeOfDay?> pickTime(hour, minute) => showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: hour, minute: minute)
  );
}
