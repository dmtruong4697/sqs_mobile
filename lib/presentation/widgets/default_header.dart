import 'package:flutter/material.dart';
import 'package:sqs_mobile/theme/app_colors.dart';

class DefaultHeader extends StatelessWidget {
  final String title;

  const DefaultHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          GestureDetector(
            child: Image.asset(
              "assets/icons/back.png",
              height: 24,
              width: 24,
              color: AppColors.primaryDark,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(width: 14),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
