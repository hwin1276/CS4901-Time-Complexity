import 'dart:async';
import 'package:baby_tracker/helper/helper_functions.dart';
import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
import 'package:baby_tracker/widgets/event_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/todolist.dart';
import '../objects/task.dart';

class ToDo extends StatefulWidget {
  const ToDo({Key? key}) : super(key: key);

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  /*
  final todoList = Task.todoList();
  final todoController = TextEditingController();
  */
  String username = "";
  Map<String, String>? eventidBabyid;
  List<DocumentSnapshot> events = [];

  final StreamController<List<DocumentSnapshot>> _controller =
      StreamController<List<DocumentSnapshot>>();
  Stream<List<DocumentSnapshot>> get _streamController => _controller.stream;

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  // Fills map event eventId keys and babyId values
  getEventIdandBabyIdMap() async {
    await HelperFunctions.getUserNameFromSF().then(
      (value) {
        setState(() {
          username = value!;
        });
      },
    );
    await DatabaseService()
        .getFutureEvent(FirebaseAuth.instance.currentUser!.uid, username)
        .then(
      (snapshot) {
        setState(() {
          eventidBabyid = snapshot;
        });
      },
    );
  }

  // populates list with event query snapshots
  getEventData() async {
    for (var eventBabyId in eventidBabyid!.entries) {
      events.add(await DatabaseService()
          .getSpecificEventData(eventBabyId.key, eventBabyId.value));
    }
  }

  getEvents() async {
    await getEventIdandBabyIdMap();
    await getEventData();
    _controller.sink.add(events);
  }

  @override
  Widget build(BuildContext context) {
    /*
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 50,
                          bottom: 20,
                        ),
                        child: Text(
                          'Tasks',
                          style: AppTextTheme.h1.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      for (Task tasktd in todoList)
                        ToDoList(
                          task: tasktd,
                          taskComplete: completeTask,
                          taskDelete: deleteTask,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                      left: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColorScheme.white,
                      boxShadow: const [
                        BoxShadow(
                          color: AppColorScheme.lightGray,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: todoController,
                      decoration: InputDecoration(
                        hintText: 'Add a new task to the list',
                        hintStyle: AppTextTheme.subtitle.copyWith(
                          color: AppColorScheme.darkGray,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorScheme.blue,
                      minimumSize: Size(60, 60),
                      elevation: 10,
                    ),
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    onPressed: () {
                      addTask(todoController.text);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    */
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        centerTitle: true,
      ),
      body: Scaffold(
        body: StreamBuilder<List<DocumentSnapshot>>(
            stream: _streamController,
            builder: (scontext, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return EventCard(
                        taskName: snapshot.data![index]['task'],
                        taskType: snapshot.data![index]['type'],
                        taskDescription: snapshot.data![index]['description'],
                        taskStartTime:
                            snapshot.data![index]['startTime'].toDate(),
                        taskEndTime: snapshot.data![index]['endTime'].toDate(),
                        calories: snapshot.data![index]['calories'],
                        babyExcreta: snapshot.data![index]['babyExcreta'],
                        duration: snapshot.data![index]['duration']);
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'No data available right now',
                    style: AppTextTheme.body.copyWith(
                      color: AppColorScheme.white,
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColorScheme.white,
                  ),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        //getEvents();
        //getEventIdandBabyIdMap();
        print(eventidBabyid);
        print(events[0]["task"]);
        print(events[1]["task"]);
        print(events[2]["task"]);
        //print(events[0]["task"]);
      }),
    );
  }

  /*
  void completeTask(Task task) {
    setState(() {
      task.isDone = !task.isDone;
    });
  }

  void addTask(String task) {
    setState(() {
      todoList
          .add(Task(id: DateTime.now().millisecondsSinceEpoch, taskText: task));
    });
    todoController.clear();
  }

  void deleteTask(int id) {
    setState(() {
      todoList.removeWhere((item) => item.id == id);
    });
  }
  */
}
