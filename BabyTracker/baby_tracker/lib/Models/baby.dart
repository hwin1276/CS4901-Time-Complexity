final String babyTable = 'babies';

class BabyFields {
    static final String babyId = '_id';
    static final String name = 'name';
    static final String eventsId = 'events';
}

class Baby {
    final int? babyId;
    final String name;
    final int? eventsId; // foreign key to where all events are tracked 
 
    const Baby({
        this.babyId,
        required this.name,
        required this.eventsId,
    });
}
