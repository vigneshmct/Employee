import 'package:flpfbonew/modelClass/employee.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  String noteTable = 'Employee_table';
  String PID = 'pid';
  String Name = 'name';
  String Role = 'role';
  String FromDate = "fromDate";
  String ToDate = "toDate";
  static Database _db;
  DatabaseHelper.internal();
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes.db');
    //await deleteDatabase(path); // just for testing
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $noteTable($PID INTEGER PRIMARY KEY AUTOINCREMENT, $Name String, $Role String, $ToDate String,$FromDate String)');
  }

  //GetAll Employee
  Future<List> getAllEmployee() async {
    var dbClient = await db;
    List<int> pids = [];
    var result = await dbClient.rawQuery('SELECT * FROM $noteTable');
    pids.addAll(result.map((e) => e[PID]));
    pids.toSet().toList();
    if(result.length == pids.length) {
      return result.toList();
    } else {
      var newResult = [];
      pids.forEach((pid) {
        Map<String,dynamic> addEmp;
        result.forEach((element) {
          if(pid == element[PID]){
            addEmp = {
              'pid': element[PID],
              'name': element[Name],
              'role': element[Role],
              'toDate': element[ToDate],
              'fromDate': element[FromDate]};
          }
        });
        newResult.add(addEmp);
      });
      print('fsdfdsf ${newResult.length}');
      return newResult.toList();
    }
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertNote(Employee note) async {
    Map<String,dynamic> param={
      'name':note.name,
      'role':note.role,
      'toDate':note.toDate,
      'fromDate':note.fromDate
    };
    Database db = await this.db;
    var result = await db.insert(noteTable, param);
    return result;
  }

  // Update Operation: Update a Note object to database
  Future<int> updateNote(Employee note) async {
    Map<String,dynamic> param={
      'name':note.name,
      'role':note.role,
      'toDate':note.toDate,
      'fromDate':note.fromDate
    };
    var db = await this.db;
    int pid = note.id;
    var result = await db.update(noteTable, param,
        where: '$PID = ?',whereArgs: [note.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await this.db;
    int result = await db.rawDelete(
        'DELETE FROM $noteTable WHERE $PID = $id');
    return result;
  }

  //total count
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        'SELECT ifnull(SUM(QTY),0) FROM $noteTable'));
  }
}
