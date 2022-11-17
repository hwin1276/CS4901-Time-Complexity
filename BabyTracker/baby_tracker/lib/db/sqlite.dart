import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';
import '/Models/events.dart';
import '/Models/user.dart';
import '/Models/statistics.dart';
import '/Models/baby.dart';

// this is the general database for the project 

class SqliteDB {
    static final SqliteDB instance = SqliteDB._init();

    static Database? _db;

    SqliteDB._init();

    Future<Database> get db async {
        if (_db != null){
            return _db!;
        }
        _db = await _initDB('babytracker.db');
        return _db!;
    }

    /// initialize DB

    Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }


    // when intitializing the database from other files, call the count table function 
    // which will call getdb and will init database if not already formed. This will init
    // babytracker.db

    Future _createDB(Database db, int version) async {
        // this is where the schema will be created and init 
        // i am researching how to make dependents a foreign key thing

        final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
        final textType = 'TEXT NOT NULL';
        final idChild = 'FOREIGN KEY(childId) REFERENCES babyTable(babyId)';
        
        await db.execute(''' 
        CREATE TABLE $userTable (
            ${UserFields.userId} $idType,
            ${UserFields.username} $textType,
            ${UserFields.password} $textType,
            ${UserFields.email} $textType,
            ${UserFields.dependents} $textType, 
        )

        Create Table $babyTable (
            ${BabyFields.babyId} $idType,
            ${BabyFields.name} $textType,
        )

        Create Table $eventTable (
            ${EventFields.childId} $idChild,
            ${EventFields.type} $textType,
            ${EventFields.startTime} $textType,
            ${EventFields.inputTime} $textType,
            ${EventFields.endTime} $textType,
            ${EventFields.amountFood} $textType,
            ${EventFields.diaperChange} $textType,
        )

        Create Table $statTable (
            ${StatFields.avgWeekSleep} $textType,
            ${StatFields.childId} $idChild,
            ${StatFields.avgSleepStart} $textType,
            ${StatFields.avgAmountSleep} $textType,
            ${StatFields.avgAmountEaten} $textType,
            ${StatFields.poopCountByWeek} $textType,
            ${StatFields.peeCountByWeek} $textType,
            ${StatFields.totDiaperChange} $textType,
            ${StatFields.calculatedDate} $textType,
        )
        ''');
    }

    Future<Event> create(Event event) async {
        final db = await instance.db;
        final id = await db.insert(eventTable, event.toJson());
        return event.copy(childId: id);
    }

    Future<Event> readEvent(int id) async {
      final db = await instance.db;

      final maps = await db.query(
        eventTable,
        columns: EventFields.values,
        where: '${EventFields.childId} = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Event.fromJson(maps.first);
      } else {
        throw Exception('ID $id not found');
      }
    }

    Future<List<Event>> readAllEvents() async {
      final db = await instance.db;
      final orderBy = '${EventFields.inputTime} ASC';
      final result = await db.query(eventTable, orderBy: orderBy);
      return result.map((json) => Event.fromJson(json)).toList();
    }

    Future<int> update(Event event) async {
      final db = await instance.db;

      return db.update(
        eventTable,
        event.toJson(),
        where: '${EventFields.childId} = ?',
        whereArgs: [event.childId],
      );
    }

    Future<int> delete(int id) async {
      final db = await instance.db;

      return await db.delete(
        eventTable,
        where: '${EventFields.childId} = ?',
        whereArgs: [id],
      );
    }

    // a function for closing the database 
    Future close() async {
        final dbc = await instance.db;

        dbc.close();
    }
}