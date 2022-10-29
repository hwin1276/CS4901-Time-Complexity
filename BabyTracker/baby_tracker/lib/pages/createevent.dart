import 'package:flutter/material.dart';

class CreateEventMenu extends StatefulWidget {
  const CreateEventMenu({Key? key}) : super(key: key);

  @override
  State<CreateEventMenu> createState() => _CreateEventMenuState();
}

class _CreateEventMenuState extends State<CreateEventMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add an Event'),
      ),
      body: Center(
          child: Text(
              'Calendar View to be Added'
          )
      ),
    );;
  }
}
