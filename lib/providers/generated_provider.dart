import 'package:flutter/material.dart';
import 'package:sqs_mobile/data/models/generated.dart';
import 'package:sqs_mobile/data/repositories/generated_repository.dart';

class HistoryProvider extends ChangeNotifier {
  final GeneratedRepository _repo = GeneratedRepository();
  List<GeneratedModel> _generated = [];

  List<GeneratedModel> get history => _generated;

  Future<void> loadGenerated() async {
    _generated = await _repo.getAll();
    notifyListeners();
  }

  Future<void> addCode(GeneratedModel code) async {
    await _repo.insert(code);
    await loadGenerated();
  }

  Future<void> clearGenerated() async {
    await _repo.clear();
    _generated = [];
    notifyListeners();
  }
}
