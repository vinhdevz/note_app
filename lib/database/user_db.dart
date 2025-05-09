import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:developer' as developer;

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();
  static Database? _database;

  UserDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
      onDowngrade: _onDowngrade,
    );
  }

  Future _createDB(Database db, int version) async {
    developer.log('Creating database with version: $version');
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE login_state (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT
    )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    developer.log('Upgrading database from version $oldVersion to $newVersion');
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS login_state (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT
      )
      ''');
      developer.log('Created login_state table');
    }
  }

  Future _onDowngrade(Database db, int oldVersion, int newVersion) async {
    developer.log('Downgrading database from $oldVersion to $newVersion');
    await db.execute('DROP TABLE IF EXISTS login_state');
    await db.execute('DROP TABLE IF EXISTS users');
    await _createDB(db, newVersion);
  }

  String _hashPassword(String password) {
    return md5.convert(utf8.encode(password)).toString();
  }

  Future<bool> insertUser(String username, String password) async {
    final db = await database;
    try {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
      ''');
      await db.insert(
        'users',
        {
          'username': username,
          'password': _hashPassword(password),
        },
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      return true;
    } catch (e) {
      developer.log('Error inserting user: $e');
      return false;
    }
  }

  Future<bool> checkLogin(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, _hashPassword(password)],
    );
    return result.isNotEmpty;
  }

  Future<void> saveLoginState(String username) async {
    final db = await database;
    await db.delete('login_state');
    await db.insert(
      'login_state',
      {'username': username},
    );
  }

  Future<void> clearLoginState() async {
    final db = await database;
    await db.delete('login_state');
  }

  Future<String?> getSavedLogin() async {
    final db = await database;
    final result = await db.query('login_state');
    if (result.isNotEmpty) {
      return result.first['username'] as String?;
    }
    return null;
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}