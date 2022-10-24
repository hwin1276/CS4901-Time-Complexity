import 'package:baby_tracker/objects/event.dart';

class Baby {
  late int babyid;
  late int parentid;
  late String name;
  List<Event>? events;

  Baby({required this.babyid, required this.parentid, required this.name, this.events});

}