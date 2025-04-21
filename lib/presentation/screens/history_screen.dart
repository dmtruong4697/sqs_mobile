import 'package:flutter/material.dart';
import 'package:sqs_mobile/presentation/screens/about_screen.dart';
import 'package:sqs_mobile/presentation/screens/history/generated_history.dart';
import 'package:sqs_mobile/presentation/screens/history/scanned_history.dart';
import 'package:sqs_mobile/presentation/screens/setting_screen.dart';
import 'package:sqs_mobile/theme/app_colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryDark),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.qr_code),
            //   title: Text('Generate Qr code'),
            // ),
            // ListTile(
            //   leading: Icon(Icons.qr_code_scanner),
            //   title: Text('Scan Qr code'),
            // ),
            // ListTile(leading: Icon(Icons.history), title: Text('History')),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
            ),
            ListTile(title: Text('1.0.0')),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     "assets/images/background.png",
          //     fit: BoxFit.cover,
          //   ),
          // ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Header: History + Menu icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'History',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Builder(
                        builder:
                            (context) => InkWell(
                              onTap: () => Scaffold.of(context).openDrawer(),
                              child: Image.asset(
                                'assets/icons/menu.png',
                                height: 32,
                                width: 32,
                                color: AppColors.primaryDark,
                              ),
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  /// Custom TabBar
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      tabs: const [Tab(text: 'Scan'), Tab(text: 'Generate')],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Tab content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        Center(child: ScannedHistory()),
                        Center(child: GeneratedHistory()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
