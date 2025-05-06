import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  static Database? _db;

  static final instance = UserDatabase._privateConstructor();
  UserDatabase._privateConstructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'user.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE users(
            username TEXT PRIMARY KEY,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertUser(String username, String password) async {
    final db = await database;
    await db.insert(
      'users',
      {'username': username, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace, // Nếu trùng lặp sẽ thay thế
    );
  }

  Future<void> clearUser() async {
    final db = await database;
    await db.delete('users'); 
  }

  Future<User?> getUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }
}

class User {
  final String username;
  final String password;

  User({required this.username, required this.password});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }
}
