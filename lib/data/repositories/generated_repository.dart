import 'package:sqflite/sqflite.dart';
import 'package:sqs_mobile/core/database/db_provider.dart';
import 'package:sqs_mobile/data/models/generated.dart';

class GeneratedRepository {
  Future<int> insert(GeneratedModel code) async {
    final db = await DBProvider().database;
    final id = await db.insert(
      'generated',
      code.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<GeneratedModel>> getAll() async {
    final db = await DBProvider().database;
    final result = await db.query('generated', orderBy: 'createAt DESC');
    return result.map((e) => GeneratedModel.fromMap(e)).toList();
  }

  Future<void> update(GeneratedModel code) async {
    final db = await DBProvider().database;
    await db.update(
      'generated',
      code.toMap(),
      where: 'id = ?',
      whereArgs: [code.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id) async {
    final db = await DBProvider().database;
    await db.delete('generated', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clear() async {
    final db = await DBProvider().database;
    await db.delete('generated');
  }
}
