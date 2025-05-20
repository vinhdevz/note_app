import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
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
      version: 5, 
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
        password TEXT NOT NULL,
        fullname TEXT,
        profileImage TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE login_state (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT,
        fullname TEXT
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    developer.log('Upgrading database from version $oldVersion to $newVersion');
    if (oldVersion < 5) {
      await db.execute('ALTER TABLE users ADD COLUMN profileImage TEXT');
      await db.execute('DROP TABLE IF EXISTS login_state');
      await db.execute('''
        CREATE TABLE login_state (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT,
          password TEXT,
          fullname TEXT
        )
      ''');
    }
  }

  Future _onDowngrade(Database db, int oldVersion, int newVersion) async {
    developer.log('Downgrading database from $oldVersion to $newVersion');
    await db.execute('DROP TABLE IF EXISTS login_state');
    await db.execute('DROP TABLE IF EXISTS users');
    await _createDB(db, newVersion);
  }

  String _hashPassword(String passWord) {
    return md5.convert(utf8.encode(passWord)).toString();
  }

  Future<bool> checkUsernameExists(String userName) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [userName.trim()],
    );
    return result.isNotEmpty;
  }

  Future<String> insertUser(String userName, String passWord, String fullName) async {
    final db = await database;
    try {
      final cleanUserName = userName.trim();
      final cleanPassWord = passWord.trim();
      final cleanFullName = fullName.trim();

      if (cleanUserName.isEmpty || cleanPassWord.isEmpty) {
        developer.log('Error inserting user: Username or password is empty');
        return 'Username or password cannot be empty';
      }

      if (await checkUsernameExists(cleanUserName)) {
        developer.log('Error inserting user: Username $cleanUserName already exists');
        return 'Username already exists';
      }

      await db.insert(
        'users',
        {
          'username': cleanUserName,
          'password': _hashPassword(cleanPassWord),
          'fullname': cleanFullName,
          'profileImage': '', 
        },
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      developer.log('User $cleanUserName inserted successfully');
      return 'success';
    } catch (e) {
      developer.log('Error inserting user: $e');
      return 'Error: $e';
    }
  }

  Future<bool> checkLogin(String userName, String passWord) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [userName.trim(), _hashPassword(passWord.trim())],
    );
    return result.isNotEmpty;
  }

  Future<void> saveLoginState(String userName) async {
    final db = await database;
    await db.delete('login_state');
    final user = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [userName.trim()],
      columns: ['username', 'password', 'fullname'],
    );
    if (user.isNotEmpty) {
      await db.insert(
        'login_state',
        {
          'username': userName.trim(),
          'password': '', 
          'fullname': user.first['fullname'] as String? ?? '',
        },
      );
    } else {
      await db.insert(
        'login_state',
        {
          'username': userName.trim(),
          'password': '',
          'fullname': '',
        },
      );
    }
    developer.log('Login state saved with username only: $userName');
  }

  Future<void> clearLoginState() async {
    final db = await database;
    await db.delete('login_state');
    developer.log('Login state cleared');
  }

  Future<Map<String, String>?> getSavedLogin() async {
    final db = await database;
    final result = await db.query('login_state');
    if (result.isNotEmpty) {
      final row = result.first;
      return {
        'username': row['username'] as String,
        'password': row['password'] as String,
        'fullname': row['fullname'] as String,
      };
    }
    return null;
  }

  Future<bool> updatePassWord({
    required String userName,
    required String oldPassWord,
    required String newPassWord,
  }) async {
    final db = await database;

    final hashedOldPass = _hashPassword(oldPassWord.trim());
    final hashedNewPass = _hashPassword(newPassWord.trim());

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [userName.trim(), hashedOldPass],
    );

    if (result.isNotEmpty) {
      await db.update(
        'users',
        {'password': hashedNewPass},
        where: 'username = ?',
        whereArgs: [userName.trim()],
      );
      developer.log('Password updated for user: $userName');
      return true;
    }
    developer.log('Failed to update password for user: $userName');
    return false;
  }

  Future<String?> getFullName(String userName) async {
    final db = await database;
    final result = await db.query(
      'users',
      columns: ['fullname'],
      where: 'username = ?',
      whereArgs: [userName.trim()],
    );
    if (result.isNotEmpty) {
      return result.first['fullname'] as String?;
    }
    return null;
  }

  Future<String?> getProfileImage(String userName) async {
    final db = await database;
    final result = await db.query(
      'users',
      columns: ['profileImage'],
      where: 'username = ?',
      whereArgs: [userName.trim()],
    );
    if (result.isNotEmpty) {
      return result.first['profileImage'] as String?;
    }
    return null;
  }

  Future<void> updateProfileImage(String userName, String imagePath) async {
    final db = await database;
    await db.update(
      'users',
      {'profileImage': imagePath.trim()},
      where: 'username = ?',
      whereArgs: [userName.trim()],
    );
    developer.log('Profile image updated for user: $userName');
  }

  Future<void> updateFullName(String userName, String newFullName) async {
    final db = await database;
    await db.update(
      'users',
      {'fullname': newFullName.trim()},
      where: 'username = ?',
      whereArgs: [userName.trim()],
    );
    await db.update(
      'login_state',
      {'fullname': newFullName.trim()},
      where: 'username = ?',
      whereArgs: [userName.trim()],
    );
    developer.log('Fullname updated to $newFullName for user: $userName');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
    developer.log('Database closed');
  }
}