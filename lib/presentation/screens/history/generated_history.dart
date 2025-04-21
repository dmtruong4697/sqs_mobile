import 'package:flutter/material.dart';
import 'package:sqs_mobile/data/models/generated.dart';
import 'package:sqs_mobile/data/repositories/generated_repository.dart';
import 'package:sqs_mobile/presentation/widgets/generated_history_item.dart';
import 'package:sqs_mobile/theme/app_colors.dart';
import 'package:sqs_mobile/utils/date_time_helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
            return Slidable(
              key: Key(generated[index].id.toString()),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: 0.2,
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: SlidableAction(
                        onPressed: (context) async {
                          final deletedItem = generated[index];

                          await _generatedRepository.delete(
                            deletedItem.id.toString(),
                          );

                          setState(() {
                            generated.removeAt(index);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Deleted~!!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        spacing: 10,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // label: 'Delete',
                      ),
                    ),
                  ),
                ],
              ),
              child: GeneratedHistoryItem(data: generated[index]),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
      ),
    );
  }
}
