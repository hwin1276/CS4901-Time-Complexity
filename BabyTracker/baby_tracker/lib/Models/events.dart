final String eventTable = 'events';

class eventFields {
    static final String eventId = '_id';
    static final String type = 'type';
    static final String startTime = 'startTime';
    static final String inputTime = 'inputTime';
    static final String endTime = 'endTime';
    static final String amount_Food = 'foodCount';
    static final String diaperChange = 'diaperChange';
}

class Event {
    final int? eventId;
    final int type;
    final DateTime startTime;
    final DateTime inputTime;
    final DateTime endTime;
    final Double amount_Food;
    final String diaperChange;
 
    const Event({
        this.eventId,
        required this.type,
        required this.inputTime,
        this.startTime,
        this.endTime,
        this.amount_Food,
        this.diaperChange,
    });
}
