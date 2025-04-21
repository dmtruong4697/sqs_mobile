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
import 'package:sqs_mobile/presentation/screens/generate/email_generate_screen.dart';
import 'package:sqs_mobile/presentation/screens/generate/text_generate_screen.dart';
import 'package:sqs_mobile/presentation/screens/generate/url_generate_screen.dart';
import 'package:sqs_mobile/presentation/widgets/default_button.dart';
import 'package:sqs_mobile/presentation/widgets/default_header.dart';
import 'package:sqs_mobile/presentation/widgets/square_button.dart';
import 'package:sqs_mobile/presentation/widgets/text_field.dart';
import 'package:sqs_mobile/theme/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailResultScreen extends StatefulWidget {
  final String textData;
  final GeneratedModel? data;
  final bool isFromHistoryList;
  const EmailResultScreen({
    super.key,
    required this.textData,
    required this.isFromHistoryList,
    this.data,
  });

  @override
  State<EmailResultScreen> createState() => _EmailResultScreenState();
}

class _EmailResultScreenState extends State<EmailResultScreen> {
  final GlobalKey qrKey = GlobalKey();
  int record = 0;

  @override
  void initState() {
    super.initState();
  }

  // tach chi tiet email
  Map<String, String>? parseMatmsg(String input) {
    if (!input.startsWith('MATMSG:')) return null;

    final to = RegExp(r'TO:([^;]+);').firstMatch(input)?.group(1);
    final sub = RegExp(r'SUB:([^;]+);').firstMatch(input)?.group(1);
    final body = RegExp(r'BODY:([^;]+);').firstMatch(input)?.group(1);

    if (to == null || sub == null || body == null) return null;

    return {'address': to, 'subject': sub, 'message': body};
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

  void _handlePressEdit() {
    if (widget.isFromHistoryList) {
      Navigator.pop(context);
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailGenerateScreen(data: widget.data),
          ),
        );
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: parseMatmsg(widget.textData)?['address'] ?? '',
      queryParameters: {
        'subject': parseMatmsg(widget.textData)?['subject'] ?? '',
        'body': parseMatmsg(widget.textData)?['message'] ?? '',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email client.';
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

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                  ),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                            const SizedBox(height: 25),
                            FractionallySizedBox(
                              widthFactor: 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SquareButton(
                                    title: "Edit",
                                    assets: "assets/icons/edit.png",
                                    onPress: _handlePressEdit,
                                  ),
                                  const SizedBox(width: 20),
                                  SquareButton(
                                    title: "Share",
                                    assets: "assets/icons/share.png",
                                    onPress: _showQrShare,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                            FractionallySizedBox(
                              widthFactor: 0.94,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: const Border.symmetric(),
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/icons/generate/email.png",
                                                  height: 50,
                                                  width: 50,
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      "EMAIL",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              color: Colors.grey,
                                              thickness: 1,
                                              indent: 10,
                                              endIndent: 10,
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    widget.textData,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape:
                                                            const CircleBorder(),
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
                                                        content: const Text(
                                                          'Copied to clipboard',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        backgroundColor: Colors
                                                            .black
                                                            .withOpacity(0.5),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                        margin:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 10,
                                                            ),
                                                        elevation: 6,
                                                        duration:
                                                            const Duration(
                                                              seconds: 2,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child: Image.asset(
                                                    "assets/icons/copy.png",
                                                    height: 22,
                                                    width: 22,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              color: Colors.grey,
                                              thickness: 1,
                                              indent: 10,
                                              endIndent: 10,
                                            ),
                                            SizedBox(height: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Email: ${parseMatmsg(widget.textData)?['address'] ?? ''}',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                Text(
                                                  'Subject: ${parseMatmsg(widget.textData)?['subject'] ?? ''}',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                Text(
                                                  'Message: ${parseMatmsg(widget.textData)?['message'] ?? ''}',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
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
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: sendEmail,
                                icon: const Icon(
                                  Icons.mail,
                                  size: 20,
                                  color: AppColors.primaryDark,
                                ),
                                label: const Text(
                                  'Send mail',
                                  style: TextStyle(
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  backgroundColor: AppColors.white,
                                  foregroundColor: Colors.black,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  shadowColor: Colors.black.withOpacity(0.1),
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                            ),
                            SizedBox(height: 160),
                          ],
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
