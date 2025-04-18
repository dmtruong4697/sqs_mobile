import 'package:flutter/material.dart';
import 'package:sqs_mobile/data/models/generated.dart';
import 'package:sqs_mobile/data/repositories/generated_repository.dart';
import 'package:sqs_mobile/presentation/widgets/generated_history_item.dart';
import 'package:sqs_mobile/theme/app_colors.dart';
import 'package:sqs_mobile/utils/date_time_helper.dart';

class GeneratedHistory extends StatefulWidget {
  const GeneratedHistory({super.key});

  @override
  State<GeneratedHistory> createState() => _GeneratedHistoryState();
}

class _GeneratedHistoryState extends State<GeneratedHistory>
    with WidgetsBindingObserver {
  final GeneratedRepository _generatedRepository = GeneratedRepository();
  List<GeneratedModel> generated = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getGenerated();
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
      _getGenerated();
    }
  }

  Future<void> _getGenerated() async {
    final list = await _generatedRepository.getAll();
    setState(() {
      generated = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      body: RefreshIndicator(
        color: AppColors.primaryLight,
        onRefresh: _getGenerated,
        child: ListView.separated(
          padding: const EdgeInsets.all(0),
          itemCount: generated.length,
          itemBuilder: (context, index) {
            return GeneratedHistoryItem(data: generated[index]);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
      ),
    );
  }
}
