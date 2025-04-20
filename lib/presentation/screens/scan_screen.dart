import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sqs_mobile/data/models/scanned.dart';
import 'package:sqs_mobile/data/repositories/scanned_repository.dart';
import 'package:sqs_mobile/presentation/screens/scan_result/text_scan_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_result/url_scan_result_screen.dart';
import 'dart:io';

import 'package:sqs_mobile/presentation/screens/scan_result_screen.dart';
import 'package:sqs_mobile/presentation/widgets/generate_item_widget.dart';
import 'package:sqs_mobile/utils/type_helper.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final ScannedRepository _scannedRepository = ScannedRepository();
  QRViewController? controller;
  bool isScanning = true;
  bool isFlashOn = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    controller?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isScanning && scanData.code != null) {
        await controller.pauseCamera();

        final scannedCode = ScannedModel(
          content: scanData.code.toString(),
          type: scanData.format == BarcodeFormat.qrcode ? 'qrcode' : 'barcode',
          createAt: DateTime.now(),
          qrType: detectQRType(scanData.code.toString()).typeName,
          barcodeType: detectBarcodeType(scanData.code.toString()).typeName,
        );

        _scannedRepository.insert(scannedCode);
        _audioPlayer.play(AssetSource('sounds/beep.mp3'));

        setState(() {
          isScanning = false;
        });

        await _handleNavigate(scannedCode);
        await controller.resumeCamera();

        setState(() {
          isScanning = true;
        });
      }
    });
  }

  Future<void> _handleNavigate(ScannedModel data) async {
    if (data.type == 'qrcode' && data.qrType == QRType.text.typeName) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TextScanResultScreen(scanData: data),
        ),
      );
    } else if (data.type == 'qrcode' && data.qrType == QRType.url.typeName) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UrlScanResultScreen(scanData: data),
        ),
      );
    }
  }

  Future<void> _pickImageAndScan() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await controller?.pauseCamera();
      print('Ảnh đã chọn: ${image.path}');
      String? result = 'Kết quả từ ảnh (placeholder)';
      if (result != null) {
        // await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ScanResultScreen(scanData: result),
        //   ),
        // ).then((_) {
        //   controller?.resumeCamera();
        // });
      } else {
        controller?.resumeCamera();
      }
    }
  }

  void _toggleFlash() async {
    await controller?.toggleFlash();
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }

  void _flipCamera() async {
    await controller?.flipCamera();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cutOutSize = screenSize.width * 0.8;

    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: cutOutSize,
              overlayColor: Colors.black.withOpacity(0.7),
              cutOutBottomOffset: 60,
            ),
          ),
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo, color: Colors.white),
                  onPressed: _pickImageAndScan,
                  tooltip: 'Mở thư viện ảnh',
                ),
                IconButton(
                  icon: Icon(
                    isFlashOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  ),
                  onPressed: _toggleFlash,
                  tooltip: 'Bật/tắt đèn flash',
                ),
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                  onPressed: _flipCamera,
                  tooltip: 'Xoay camera',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
