class LogEntry {
  final String id;
  final String deskripsi;
  final String aktor;
  final String tanggal;
  final DateTime createdAt;

  LogEntry({
    required this.id,
    required this.deskripsi,
    required this.aktor,
    required this.tanggal,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deskripsi': deskripsi,
      'aktor': aktor,
      'tanggal': tanggal,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LogEntry.fromMap(Map<String, dynamic> map) {
    return LogEntry(
      id: map['id'] as String,
      deskripsi: map['deskripsi'] as String,
      aktor: map['aktor'] as String,
      tanggal: map['tanggal'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  LogEntry copyWith({
    String? id,
    String? deskripsi,
    String? aktor,
    String? tanggal,
    DateTime? createdAt,
  }) {
    return LogEntry(
      id: id ?? this.id,
      deskripsi: deskripsi ?? this.deskripsi,
      aktor: aktor ?? this.aktor,
      tanggal: tanggal ?? this.tanggal,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
