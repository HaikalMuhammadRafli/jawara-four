enum JenisMutasi {
  pindahMasuk('Pindah Masuk'),
  pindahKeluar('Pindah Keluar'),
  kelahiran('Kelahiran'),
  kematian('Kematian');

  final String value;
  const JenisMutasi(this.value);

  static JenisMutasi fromString(String value) {
    return JenisMutasi.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => JenisMutasi.pindahMasuk,
    );
  }
}

class MutasiKeluarga {
  final String id;
  final String keluarga;
  final String tanggal;
  final JenisMutasi jenisMutasi;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MutasiKeluarga({
    required this.id,
    required this.keluarga,
    required this.tanggal,
    required this.jenisMutasi,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'keluarga': keluarga,
      'tanggal': tanggal,
      'jenisMutasi': jenisMutasi.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory MutasiKeluarga.fromMap(Map<String, dynamic> map) {
    return MutasiKeluarga(
      id: map['id'] as String,
      keluarga: map['keluarga'] as String,
      tanggal: map['tanggal'] as String,
      jenisMutasi: JenisMutasi.fromString(map['jenisMutasi'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  MutasiKeluarga copyWith({
    String? id,
    String? keluarga,
    String? tanggal,
    JenisMutasi? jenisMutasi,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MutasiKeluarga(
      id: id ?? this.id,
      keluarga: keluarga ?? this.keluarga,
      tanggal: tanggal ?? this.tanggal,
      jenisMutasi: jenisMutasi ?? this.jenisMutasi,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
