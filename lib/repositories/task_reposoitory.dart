import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class TaskRepository {
  static const String _tableName = 'tasks';

  Future<Database> _getDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'tasks.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            isCompleted INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<void> addTask(Task task) async {
    final db = await _getDatabase();
    await db.insert(_tableName, task.toMap());
  }

  Future<void> updateTask(Task task) async {
    final db = await _getDatabase();
    await db.update(
      _tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await _getDatabase();
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}