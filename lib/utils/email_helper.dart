// tach chi tiet email
Map<String, String>? parseMatmsg(String input) {
  if (!input.startsWith('MATMSG:')) return null;

  final to = RegExp(r'TO:([^;]+);').firstMatch(input)?.group(1);
  final sub = RegExp(r'SUB:([^;]+);').firstMatch(input)?.group(1);
  final body = RegExp(r'BODY:([^;]+);').firstMatch(input)?.group(1);

  if (to == null || sub == null || body == null) return null;

  return {'address': to, 'subject': sub, 'message': body};
}
