import 'package:flutter/material.dart';
import '/Models/events.dart';
import '/db/sqlite.dart';

class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  late List<Event> events;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshEvents();
  }

  @override
  void dispose() {
    SqliteDB.instance.close();
    super.dispose();
  }

  Future refreshEvents() async {
    setState(() => isLoading = true);
    this.events = await SqliteDB.instance.readAllEvents();
    setState(() => isLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: ListView.builder(
            itemCount: events.length,
            prototypeItem: ListTile(
              title: Text('events'),
            ),
            itemBuilder: (context, index){
              refreshEvents();
            return Container(
                    height: 40,
                    child: Center(
                      child: Text(
                        '[${events[index].childId}] ${events[index].type} - ${events[index].diaperChange}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
            },
        ), 
    ),
    );
  }

}
