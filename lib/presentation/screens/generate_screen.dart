import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqs_mobile/presentation/screens/about_screen.dart';
import 'package:sqs_mobile/presentation/screens/setting_screen.dart';
import 'package:sqs_mobile/presentation/widgets/barcode_generate_item.dart';
import 'package:sqs_mobile/presentation/widgets/generate_item_widget.dart';
import 'package:sqs_mobile/theme/app_colors.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final List<QRType> type = [
    QRType.text,
    QRType.url,
    // QRType.telephone,
    QRType.email,
  ];

  final List<BarcodeType> barcode_type = [
    BarcodeType.code128,
    BarcodeType.code39,
    BarcodeType.ean13,
    BarcodeType.ean8,
  ];

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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and menu button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Generate QR',
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
                SizedBox(height: 20),

                // QR Grid
                Text(
                  'QR Code',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: type.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return GenerateItemWidget(qrType: type[index]);
                  },
                ),

                SizedBox(height: 20),

                // Barcode Grid
                Text(
                  'Barcode',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: barcode_type.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return BarcodeGenerateItem(
                      barcodeType: barcode_type[index],
                    );
                  },
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
