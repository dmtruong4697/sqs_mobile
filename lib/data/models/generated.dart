class GeneratedModel {
  final int? id;
  final String content;
  final String type; // 'barcode' or 'qrcode'
  final String? qrType; //text, phone, url, ...
  final String? barcodeType; //
  final DateTime createAt;

  GeneratedModel({
    this.id,
    required this.content,
    required this.type,
    required this.createAt,
    this.qrType,
    this.barcodeType,
  });

  factory GeneratedModel.fromMap(Map<String, dynamic> map) => GeneratedModel(
    id: map['id'],
    content: map['content'],
    type: map['type'],
    createAt: DateTime.parse(map['createAt']),
    qrType: map['qrType'],
    barcodeType: map['barcodeType'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'content': content,
    'type': type,
    'createAt': createAt.toIso8601String(),
    'qrType': qrType,
    'barcodeType': barcodeType,
  };
}
