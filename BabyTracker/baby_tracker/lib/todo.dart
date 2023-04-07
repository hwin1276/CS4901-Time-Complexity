import 'package:baby_tracker/helper/helper_functions.dart';
import 'package:baby_tracker/service/database_service.dart';
import 'package:baby_tracker/themes/colors.dart';
import 'package:baby_tracker/themes/text.dart';
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
      body: Center(child: Text('Todo View being worked on')),
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
