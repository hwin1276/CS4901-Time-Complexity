final String eventTable = 'events';

class EventFields {
  static final List<String> values = [
    // all fields
    childId, type, startTime, inputTime, endTime, amountFood, diaperChange
  ];
  
    static final String childId = 'childId';
    static final String type = 'type';
    static final String startTime = 'startTime';
    static final String inputTime = 'inputTime';
    static final String endTime = 'endTime';
    static final String amountFood = 'foodCount';
    static final String diaperChange = 'diaperChange';
}

class Event {
    final int? childId;
    final String type;
    final DateTime startTime;
    final DateTime inputTime;
    final DateTime endTime;
    final int amountFood;
    final String diaperChange;
 
    const Event({
        required this.childId,
        required this.type,
        required this.inputTime,
        required this.startTime,
        required this.endTime,
        required this.amountFood,
        required this.diaperChange,
    });

Event copy({
    int? childId,
    String? type,
    DateTime? startTime,
    DateTime? inputTime,
    DateTime? endTime,
    int? amountfood,
    String? diaperChange,
  }) =>
      Event(
        childId: childId ?? this.childId,
        type: type ?? this.type,
        startTime: startTime ?? this.startTime,
        inputTime: inputTime ?? this.inputTime,
        endTime: endTime ?? this.endTime,
        amountFood: amountFood ?? this.amountFood,
        diaperChange: diaperChange ?? this.diaperChange,
      );

static Event fromJson(Map<String, Object?> json) => Event(
        childId: json[EventFields.childId] as int?,
        type: json[EventFields.type] as String,
        amountFood: json[EventFields.amountFood] as int,
        startTime: DateTime.parse(json[EventFields.startTime] as String),
        endTime: DateTime.parse(json[EventFields.endTime] as String),
        inputTime: DateTime.parse(json[EventFields.inputTime] as String),
        diaperChange: json[EventFields.diaperChange] as String,
      );

Map<String, Object?> toJson() => {
        EventFields.childId: childId,
        EventFields.type: type,
        EventFields.amountFood: amountFood,
        EventFields.startTime: startTime.toIso8601String(),
        EventFields.endTime: endTime.toIso8601String(),
        EventFields.inputTime: inputTime.toIso8601String(),
        EventFields.diaperChange: diaperChange,
      };
}
