class LogEntry {
  final String id;
  final String deskripsi;
  final String aktor;
  final DateTime tanggal;
  final DateTime createdAt;
  final DateTime? updatedAt;

  LogEntry({
    required this.id,
    required this.deskripsi,
    required this.aktor,
    required this.tanggal,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deskripsi': deskripsi,
      'aktor': aktor,
      'tanggal': tanggal.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory LogEntry.fromMap(Map<String, dynamic> map) {
    return LogEntry(
      id: map['id']?.toString() ?? '',
      deskripsi: map['deskripsi']?.toString() ?? 'Tidak ada deskripsi',
      aktor: map['aktor']?.toString() ?? 'User',
      tanggal: map['tanggal'] != null
          ? DateTime.tryParse(map['tanggal'].toString()) ?? DateTime.now()
          : DateTime.now(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
    );
  }

  LogEntry copyWith({
    String? id,
    String? deskripsi,
    String? aktor,
    DateTime? tanggal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LogEntry(
      id: id ?? this.id,
      deskripsi: deskripsi ?? this.deskripsi,
      aktor: aktor ?? this.aktor,
      tanggal: tanggal ?? this.tanggal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
