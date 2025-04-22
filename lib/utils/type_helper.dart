import 'package:sqs_mobile/presentation/widgets/generate_item_widget.dart';

QRType detectQRType(String input) {
  input = input.trim();

  if (input.startsWith("WIFI:")) {
    return QRType.wifi;
  } else if (input.startsWith("BT:")) {
    return QRType.bluetooth;
  } else if (input.startsWith("TEL:") ||
      RegExp(r"^\+?\d{7,}$").hasMatch(input)) {
    return QRType.telephone;
  } else if (input.startsWith("mailto:") ||
      RegExp(r"^[\w\.-]+@[\w\.-]+\.\w{2,}$").hasMatch(input)) {
    return QRType.email;
  } else if (input.startsWith("MATMSG:TO:")) {
    return QRType.email;
  } else if (input.startsWith("MECARD:") || input.startsWith("BEGIN:VCARD")) {
    return QRType.contact;
  } else if (input.startsWith("BEGIN:VEVENT") ||
      input.contains("SUMMARY:") && input.contains("DTSTART:")) {
    return QRType.event;
  } else if (input.startsWith("geo:") ||
      input.contains("lat:") && input.contains("lng:")) {
    return QRType.location;
  } else if (input.contains("wa.me") || input.contains("whatsapp.com")) {
    return QRType.whatsapp;
  } else if (input.contains("twitter.com/")) {
    return QRType.twitter;
  } else if (input.contains("instagram.com/")) {
    return QRType.instagram;
  } else if (Uri.tryParse(input)?.hasScheme == true &&
      Uri.tryParse(input)?.hasAuthority == true) {
    return QRType.url;
  }

  return QRType.text;
}

BarcodeType detectBarcodeType(String input) {
  input = input.trim();

  if (RegExp(r'^\d{12,13}$').hasMatch(input)) {
    return BarcodeType.ean13;
  } else if (RegExp(r'^\d{8}$').hasMatch(input)) {
    return BarcodeType.ean8;
  } else if (RegExp(r'^[A-Z0-9]{10,20}$').hasMatch(input)) {
    return BarcodeType.code128;
  } else if (RegExp(r'^[0-9]{14}$').hasMatch(input)) {
    return BarcodeType.itf14;
  }

  return BarcodeType.text;
}
