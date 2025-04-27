import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqs_mobile/data/models/scanned.dart';
import 'package:sqs_mobile/presentation/screens/generate/text_generate_screen.dart';
import 'package:sqs_mobile/presentation/screens/generate_result/text_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/generate_result/url_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_result/code128_scan_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_result/code39_scan_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_result/ean13_scan_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_result/ean8_scan_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_result/email_scan_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_result/text_scan_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_result/url_scan_result_screen.dart';
import 'package:sqs_mobile/presentation/widgets/generate_item_widget.dart';
import 'package:sqs_mobile/theme/app_colors.dart';
import 'package:sqs_mobile/utils/date_time_helper.dart';
import 'package:sqs_mobile/utils/type_helper.dart';

class ScannedHistoryItem extends StatefulWidget {
  final ScannedModel data;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ScannedHistoryItem({
    super.key,
    required this.data,
    this.onTap,
    this.onDelete,
  });

  @override
  _ScannedHistoryItemState createState() => _ScannedHistoryItemState();
}

class _ScannedHistoryItemState extends State<ScannedHistoryItem> {
  bool isDown = false;

  @override
  void initState() {
    super.initState();
    isDown = false;
  }

  void onNavigate() {
    if (widget.data.type == 'qrcode') {
      //xu ly qr code
      if (widget.data.qrType == 'text') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TextScanResultScreen(scanData: widget.data),
          ),
        );
      } else if (widget.data.qrType == 'url') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UrlScanResultScreen(scanData: widget.data),
          ),
        );
      } else if (widget.data.qrType == 'email') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailScanResultScreen(scanData: widget.data),
          ),
        );
      } else {
        //khong match loai nao
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TextScanResultScreen(scanData: widget.data),
          ),
        );
      }
    } else {
      //xu ly barcode
      if (widget.data.barcodeType == BarcodeType.code128.typeName) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => Code128ScanResultScreen(scanData: widget.data),
          ),
        );
      } else if (widget.data.barcodeType == BarcodeType.code39.typeName) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Code39ScanResultScreen(scanData: widget.data),
          ),
        );
      } else if (widget.data.barcodeType == BarcodeType.ean13.typeName) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Ean13ScanResultScreen(scanData: widget.data),
          ),
        );
      } else if (widget.data.barcodeType == BarcodeType.ean8.typeName) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Ean8ScanResultScreen(scanData: widget.data),
          ),
        );
      } else {
        //khong match loai nao
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => Code128ScanResultScreen(scanData: widget.data),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = formatDate(widget.data.createAt);
    final formattedTime = formatTime(widget.data.createAt);

    return GestureDetector(
      onTapDown: (_) => setState(() => isDown = true),
      onTapUp: (_) => setState(() => isDown = false),
      onTapCancel: () => setState(() => isDown = false),
      onTap: onNavigate,
      child: AnimatedOpacity(
        opacity: isDown ? 0.6 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Material(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
          elevation: 3,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.white.withOpacity(0.1),
            onTap: onNavigate,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      widget.data.type == 'qrcode'
                          ? Icons.qr_code
                          : Icons.view_week,
                      color: AppColors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data.content,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              widget.data.type == 'qrcode'
                                  ? 'QR Code • ${widget.data.qrType}'
                                  : 'Barcode • ${widget.data.barcodeType}',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 217, 217, 217),
                                fontSize: 13,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                '•',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 217, 217, 217),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              '$formattedDate • $formattedTime',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 217, 217, 217),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
