import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/favorites.dart';

class DbHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    var dbFolder = await getDatabasesPath();
    String path = join(dbFolder, "Favorite.db");
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    return await db.execute(
      "CREATE TABLE Favorite (id INTEGER PRIMARY KEY, title TEXT, year TEXT, imdbID TEXT, type TEXT, poster TEXT )",
    );
  }

  Future<List<Favorite>> getFavorite() async {
    var dbClient = await db;
    var result = await dbClient.query("Favorite", orderBy: "imdbID");
    return result.map((data) => Favorite.fromMap(data)).toList();
  }

  //GET IF DATA MATCH
  Future<bool> getFavoriteMatch(String imdbID) async {
    var dbClient = await db;
    try {
      var result = await dbClient
          .query("Favorite", where: "imdbID=?", whereArgs: [imdbID]);

      if (result.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<int> insertFavorite(Favorite favorite) async {
    var dbClient = await db;
    try {
      return await dbClient.insert("Favorite", favorite.toMap(),
          conflictAlgorithm: ConflictAlgorithm.fail);
    } catch (e) {
      return 0;
    }
  }

  Future<int> removeFavorite(String imdbID) async {
    var dbClient = await db;
    try {
      return await dbClient
          .delete("Favorite", where: "imdbID=?", whereArgs: [imdbID]);
    } catch (e) {
      return 0;
    }
  }
}
