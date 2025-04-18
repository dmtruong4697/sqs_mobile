import 'package:flutter/material.dart';
import 'package:sqs_mobile/presentation/screens/generate/text_generate_screen.dart';
import 'package:sqs_mobile/presentation/screens/generate/url_generate_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_screen.dart';
import 'package:sqs_mobile/theme/app_colors.dart';

enum QRType {
  bluetooth,
  contact,
  email,
  event,
  instagram,
  location,
  telephone,
  text,
  twitter,
  url,
  whatsapp,
  wifi,
}

class GenerateItemWidget extends StatelessWidget {
  final QRType qrType;
  const GenerateItemWidget({super.key, required this.qrType});

  Image _getIcon() {
    return Image.asset(
      'assets/icons/generate/${qrType.name}.png',
      height: 20,
      width: 20,
      color: AppColors.white,
      fit: BoxFit.contain,
    );
  }

  String _getTitle() {
    return qrType.name[0].toUpperCase() + qrType.name.substring(1);
  }

  void handleNavigation(BuildContext context) {
    Widget screen;
    switch (qrType) {
      case QRType.text:
        screen = TextGenerateScreen(data: null);
        break;
      case QRType.url:
        screen = UrlGenerateScreen(data: null);
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
