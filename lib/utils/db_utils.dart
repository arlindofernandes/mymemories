import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class DbUtils {
  Future<Database> open() async {
    String sqlitePath = await getDatabasesPath();
    String memoriePath = join(sqlitePath, 'memorie.db');

    return await openDatabase(memoriePath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE memorie (id INTEGER PRIMARY KEY, image TEXT, latitude REAL, longitude REAL, description TEXT, formatedAddress TEXT)');
    });
  }

  Future<void> save(String table, Map<String, dynamic> object) async {
    Database db = await open();

    await db.insert(table, object,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, Object?>>> get(String table) async {
    Database db = await open();

    return await db.query(table);
  }
}
