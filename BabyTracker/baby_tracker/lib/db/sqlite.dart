import "dart:io" as io;
import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// this is the general database for the project 

class SqliteDB {
    static final SqliteDB _instance = new SqliteDB.internal();

    factory SqliteDb() => _instance;
    static Database _db;

    Future<Database> get db async {
        if (db != null){
            return _db;
        }
        _db = await initDb();
        return _db;
    }

    SqliteDB.internal();

    /// initialize DB

    initDb() async {
        io.Directory documentDirectory = await getApplicationDocumentsDirectory();
        String path = join(documentDirectory.path, "babyTracker.db");

        var taskDb = 
            await openDatabase(path, version: 1);
        return taskDb;
    }

    // Count number of tables in DB

    Future countTable() async {
        var dbClient = await db;
        var res = 
            await dbClient.rawQuery("""SELECT count(*) as count FROM sqlite_master
            WHERE type = 'table'
            AND name != 'android_metadata'
            AND name != 'sqlite_seqence';""");
        return res[0]['count'];
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
            ${BabyFields.name} $name,
        )

        Create Table $eventTable (
            ${EventFields.childId} $idChild,
            ${EventFields.type} $textType,
            ${EventFields.startTime} $textType,
            ${EventFields.inputTime} $textType,
            ${EventFields.endTime} $textType,
            ${EventFields.amount_food} $textType,
            ${EventFields.diaperChange} $textType,
        )

        Create Table $statTable (
            ${StatFields.avgWeekSleep} $textType,
            ${StatFields.childId} $idChild,
            ${StatFields.avgSleepStart} $textType,
            ${StatFields.avgAmountSleep} $textType,
            ${StatFields.avgAmountEaten} $textType,
            ${StatFields.poopCount} $textType,
            ${StatFields.peeCount} $textType,
            ${StatFields.totDiaperChange} $textType,
            ${StatFields.calculatedDate} $textType,
        )
        ''');
    }

    // a function for closing the database 
    Future close() async {
        final db = await instance.db;

        db.close();
    }
}