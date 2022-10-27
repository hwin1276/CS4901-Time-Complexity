final String babyTable = 'babies';

class BabyFields {
    static final String babyId = '_id';
    static final String name = 'name';
}

class Baby {
    final int? babyId;
    final String name;
 
    const Baby({
        this.babyId,
        required this.name,
    });
}
