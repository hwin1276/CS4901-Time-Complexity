import 'package:baby_tracker/objects/event.dart';

class Baby {
  late int babyid;
  late int parentid;
  late String name;
  List<Event>? events;

  Baby(
      {required this.babyid,
      required this.parentid,
      required this.name,
      this.events});

  static List<Baby> babyList() {
    return [
      // Sample data for baby list
      Baby(babyid: 0, parentid: 0, name: 'Frank'),
      Baby(babyid: 1, parentid: 0, name: 'John'),
      Baby(babyid: 2, parentid: 1, name: 'Alex'),
      Baby(babyid: 3, parentid: 2, name: 'Dustin'),
    ];
  }
}
