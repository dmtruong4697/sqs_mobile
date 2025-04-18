bool isValidUrl(String text) {
  final uri = Uri.tryParse(text);
  return uri != null &&
      (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https')) &&
      uri.host.isNotEmpty;
}
