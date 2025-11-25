enum StatusAspirasi {
  pending('Pending'),
  diproses('Diproses'),
  selesai('Selesai'),
  ditolak('Ditolak');

  final String value;
  const StatusAspirasi(this.value);

  static StatusAspirasi fromString(String value) {
    return StatusAspirasi.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => StatusAspirasi.pending,
    );
  }
}

class Aspirasi {
  final String id;
  final String pengirim;
  final String judul;
  final String tanggalDibuat;
  final StatusAspirasi status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Aspirasi({
    required this.id,
    required this.pengirim,
    required this.judul,
    required this.tanggalDibuat,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pengirim': pengirim,
      'judul': judul,
      'tanggalDibuat': tanggalDibuat,
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Aspirasi.fromMap(Map<String, dynamic> map) {
    return Aspirasi(
      id: map['id'] as String,
      pengirim: map['pengirim'] as String,
      judul: map['judul'] as String,
      tanggalDibuat: map['tanggalDibuat'] as String,
      status: StatusAspirasi.fromString(map['status'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  Aspirasi copyWith({
    String? id,
    String? pengirim,
    String? judul,
    String? tanggalDibuat,
    StatusAspirasi? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Aspirasi(
      id: id ?? this.id,
      pengirim: pengirim ?? this.pengirim,
      judul: judul ?? this.judul,
      tanggalDibuat: tanggalDibuat ?? this.tanggalDibuat,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
