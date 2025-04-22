import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'package:sqs_mobile/data/models/scanned.dart';
import 'package:sqs_mobile/presentation/screens/show_image_result_screen.dart';
import 'package:sqs_mobile/theme/app_colors.dart';
import 'package:sqs_mobile/utils/date_time_helper.dart';
import 'package:sqs_mobile/utils/email_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailScanResultScreen extends StatefulWidget {
  final ScannedModel scanData;

  const EmailScanResultScreen({super.key, required this.scanData});

  @override
  State<EmailScanResultScreen> createState() => _EmailScanResultScreenState();
}

class _EmailScanResultScreenState extends State<EmailScanResultScreen> {
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã sao chép vào clipboard')));
  }

  Future<void> sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: parseMatmsg(widget.scanData.content)?['address'] ?? '',
      queryParameters: {
        'subject': parseMatmsg(widget.scanData.content)?['subject'] ?? '',
        'body': parseMatmsg(widget.scanData.content)?['message'] ?? '',
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
            icon: const Icon(Icons.add, color: AppColors.white),
            onPressed: () {
              print('Add pressed');
            },
            tooltip: 'Thêm',
          ),
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.white),
            onPressed: () {
              print('Share pressed');
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
                          'QRCode • ${formatDate(widget.scanData.createAt)} • ${formatTime(widget.scanData.createAt)}',
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
                      'Email address:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 8),
                    Text(
                      parseMatmsg(widget.scanData.content)?['address'] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                    ),
                    const Text(
                      'Subject:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 8),
                    Text(
                      parseMatmsg(widget.scanData.content)?['subject'] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                    ),
                    const Text(
                      'Message:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 8),
                    Text(
                      parseMatmsg(widget.scanData.content)?['message'] ?? '',
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
                  icon: const Icon(Icons.qr_code, size: 20),
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
                  style: TextStyle(color: AppColors.primaryDark),
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
          ],
        ),
      ),
    );
  }
}
