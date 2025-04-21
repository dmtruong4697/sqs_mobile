import 'package:flutter/material.dart';
import 'package:sqs_mobile/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String? placeholder;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.title,
    this.keyboardType = TextInputType.text,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Color.fromARGB(155, 0, 0, 0)),
            filled: true,
            fillColor: const Color.fromARGB(47, 124, 68, 79),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 1,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Vui lòng nhập $title";
            }
            return null;
          },
        ),
      ],
    );
  }
}
