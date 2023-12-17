import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    //to store in an extension of our Db path
    final dbPath = await sql.getDatabasesPath();
    
    // FOR CLEARING THE DATABASE
    // sql.deleteDatabase(path.join(dbPath, 'places.db'));
    
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      //onCreate will run first time to create the table
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    
    return db.query(table);
  }
}
