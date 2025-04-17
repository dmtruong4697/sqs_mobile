import 'package:flutter/material.dart';
import 'package:sqs_mobile/theme/app_colors.dart';

class SquareButton extends StatelessWidget {
  final String assets;
  final Function? onPress;
  final String title;

  const SquareButton({
    super.key,
    required this.assets,
    required this.onPress,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(12),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => onPress?.call(),
            child: Image.asset(
              assets,
              height: 50,
              width: 50,
              color: AppColors.primaryDark,
            ),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
