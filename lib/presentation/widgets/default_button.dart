import 'package:flutter/material.dart';
import 'package:sqs_mobile/theme/app_colors.dart';

class DefaultButton extends StatelessWidget {
  final String title;
  final Function? onPress;

  const DefaultButton({super.key, required this.title, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 10),
          backgroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => onPress?.call(),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
