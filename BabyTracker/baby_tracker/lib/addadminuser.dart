import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*
class Event {
  late int type;
  late String task;
  late String description;
  late DateTime startTime;
  late DateTime endTime;

  Event({required this.type, required this.task, required this.description, required this.startTime, required this.endTime});
}

class Baby {
  late int babyid;
  late int parentid;
  late String name;
  List<Event>? events;

  Baby({required this.name, this.events});
}
*/

class AddAdminUser extends StatefulWidget {
  const AddAdminUser({Key? key}) : super(key: key);

  @override
  State<AddAdminUser> createState() => _AddAdminUserState();
}

class _AddAdminUserState extends State<AddAdminUser> {
  final String email = 'admin@gmail.com';
  final String password = 'admin';
  final String username = 'admin';

  //List<Baby>? babies;
  List<int> dependencies = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: () {
          createAdminUser(email:email, password:password, username:username, dependencies:dependencies);
        },
        child: const Text(
            'Create Admin',
            style: TextStyle(
              color: Colors.white,
            )
        ),
      ));
  }

  Future createAdminUser({required String email, required String password, required String username, required List dependencies}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();

    final json = {
      'email': email,
      'password': password,
      'username': username,
      'dependencies': ['123ABC', '564FDS', '765IRN'],
      'babies': [{
        'name': 'babyone',
        'events': [{
          'description': 'blankone',
          'task': 'taskone',
          'type': 1,
          'starttime': DateTime.now(),
          'endtime': DateTime.now(),
        }, {
          'description': 'blanktwo',
          'task': 'tasktwo',
          'type': 2,
          'starttime': DateTime.now(),
          'endtime': DateTime.now(),
        }
        ]
      }, {
        'name': 'babytwo',
        'events': [{
          'description': 'blankthree',
          'task': 'taskthree',
          'type': 3,
          'starttime': DateTime.now(),
          'endtime': DateTime.now(),
        }, {
          'description': 'blankfour',
          'task': 'taskfour',
          'type': 4,
          'starttime': DateTime.now(),
          'endtime': DateTime.now(),
        }
        ]
      }
      ]
    };

    await docUser.set(json);
  }
}
