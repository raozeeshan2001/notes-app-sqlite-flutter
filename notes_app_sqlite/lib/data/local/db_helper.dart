import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  //singleton
  DbHelper._();
  static final DbHelper getinstance = DbHelper._();
  Database? myDb;
  final String TABLE_NOTE = 'note';
  final String COLUMN_NOTE_SNO = 's_no';
  final String COLUMN_NOTE_TITLE = 'title';
  final String COLUMN_NOTE_DESC = 'description';

  Future<Database> getdb() async {
    myDb ??= await opendb();
    return myDb!;
    // if (myDb != null) {
    //   return myDb!;
    // } else {
    //   myDb = await opendb();
    //   return myDb!;
    // }
  }

  Future<Database> opendb() async {
    Directory appdir = await getApplicationDocumentsDirectory();
    String path = join(appdir.path, 'notesDb.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
  CREATE TABLE $TABLE_NOTE (
    $COLUMN_NOTE_SNO INTEGER PRIMARY KEY AUTOINCREMENT,
    $COLUMN_NOTE_TITLE TEXT,
    $COLUMN_NOTE_DESC TEXT
  )
''');
    });
  }

  Future<bool> addNote({required String mTitle, required String mdesc}) async {
    var db = await getdb();
    int rowseffected = await db.insert(
        TABLE_NOTE, {COLUMN_NOTE_TITLE: mTitle, COLUMN_NOTE_DESC: mdesc});
    return rowseffected > 0;
  }

  Future<List<Map<String, dynamic>>> getallNotes() async {
    var db = await getdb();
    List<Map<String, dynamic>> mData = await db.query(TABLE_NOTE);
    return mData;
  }

  Future<bool> UpdateNote(
      {required String mtitle, required String mdesc, required int sno}) async {
    var db = await getdb();
    int rowseffected = await db.update(
        TABLE_NOTE,
        {
          COLUMN_NOTE_TITLE: mtitle,
          COLUMN_NOTE_DESC: mdesc,
          COLUMN_NOTE_SNO: sno,
        },
        where: "$COLUMN_NOTE_SNO= $sno");
    return rowseffected > 0;
  }

  Future<bool> DeleteNote({required int sno}) async {
    var db = await getdb();
    int rowseffected = await db
        .delete(TABLE_NOTE, where: "$COLUMN_NOTE_SNO=?", whereArgs: ['$sno']);
    return rowseffected > 0;
  }
}
