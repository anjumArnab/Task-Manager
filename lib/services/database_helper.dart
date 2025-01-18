/*
import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:database_app/models/note.dart';

class DatabaseHelper {
  String noteTable = "note_table";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colPriority = "priority";
  String colDate = "date";

  static DatabaseHelper? _databaseHelper; // Changed to nullable
  static Database? _database; // Changed to nullable
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
    // Get the directory path for both Android and iOS to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/notes.db';

    // Open or create the database at the given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);

    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  // Fetch operation
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  // Insert operation
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  // Update operation
  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  // Delete operation
  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result = await db.delete(noteTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  // Get number of Note objects in database
  Future<int?> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> res =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int? result = Sqflite.firstIntValue(res);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = [];
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
*/
import 'dart:async';
import 'dart:io';
import 'package:database_app/models/task_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper {
  String taskTable = "task_table"; // Changed to task_table
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colTimeAndDate = "timeAndDate"; // Updated column name for time and date
  String colPriority = "priority";
  String colIsChecked = "isChecked"; // Updated for boolean field

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

