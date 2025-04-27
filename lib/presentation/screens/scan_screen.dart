import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqs_mobile/data/models/scanned.dart';
import 'package:sqs_mobile/data/repositories/scanned_repository.dart';
import 'package:sqs_mobile/presentation/screens/about_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_result/code128_scan_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_result/code39_scan_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_result/ean13_scan_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_result/ean8_scan_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_result/email_scan_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_result/text_scan_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/scan_result/url_scan_result_screen.dart';
import 'dart:io';

import 'package:sqs_mobile/presentation/screens/scan_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/setting_screen.dart';
import 'package:sqs_mobile/presentation/widgets/generate_item_widget.dart';
import 'package:sqs_mobile/theme/app_colors.dart';
import 'package:sqs_mobile/utils/type_helper.dart';
import 'package:vibration/vibration.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
    as mlkit;
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

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

  bool soundEnabled = true;
  bool vibrateEnabled = true;

  @override
  void initState() {
    super.initState();
    initSettings();
  }

  @override
  void dispose() {
    controller?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> initSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      soundEnabled = prefs.getBool('sound') ?? true;
      vibrateEnabled = prefs.getBool('vibrate') ?? true;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isScanning && scanData.code != null) {
        setState(() {
          isScanning = false;
        });

        await controller.pauseCamera();

        final scannedCode = ScannedModel(
          content: scanData.code.toString(),
          type: scanData.format == BarcodeFormat.qrcode ? 'qrcode' : 'barcode',
          createAt: DateTime.now(),
          qrType: detectQRType(scanData.code.toString()).typeName,
          barcodeType: detectBarcodeType(scanData.code.toString()).typeName,
        );

        _scannedRepository.insert(scannedCode);
        if (soundEnabled) {
          _audioPlayer.play(AssetSource('sounds/beep.mp3'));
        }
        if (vibrateEnabled) {
          if (await Vibration.hasAmplitudeControl()) {
            Vibration.vibrate(amplitude: 128);
          }
        }

        await _handleNavigate(scannedCode);

        await controller.resumeCamera();
        setState(() {
          isScanning = true;
        });
      }
    });
  }

  Future<void> _handleNavigate(ScannedModel data) async {
    if (data.type == 'qrcode') {
      if (data.qrType == QRType.text.typeName) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TextScanResultScreen(scanData: data),
          ),
        );
      } else if (data.qrType == QRType.url.typeName) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UrlScanResultScreen(scanData: data),
          ),
        );
      } else if (data.qrType == QRType.email.typeName) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailScanResultScreen(scanData: data),
          ),
        );
      } else {
        //khong match loai nao
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TextScanResultScreen(scanData: data),
          ),
        );
      }
    } else {
      //handle barcode
      if (data.barcodeType == BarcodeType.code128.typeName) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Code128ScanResultScreen(scanData: data),
          ),
        );
      } else if (data.barcodeType == BarcodeType.code39.typeName) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Code39ScanResultScreen(scanData: data),
          ),
        );
      } else if (data.barcodeType == BarcodeType.ean13.typeName) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Ean13ScanResultScreen(scanData: data),
          ),
        );
      } else if (data.barcodeType == BarcodeType.ean8.typeName) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Ean8ScanResultScreen(scanData: data),
          ),
        );
      } else {
        //khong match loai nao
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Code128ScanResultScreen(scanData: data),
          ),
        );
      }
    }
  }

  Future<void> _pickImageAndScan() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await controller?.pauseCamera();
      final inputImage = InputImage.fromFilePath(image.path);
      final barcodeScanner = mlkit.BarcodeScanner();

      try {
        final List<mlkit.Barcode> barcodes = await barcodeScanner.processImage(
          inputImage,
        );

        if (barcodes.isNotEmpty) {
          final barcode = barcodes.first;
          final code = barcode.rawValue ?? '';
          final format = barcode.format;

          final scannedCode = ScannedModel(
            content: code,
            type: format == mlkit.BarcodeFormat.qrCode ? 'qrcode' : 'barcode',
            createAt: DateTime.now(),
            qrType: detectQRType(code).typeName,
            barcodeType: detectBarcodeType(code).typeName,
          );

          await _scannedRepository.insert(scannedCode);

          if (soundEnabled) {
            await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
          }

          if (vibrateEnabled && await Vibration.hasAmplitudeControl()) {
            Vibration.vibrate(amplitude: 128);
          }

          await _handleNavigate(scannedCode);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No QR code or Barcode found in the image.'),
            ),
          );
        }
      } catch (e) {
        log('Lỗi khi quét ảnh: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred while processing the image.'),
          ),
        );
      } finally {
        await controller?.resumeCamera();
      }
    }
  }

  void _toggleFlash() async {
    try {
      await controller?.toggleFlash();
      final isOn = await controller?.getFlashStatus();
      setState(() {
        isFlashOn = isOn ?? false;
      });
    } catch (e) {
      debugPrint('Flash cannot be turned on/off: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'The device does not support flash or an error has occurred.',
          ),
        ),
      );
    }
  }

  void _flipCamera() async {
    await controller?.flipCamera();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cutOutSize = screenSize.width * 0.8;

    return Scaffold(
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
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingScreen(),
                  ),
                );
                initSettings();
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
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Term of use & Privacy policy'),
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
                  tooltip: 'Choose image',
                ),
                IconButton(
                  icon: Icon(
                    isFlashOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  ),
                  onPressed: _toggleFlash,
                  tooltip: 'Turn on/off flash',
                ),
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                  onPressed: _flipCamera,
                  tooltip: 'Flip camera',
                ),
                Builder(
                  builder:
                      (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        tooltip: 'Menu',
                      ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Place the QR/Barcode inside the frame to scan.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
