bool isValidUrl(String text) {
  final uri = Uri.tryParse(text);
  return uri != null &&
      (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https')) &&
      uri.host.isNotEmpty;
}

bool isValidEmail(String text) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(text);
}
