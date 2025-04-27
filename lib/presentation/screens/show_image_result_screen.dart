import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart' as bw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqs_mobile/data/models/scanned.dart';
import 'package:sqs_mobile/theme/app_colors.dart';

class ShowImageResultScreen extends StatefulWidget {
  final ScannedModel scanData;

  const ShowImageResultScreen({super.key, required this.scanData});

  @override
  State<ShowImageResultScreen> createState() => _ShowImageResultScreenState();
}

class _ShowImageResultScreenState extends State<ShowImageResultScreen> {
  final GlobalKey qrKey = GlobalKey();

  Future<void> _saveOrShareImage({bool isShare = false}) async {
    try {
      RenderRepaintBoundary boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qr_image.png').create();
      await file.writeAsBytes(pngBytes);

      if (isShare) {
        await Share.shareXFiles([
          XFile(file.path),
        ], text: "Here is your QR/Barcode image!");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved to clipboard')),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String content = widget.scanData.content;
    final bool isQR = widget.scanData.type == 'qrcode';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primaryDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Center(
            child: RepaintBoundary(
              key: qrKey,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child:
                    isQR
                        ? QrImageView(
                          data: content,
                          version: QrVersions.auto,
                          size: 300.0,
                        )
                        : bw.BarcodeWidget(
                          data: content,
                          barcode: bw.Barcode.code128(),
                          width: 300,
                          height: 100,
                          drawText: true,
                        ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _saveOrShareImage(isShare: false),
                icon: const Icon(Icons.download),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.black.withOpacity(0.1),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _saveOrShareImage(isShare: true),
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.black.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
