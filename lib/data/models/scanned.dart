class ScannedModel {
  final int? id;
  final String content;
  final String type; // 'barcode' or 'qrcode'
  final DateTime createAt;

  ScannedModel({
    this.id,
    required this.content,
    required this.type,
    required this.createAt,
  });

  factory ScannedModel.fromMap(Map<String, dynamic> map) => ScannedModel(
    id: map['id'],
    content: map['content'],
    type: map['type'],
    createAt: DateTime.parse(map['createAt']),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'content': content,
    'type': type,
    'createAt': createAt.toIso8601String(),
  };
}
