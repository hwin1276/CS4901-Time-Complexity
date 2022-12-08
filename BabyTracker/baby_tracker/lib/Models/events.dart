
import 'dart:html';

class Event {
  final String type;
  final String task;
  final String description;
  DateTime start;
  DateTime end;
  Event(this.type, this.task, this.description,this.start,this.end);

  Event.fromMap(Map<String, dynamic> map)
      : assert(map['type'] != null),
      assert(map['task'] != null),
      assert(map['description'] != null),
      assert(map['start'] != null),
      assert(map['end'] != null),
      type = map['type'],
      task = map['task'],
      description = map['description'],
      start = map['start'],
      end = map['end'];

}
// Event copy({
//     int? childId,
//     String? type,
//     DateTime? startTime,
//     DateTime? inputTime,
//     DateTime? endTime,
//     int? amountfood,
//     String? diaperChange,
//   }) =>
//       Event(
//         childId: childId ?? this.childId,
//         type: type ?? this.type,
//         startTime: startTime ?? this.startTime,
//         inputTime: inputTime ?? this.inputTime,
//         endTime: endTime ?? this.endTime,
//         amountFood: amountFood ?? this.amountFood,
//         diaperChange: diaperChange ?? this.diaperChange,
//       );

// static Event fromJson(Map<String, Object?> json) => Event(
//         childId: json[EventFields.childId] as int?,
//         type: json[EventFields.type] as String,
//         amountFood: json[EventFields.amountFood] as int,
//         startTime: DateTime.parse(json[EventFields.startTime] as String),
//         endTime: DateTime.parse(json[EventFields.endTime] as String),
//         inputTime: DateTime.parse(json[EventFields.inputTime] as String),
//         diaperChange: json[EventFields.diaperChange] as String,
//       );
