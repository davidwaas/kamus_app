import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'kamus.sqlite');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE words (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            meher TEXT,
            ohoirata TEXT,
            indonesia TEXT,
            inggris TEXT,
            UNIQUE(meher, ohoirata, indonesia, inggris) ON CONFLICT IGNORE
          )
        ''');
      },
    );
  }

  Future<void> insertWordMultiLang({
    required String meher,
    required String ohoirata,
    required String indonesia,
    required String inggris,
  }) async {
    final db = await database;
    await db.insert('words', {
      'meher': meher,
      'ohoirata': ohoirata,
      'indonesia': indonesia,
      'inggris': inggris,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Map<String, dynamic>>> searchByLanguage({
    required String keyword,
    required String language,
  }) async {
    final db = await database;
    return await db.query(
      'words',
      where: '$language LIKE ?',
      whereArgs: ['%$keyword%'],
    );
  }

  Future<List<Map<String, dynamic>>> getAllWords() async {
    final db = await database;
    return await db.query('words');
  }
}
