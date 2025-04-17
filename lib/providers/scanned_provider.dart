import 'package:flutter/material.dart';
import 'package:sqs_mobile/data/models/scanned.dart';
import 'package:sqs_mobile/data/repositories/Scanned_repository.dart';

class HistoryProvider extends ChangeNotifier {
  final ScannedRepository _repo = ScannedRepository();
  List<ScannedModel> _Scanned = [];

  List<ScannedModel> get history => _Scanned;

  Future<void> loadScanned() async {
    _Scanned = await _repo.getAll();
    notifyListeners();
  }

  Future<void> addCode(ScannedModel code) async {
    await _repo.insert(code);
    await loadScanned();
  }

  Future<void> clearScanned() async {
    await _repo.clear();
    _Scanned = [];
    notifyListeners();
  }
}
