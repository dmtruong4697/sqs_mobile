import 'package:flutter/material.dart';
import 'package:sqs_mobile/presentation/widgets/generate_item_widget.dart';
import 'package:sqs_mobile/theme/app_colors.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final List<QRType> type = [
    QRType.text,
    QRType.url,
    QRType.wifi,
    QRType.bluetooth,
    QRType.telephone,
    QRType.email,
    QRType.contact,
    QRType.event,
    QRType.location,
    QRType.whatsapp,
    QRType.twitter,
    QRType.instagram,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Generate QR',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print('click');
                          },
                          child: Image.asset(
                            'assets/icons/menu.png',
                            height: 32,
                            width: 32,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 800,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          return GenerateItemWidget(qrType: type[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
