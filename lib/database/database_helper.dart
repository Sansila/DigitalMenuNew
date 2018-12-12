// import 'dart:async';
// import 'dart:io' as io;

// import 'package:appdigitalmenu/database/model/user.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';

// class DatabaseHelper {
//   static final DatabaseHelper _instance = new DatabaseHelper.internal();
//   factory DatabaseHelper() => _instance;
//   static Database _db;

//   Future<Database> get db async {
//     if (_db != null) return _db;
//     _db = await initDb();
//     return _db;
//   }
//   DatabaseHelper.internal();

//   final String tableNote = 'tblconfiger';
//   final String columnId = 'id';
//   final String columnAppname = 'appname';
//   final String columnServer = 'server';
//   final String columnDatabase = 'database';
//   final String columnUsername = 'username';
//   final String columnPassword = 'password';

//   initDb() async {
//     io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, "configer.db"); // just for testing
//     //await deleteDatabase(path);
//     var db = await openDatabase(path, version: 1, onCreate: _onCreate);
//     return db;
//   }

//   void _onCreate(Database db, int version) async {
//     // When creating the db, create the table
//     await db.execute(
//         "CREATE TABLE $tableNote($columnId INTEGER PRIMARY KEY, $columnAppname TEXT, $columnServer TEXT, $columnDatabase TEXT, $columnUsername TEXT, $columnPassword TEXT)");
//   }

//   Future<int> saveUser(User user) async {
//     var dbClient = await db;
//     int res = await dbClient.insert(tableNote, user.toMap());
//     return res > 0 ? 1 : 0;
//   }

//   Future<List> getUser() async {
//     var dbClient = await db;
//     var result = await dbClient.query(tableNote, columns: [columnId,columnAppname,columnServer,columnDatabase,columnUsername,columnPassword]);
//     return result.toList();
//   }

//   Future<int> deleteUsers(User user) async {
//     var dbClient = await db;

//     int res =
//         await dbClient.rawDelete('DELETE FROM $tableNote WHERE $columnId = ?', [user.id]);
//     return res;
//   }

//   Future<bool> update(User user) async {
//     var dbClient = await db;
//     int res =   await dbClient.update(tableNote, user.toMap(),
//         where: "$columnId = ?", whereArgs: <int>[user.id]);
//     return res > 0 ? true : false;
//   }

//   Future<int> updateNote(User note) async {
//     var dbClient = await db;
//     int res = await dbClient.update(tableNote, note.toMap(), where: "$columnId = ?", whereArgs: [note.id]);
//     return res > 0 ? 1 : 0;
//   }

//   Future close() async {
//     var dbClient = await db;
//     return dbClient.close();
//   }
// }

import 'dart:async';
import 'dart:io' as io;

import 'package:appdigitalmenu/database/model/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    //await deleteDatabase(path);
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, appname TEXT, server TEXT, database TEXT, username TEXT, password TEXT)");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res > 0 ? 1 : 0;
  }

  Future<List> getUser() async {
    var dbClient = await db;
    var list = await dbClient.rawQuery('SELECT * FROM User');
    return list.toList();
  }

  Future<int> updateNote(User note) async {
    var dbClient = await db;
    int res = await dbClient.update("User", note.toMap(), where: "id = ?", whereArgs: [note.id]);
    return res > 0 ? 1 : 0;
  }

}