import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqs_mobile/data/models/scanned.dart';
import 'package:sqs_mobile/presentation/screens/show_image_result_screen.dart';
import 'package:sqs_mobile/presentation/screens/webview_screen.dart';
import 'package:sqs_mobile/theme/app_colors.dart';
import 'package:sqs_mobile/utils/date_time_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class Ean8ScanResultScreen extends StatefulWidget {
  final ScannedModel scanData;

  const Ean8ScanResultScreen({super.key, required this.scanData});

  @override
  State<Ean8ScanResultScreen> createState() => _Ean8ScanResultScreenState();
}

class _Ean8ScanResultScreenState extends State<Ean8ScanResultScreen> {
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
  }

  Future<void> _launchInBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan', style: TextStyle(color: AppColors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.delete_outline),
          //   onPressed: () {
          //     print('Delete pressed');
          //   },
          //   tooltip: 'Xóa',
          // ),
          IconButton(
            icon: const Icon(
              Icons.favorite_border_outlined,
              color: AppColors.white,
            ),
            onPressed: () {
              print('Add pressed');
            },
            tooltip: 'Thêm',
          ),
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.white),
            onPressed: () {
              Share.share(widget.scanData.content);
            },
            tooltip: 'Chia sẻ',
          ),
        ],
        elevation: 4,
        backgroundColor: AppColors.primaryDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Barcode • ${formatDate(widget.scanData.createAt)} • ${formatTime(widget.scanData.createAt)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            print('Info pressed');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Text',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.scanData.content,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ShowImageResultScreen(
                              scanData: widget.scanData,
                            ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.view_week, size: 20),
                  label: const Text('Show Image'),
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
                  onPressed: () {
                    _copyToClipboard(widget.scanData.content);
                  },
                  icon: const Icon(Icons.copy, size: 20),
                  label: const Text('Copy Text'),
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
            SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final searchUrl =
                          'https://www.google.com/search?q=${Uri.encodeComponent(widget.scanData.content)}';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(url: searchUrl),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.public,
                      size: 20,
                      color: AppColors.white,
                    ),
                    label: const Text(
                      'Search with Google',
                      style: TextStyle(color: AppColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      backgroundColor: AppColors.primaryDark,
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final searchUrl =
                          'https://www.google.com/search?q=${Uri.encodeComponent(widget.scanData.content)}';
                      _launchInBrowser(searchUrl);
                    },
                    icon: const Icon(
                      Icons.public,
                      size: 20,
                      color: AppColors.white,
                    ),
                    label: const Text(
                      'Google search with default browser',
                      style: TextStyle(color: AppColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      backgroundColor: AppColors.primaryDark,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
