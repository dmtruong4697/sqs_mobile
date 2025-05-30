class HistoryModel {
  final int? id;
  final String content;
  final String type; // 'barcode' or 'qrcode'
  final DateTime createAt;

  HistoryModel({
    this.id,
    required this.content,
    required this.type,
    required this.createAt,
  });

  factory HistoryModel.fromMap(Map<String, dynamic> map) => HistoryModel(
    id: map['id'],
    content: map['content'],
    type: map['type'],
    createAt: DateTime.parse(map['dateTime']),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'content': content,
    'type': type,
    'dateTime': createAt.toIso8601String(),
  };
}
