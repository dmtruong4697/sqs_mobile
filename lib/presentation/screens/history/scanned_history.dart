import 'package:flutter/material.dart';
import 'package:sqs_mobile/data/models/scanned.dart';
import 'package:sqs_mobile/data/repositories/scanned_repository.dart';
import 'package:sqs_mobile/presentation/widgets/Scanned_history_item.dart';
import 'package:sqs_mobile/theme/app_colors.dart';
import 'package:sqs_mobile/utils/date_time_helper.dart';

class ScannedHistory extends StatefulWidget {
  const ScannedHistory({super.key});

  @override
  State<ScannedHistory> createState() => _ScannedHistoryState();
}

class _ScannedHistoryState extends State<ScannedHistory>
    with WidgetsBindingObserver {
  final ScannedRepository _scannedRepository = ScannedRepository();
  List<ScannedModel> scanned = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getScanned();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _getScanned();
    }
  }

  Future<void> _getScanned() async {
    final list = await _scannedRepository.getAll();
    setState(() {
      scanned = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      body: RefreshIndicator(
        color: AppColors.primaryLight,
        onRefresh: _getScanned,
        child: ListView.separated(
          padding: const EdgeInsets.all(0),
          itemCount: scanned.length,
          itemBuilder: (context, index) {
            return ScannedHistoryItem(data: scanned[index]);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
      ),
    );
  }
}
