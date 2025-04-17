import 'package:sqflite/sqflite.dart';
import 'package:sqs_mobile/core/database/db_provider.dart';
import 'package:sqs_mobile/data/models/generated.dart';

class GeneratedRepository {
  Future<void> insert(GeneratedModel code) async {
    final db = await DBProvider().database;
    await db.insert(
      'generated',
      code.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<GeneratedModel>> getAll() async {
    final db = await DBProvider().database;
    final result = await db.query('generated', orderBy: 'createAt DESC');
    return result.map((e) => GeneratedModel.fromMap(e)).toList();
  }

  Future<void> clear() async {
    final db = await DBProvider().database;
    await db.delete('generated');
  }
}
