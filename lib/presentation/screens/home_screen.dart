import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sqs_mobile/presentation/screens/generate_screen.dart';
import 'package:sqs_mobile/presentation/screens/history_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_screen.dart';
import 'package:sqs_mobile/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  final List<Widget> _screen = [
    GenerateScreen(),
    ScanScreen(),
    HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screen),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: AppColors.light,
        items: <Widget>[
          Icon(
            Icons.add,
            size: 36,
            color: (_selectedIndex == 0) ? AppColors.light : AppColors.light,
          ),
          Icon(
            Icons.qr_code,
            size: 36,
            color: (_selectedIndex == 1) ? AppColors.light : AppColors.light,
          ),
          Icon(
            Icons.history,
            size: 36,
            color: (_selectedIndex == 2) ? AppColors.light : AppColors.light,
          ),
        ],
        onTap: _onItemTapped,
        animationCurve: Curves.easeOutCubic,
        buttonBackgroundColor: AppColors.primaryDark,
        color: AppColors.primaryLight,
      ),
    );
  }
}
