// import 'package:flutter/material.dart';
// import 'package:barcode/barcode.dart';

// class BarcodePainter extends CustomPainter {
//   final String data;

//   BarcodePainter(this.data);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final barcode = Barcode.code128();

//     // Tạo đối tượng Paint
//     final paint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.fill;

//     // Gọi phương thức drawBarcode
//     barcode.drawBarcode(
//       canvas,
//       data,
//       width: size.width,
//       height: size.height,
//       drawText: false,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
