import 'package:flutter/material.dart';

class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Events'),
          centerTitle: true,
        ),
        body: Center(
            child: Text(
                'Event View to be Added'
            )
        )
    );
  }
}
