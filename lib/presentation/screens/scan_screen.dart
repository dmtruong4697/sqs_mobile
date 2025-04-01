import 'package:flutter/material.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    return const Text(
      "scan screen",
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 35,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}