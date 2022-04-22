import 'package:finnapp/models/breakdown.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  String path;

  DBHelper._();

  static final DBHelper db = DBHelper._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await init();
    return _database;
  }

  init() async {
    String path = await getDatabasesPath();
    path = join(path, 'breakdowns.db');
    print("Enterd path $path");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Breakdowns (_id TEXT PRIMARY KEY, type TEXT, cost INTEGER, category TEXT, year INTEGER, month INTEGER, day INTEGER, hour INTEGER, minute INTEGER);');
      print('New table created at $path');
    });
  }

  Future<List<Breakdown>> getBreakdownsFromDB() async {
    final db = await database;
    List<Breakdown> breakdowns = [];
    List<Map> maps = await db.query('Breakdowns', columns: [
      '_id',
      'cost',
      'category',
      'type',
      'year',
      'month',
      'day',
      'hour',
      'minute'
    ]);
    if (maps.length > 0) {
      maps.forEach((map) {
        breakdowns.add(Breakdown.fromMap(map));
      });
    }
    return breakdowns;
  }

  printAll() async {
    final db = await database;
    List<Breakdown> breakdowns = [];
    List<Map> maps = await db.query('Breakdowns', columns: [
      '_id',
      'cost',
      'category',
      'type',
      'year',
      'month',
      'day',
      'hour',
      'minute'
    ]);
    print(maps.toString());
  }

  updateBreakdownInDB(Breakdown breakdown) async {
    final db = await database;
    await db.update('Breakdowns', breakdown.toMap(),
        where: '_id = ?', whereArgs: [breakdown.id]);
    print("Breakdown updated: ${breakdown.category} ${breakdown.cost}");
  }

  deleteBreakdownInDB(Breakdown breakdown) async {
    final db = await database;
    await db.delete("Breakdowns", where: '_id = ?', whereArgs: [breakdown.id]);
    print('Breakdown deleted');
  }

  insertBreakdownInDB(Breakdown breakdown) async {
    final db = await database;
    await db.insert('Breakdowns', breakdown.toMap());
    print("Breakdown inserted: ${breakdown.category} ${breakdown.cost}");
  }
}
