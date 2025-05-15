import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/task_model.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._init();
  static Database? _database;

  TaskDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db', resetDB: false); 
    return _database!;
  }

  Future<Database> _initDB(String filePath, {bool resetDB = false}) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    if (resetDB) {
      await deleteDatabase(path);
    }

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        final columns = await db.rawQuery("PRAGMA table_info(tasks)");
        final hasIsCompleted = columns.any((col) => col['name'] == 'isCompleted');

        if (!hasIsCompleted) {
          await db.execute(
            'ALTER TABLE tasks ADD COLUMN isCompleted INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        priority INTEGER NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<int> createTask(TaskModel task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<TaskModel>> readAllTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks', orderBy: 'dateTime ASC');
    return result.map((map) => TaskModel.fromMap(map)).toList();
  }

  Future<int> updateTask(TaskModel task) async {
    final db = await instance.database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<Map<String, int>> loadTaskStats() async {
    final db = await instance.database;

    final completedResult = await db.rawQuery(
      'SELECT COUNT(*) FROM tasks WHERE isCompleted = 1',
    );
    final uncompletedResult = await db.rawQuery(
      'SELECT COUNT(*) FROM tasks WHERE isCompleted = 0',
    );

    final completed = Sqflite.firstIntValue(completedResult) ?? 0;
    final uncompleted = Sqflite.firstIntValue(uncompletedResult) ?? 0;

    return {
      'completed': completed,
      'uncompleted': uncompleted,
    };
  }
}
