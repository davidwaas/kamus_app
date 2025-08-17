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

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE words(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        meher TEXT,
        oirata TEXT,
        indonesia TEXT,
        inggris TEXT
      )
    ''');

    // Insert sample data hanya sekali saat database dibuat
    await db.insert('words', {
      'meher': "maya'u",
      'oirata': 'ante',
      'indonesia': 'saya',
      'inggris': 'I',
    });
    await db.insert('words', {
      'meher': "ma'ak",
      'oirata': "me'de",
      'indonesia': 'makan',
      'inggris': 'eat',
    });

    await db.insert('words', {
      'meher': "namkuru",
      'oirata': "ta'ya",
      'indonesia': 'tidur',
      'inggris': 'sleep',
    });
    await db.insert('words', {
      'meher': "kirna",
      'oirata': "hala",
      'indonesia': 'kebun',
      'inggris': 'garden',
    });
    await db.insert('words', {
      'meher': "pipi",
      'oirata': "hihiyotowa",
      'indonesia': 'kambing',
      'inggris': 'goat',
    });
    await db.insert('words', {
      'meher': "kaleuk",
      'oirata': "dthele",
      'indonesia': 'jagung',
      'inggris': 'corn',
    });
    await db.insert('words', {
      'meher': "kalla",
      'oirata': "iyar",
      'indonesia': 'jalan',
      'inggris': 'road',
    });
    await db.insert('words', {
      'meher': "i'in",
      'oirata': "ahi",
      'indonesia': 'ikan',
      'inggris': 'fish',
    });
    await db.insert('words', {
      'meher': "inhoi",
      'oirata': "uman",
      'indonesia': 'siapa',
      'inggris': 'who',
    });
    // ...tambahkan data lain sesuai kebutuhan...
  }

  Future<void> insertWordMultiLang({
    required String meher,
    required String oirata,
    required String indonesia,
    required String inggris,
  }) async {
    final db = await database;
    await db.insert('words', {
      'meher': meher,
      'oirata': oirata,
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
