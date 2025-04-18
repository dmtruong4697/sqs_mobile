import 'package:sqflite/sqflite.dart';
import 'package:sqs_mobile/core/database/db_provider.dart';
import 'package:sqs_mobile/data/models/scanned.dart';

class ScannedRepository {
  Future<void> insert(ScannedModel code) async {
    final db = await DBProvider().database;
    await db.insert(
      'scanned',
      code.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ScannedModel>> getAll() async {
    final db = await DBProvider().database;
    final result = await db.query('scanned', orderBy: 'createAt DESC');
    return result.map((e) => ScannedModel.fromMap(e)).toList();
  }

  Future<void> update(ScannedModel code) async {
    final db = await DBProvider().database;
    await db.update(
      'scanned',
      code.toMap(),
      where: 'id = ?',
      whereArgs: [code.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id) async {
    final db = await DBProvider().database;
    await db.delete('scanned', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clear() async {
    final db = await DBProvider().database;
    await db.delete('scanned');
  }
}
