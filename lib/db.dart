import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Favorite{
  final int regist_no;

  Favorite({this.regist_no});

}

final String tableName = 'Favorite';

class DBHelper {

  DBHelper._();

  static final DBHelper _db = DBHelper._();

  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'MyDogsDB.db');

    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE $tableName(
            regist_no INTEGER)
        ''');
        },
        onUpgrade: (db, oldVersion, newVersion) {}
    );
  }

  insert(int regst_no) async {
    final db = await database;
    var res = await db.rawInsert(
        'INSERT INTO $tableName VALUES(?) ', [regst_no]);
    return res;
  }

  Future<List<Favorite>> getAllDogs() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $tableName');
    List<Favorite> list = res.isNotEmpty ? res.map((c) =>
        Favorite(regist_no: c['regist_no'])).toList() : [];

    return list;
  }

  delete(int regist_no) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $tableName WHERE regist_no = ?', [regist_no]);
    return res;
  }

}