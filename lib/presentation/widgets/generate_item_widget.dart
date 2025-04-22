import 'package:flutter/material.dart';
import 'package:sqs_mobile/presentation/screens/generate/email_generate_screen.dart';
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

extension QRTypesExtension on QRType {
  int asInt() {
    return index;
  }

  static QRType fromString(String type) {
    switch (type) {
      case 'bluetooth':
        return QRType.bluetooth;
      case 'contact':
        return QRType.contact;
      case 'email':
        return QRType.email;
      case 'event':
        return QRType.event;
      case 'instagram':
        return QRType.instagram;
      case 'location':
        return QRType.location;
      case 'telephone':
        return QRType.telephone;
      case 'text':
        return QRType.text;
      case 'twitter':
        return QRType.twitter;
      case 'url':
        return QRType.url;
      case 'whatsapp':
        return QRType.whatsapp;
      case 'wifi':
        return QRType.wifi;
      default:
        return QRType.text; // Default fallback type
    }
  }

  String get typeName {
    switch (this) {
      case QRType.bluetooth:
        return 'bluetooth';
      case QRType.contact:
        return 'contact';
      case QRType.email:
        return 'email';
      case QRType.event:
        return 'event';
      case QRType.instagram:
        return 'instagram';
      case QRType.location:
        return 'location';
      case QRType.telephone:
        return 'telephone';
      case QRType.text:
        return 'text';
      case QRType.twitter:
        return 'twitter';
      case QRType.url:
        return 'url';
      case QRType.whatsapp:
        return 'whatsapp';
      case QRType.wifi:
        return 'wifi';
      default:
        return 'unknown';
    }
  }
}

enum BarcodeType { ean13, ean8, code39, code128, itf14, text }

extension BarcodeTypeExtension on BarcodeType {
  static BarcodeType fromString(String type) {
    switch (type) {
      case 'ean13':
        return BarcodeType.ean13;
      case 'ean8':
        return BarcodeType.ean13;
      case 'code39':
        return BarcodeType.ean13;
      case 'code128':
        return BarcodeType.code128;
      case 'itf14':
        return BarcodeType.itf14;
      case 'text':
        return BarcodeType.text;
      default:
        return BarcodeType.text; // fallback
    }
  }

  String get typeName {
    switch (this) {
      case BarcodeType.ean13:
        return 'ean13';
      case BarcodeType.ean8:
        return 'ean8';
      case BarcodeType.code39:
        return 'code39';
      case BarcodeType.code128:
        return 'code128';
      case BarcodeType.itf14:
        return 'itf14';
      case BarcodeType.text:
        return 'text';
      default:
        return 'unknown';
    }
  }
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
      case QRType.email:
        screen = EmailGenerateScreen(data: null);
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
