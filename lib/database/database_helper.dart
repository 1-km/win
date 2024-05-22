import 'package:diary/models/diary.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static Database? _database;

  Future<void> initDatabase() async {
    if (_database == null) {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'diary.db');

      _database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
            // When creating the db, create the table
            await db.execute('''
          CREATE TABLE diary(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            content TEXT,
            createdAt TEXT
          )
        ''');
          });
    }
  }

  Future<List<Diary>> getDiaries() async {
    await initDatabase();
    List<Map<String, dynamic>> maps = await _database!.rawQuery('select * from diary order by createdAt desc');

    return List.generate(maps.length, (index) {
      return Diary(
          id: maps[index]['id'],
          content: maps[index]['content'],
          createdAt: DateTime.parse(maps[index]['createdAt']));
    });
  }

  Future<int> insertDiary(Diary diary) async {
    await initDatabase();
    return await _database!.insert('diary', diary.toMap());
  }

  Future<void> deleteDiary(int id) async {
    await initDatabase();
    await _database!.delete(
      'diary',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateDiary(Diary diary) async {
    await initDatabase();
    await _database!.update(
      'diary',
      diary.toMap(),
      where: 'id = ?',
      whereArgs: [diary.id],
    );
  }
}