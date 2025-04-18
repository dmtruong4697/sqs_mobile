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
  } else if (Uri.tryParse(input)?.hasAbsolutePath == true) {
    return QRType.url;
  }

  return QRType.text;
}
