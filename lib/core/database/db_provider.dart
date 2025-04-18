import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static final DBProvider _instance = DBProvider._internal();
  factory DBProvider() => _instance;
  DBProvider._internal();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDB();
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'qr_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            content TEXT,
            type TEXT,
            qrType TEXT,
            barcodeType TEXT,
            createAt TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE generated (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            content TEXT,
            type TEXT,
            qrType TEXT,
            barcodeType TEXT,
            createAt TEXT
          );
        ''');
      },
    );
  }
}
