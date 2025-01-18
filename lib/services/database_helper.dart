import 'dart:async';
import 'dart:io';
import 'package:database_app/models/task_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper {
  String taskTable = "task_table";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colTimeAndDate = "timeAndDate";
  String colPriority = "priority";
  String colIsChecked = "isChecked";

  static DatabaseHelper? _databaseHelper;
  static Database? _database;
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/tasks.db'; // Updated database file name

    var tasksDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return tasksDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $taskTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT, $colTimeAndDate TEXT, $colPriority TEXT, $colIsChecked INTEGER)');
  }

  // Fetch operation
  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.database;
    var result = await db.query(taskTable, orderBy: '$colPriority ASC');
    return result;
  }

  // Insert operation
  Future<int> insertTask(Task task) async {
    Database db = await this.database;
    var result = await db.insert(taskTable, task.toMap());
    return result;
  }

  // Update operation
  Future<int> updateTask(Task task) async {
    Database db = await this.database;
    var result = await db.update(taskTable, task.toMap(),
        where: '$colId = ?', whereArgs: [task.id]);
    return result;
  }

  // Delete operation
  Future<int> deleteTask(int id) async {
    Database db = await this.database;
    var result = await db.delete(taskTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  // Get number of Task objects in database
  Future<int?> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> res = await db.rawQuery('SELECT COUNT (*) from $taskTable');
    int? result = Sqflite.firstIntValue(res);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Task List' [ List<Task> ]
  Future<List<Task>> getTaskList() async {
    var taskMapList = await getTaskMapList();
    int count = taskMapList.length;

    List<Task> taskList = [];
    for (int i = 0; i < count; i++) {
      taskList.add(Task.fromMapObject(taskMapList[i]));
    }
    return taskList;
  }
}

