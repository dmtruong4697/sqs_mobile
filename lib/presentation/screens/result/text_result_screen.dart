import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqs_mobile/data/models/generated.dart';
import 'package:sqs_mobile/data/repositories/generated_repository.dart';
import 'package:sqs_mobile/presentation/widgets/default_button.dart';
import 'package:sqs_mobile/presentation/widgets/default_header.dart';
import 'package:sqs_mobile/presentation/widgets/square_button.dart';
import 'package:sqs_mobile/presentation/widgets/text_field.dart';
import 'package:sqs_mobile/theme/app_colors.dart';
import 'package:path_provider/path_provider.dart';

class TextResultScreen extends StatefulWidget {
  final String textData;
  const TextResultScreen({super.key, required this.textData});

  @override
  State<TextResultScreen> createState() => _TextResultScreenState();
}

class _TextResultScreenState extends State<TextResultScreen> {
  final GlobalKey qrKey = GlobalKey();
  final GeneratedRepository _generatedRepository = GeneratedRepository();
  bool _hasSaved = false;
  int record = 0;

  @override
  void initState() {
    super.initState();
    _saveGenerated();
  }

  Future<void> _saveGenerated() async {
    if (_hasSaved) return;
    final generatedCode = GeneratedModel(
      content: widget.textData,
      type: 'text',
      createAt: DateTime.now(),
    );
    await _generatedRepository.insert(generatedCode);
    final list = await _generatedRepository.getAll();
    setState(() {
      _hasSaved = true;
      record = list.length;
    });
  }

  Future<void> _showQrShare() async {
    try {
      RenderRepaintBoundary boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qr_image.png').create();
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: "Here is your QR code!");
    } catch (e) {
      print("Error while sharing QR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.light,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/background.png",
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DefaultHeader(title: "Back"),
                    const SizedBox(height: 15),

                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              width: 5,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RepaintBoundary(
                                      key: qrKey,
                                      child: QrImageView(
                                        data: widget.textData,
                                        version: QrVersions.auto,
                                        size: 220,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SquareButton(
                            title: "Edit",
                            assets: "assets/icons/edit.png",
                            onPress: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: 20),
                          SquareButton(
                            title: "Share",
                            assets: "assets/icons/share.png",
                            onPress: _showQrShare,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    FractionallySizedBox(
                      widthFactor: 0.94,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.symmetric(),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/generate/text.png",
                                          height: 60,
                                          width: 60,
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Text",
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            // Text(
                                            //   "16 Dec 2022, 9:30 pm",
                                            //   style: TextStyle(
                                            //     fontSize: 14,
                                            //     fontWeight: FontWeight.w200,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                      indent: 10,
                                      endIndent: 10,
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.textData,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: CircleBorder(),
                                          ),
                                          child: Image.asset(
                                            "assets/icons/copy.png",
                                            height: 22,
                                            width: 22,
                                          ),

                                          onPressed: () {
                                            Clipboard.setData(
                                              ClipboardData(
                                                text: widget.textData,
                                              ),
                                            );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Copied to clipboard',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                backgroundColor: Colors.black
                                                    .withOpacity(0.5),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 10,
                                                ),
                                                elevation: 6,
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
