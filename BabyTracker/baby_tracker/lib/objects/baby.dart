import 'package:baby_tracker/objects/event.dart';

class Baby {
  late int babyid;
  late int parentid;
  late String name;
  late String gender;
  late String theme;
  List<Event>? events;

  Baby(
      {required this.babyid,
      required this.parentid,
      required this.name,
      required this.gender,
      this.theme = 'default',
      this.events});

  /*static List<Baby> babyList() {
    return [
      // Sample data for baby list
      Baby(
          babyid: 0, parentid: 0, name: 'Frank', gender: 'male', theme: 'blue'),
      Baby(
          babyid: 1, parentid: 0, name: 'John', gender: 'male', theme: 'green'),
      Baby(
          babyid: 2,
          parentid: 1,
          name: 'Maria',
          gender: 'female',
          theme: 'yellow'),
      Baby(babyid: 3, parentid: 2, name: 'Dustin', gender: 'male'),
    ];
  }*/
}
