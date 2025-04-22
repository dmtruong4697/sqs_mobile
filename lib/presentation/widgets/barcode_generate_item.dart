import 'package:flutter/material.dart';
import 'package:sqs_mobile/presentation/screens/generate/code128_generate_screen.dart';
import 'package:sqs_mobile/presentation/screens/generate/code39_generate_screen.dart';
import 'package:sqs_mobile/presentation/screens/generate/ean13_generate_screen.dart';
import 'package:sqs_mobile/presentation/screens/generate/ean8_generate_screen.dart';
import 'package:sqs_mobile/presentation/screens/generate/email_generate_screen.dart';
import 'package:sqs_mobile/presentation/screens/generate/text_generate_screen.dart';
import 'package:sqs_mobile/presentation/screens/generate/url_generate_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_screen.dart';
import 'package:sqs_mobile/presentation/widgets/generate_item_widget.dart';
import 'package:sqs_mobile/theme/app_colors.dart';

class BarcodeGenerateItem extends StatelessWidget {
  final BarcodeType barcodeType;
  const BarcodeGenerateItem({super.key, required this.barcodeType});

  Image _getIcon() {
    return Image.asset(
      'assets/icons/generate/barcode.png',
      height: 20,
      width: 20,
      color: AppColors.white,
      fit: BoxFit.contain,
    );
  }

  String _getTitle() {
    return barcodeType.name[0].toUpperCase() + barcodeType.name.substring(1);
  }

  void handleNavigation(BuildContext context) {
    Widget screen;
    switch (barcodeType) {
      case BarcodeType.code128:
        screen = Code128GenerateScreen(data: null);
        break;
      case BarcodeType.code39:
        screen = Code39GenerateScreen(data: null);
        break;
      case BarcodeType.ean13:
        screen = Ean13GenerateScreen(data: null);
        break;
      case BarcodeType.ean8:
        screen = Ean8GenerateScreen(data: null);
        break;
      default:
        screen = ScanScreen();
        break;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleNavigation(context),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 2, color: AppColors.primaryDark),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: _getIcon(),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _getTitle(),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
