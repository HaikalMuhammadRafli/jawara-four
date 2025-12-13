class Keluarga {
  final String id;
  final String nomorKK; // Nomor Kartu Keluarga (16 digit)
  final String kepalaKeluargaId; // Referensi ke ID warga
  final List<String> anggotaIds; // List referensi ke ID warga
  final String rumahId; // Referensi ke ID rumah
  final DateTime createdAt;
  final DateTime? updatedAt;

  Keluarga({
    required this.id,
    required this.nomorKK,
    required this.kepalaKeluargaId,
    required this.anggotaIds,
    required this.rumahId,
    required this.createdAt,
    this.updatedAt,
  });

  // Hitung jumlah anggota secara otomatis
  int get jumlahAnggota => anggotaIds.length;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomorKK': nomorKK,
      'kepalaKeluargaId': kepalaKeluargaId,
      'anggotaIds': anggotaIds,
      'rumahId': rumahId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Keluarga.fromMap(Map<String, dynamic> map) {
    return Keluarga(
      id: map['id'] as String,
      nomorKK: map['nomorKK'] as String? ?? '',
      kepalaKeluargaId: map['kepalaKeluargaId'] as String? ?? '',
      anggotaIds: map['anggotaIds'] != null
          ? List<String>.from(map['anggotaIds'] as List)
          : [],
      rumahId: map['rumahId'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  Keluarga copyWith({
    String? id,
    String? nomorKK,
    String? kepalaKeluargaId,
    List<String>? anggotaIds,
    String? rumahId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Keluarga(
      id: id ?? this.id,
      nomorKK: nomorKK ?? this.nomorKK,
      kepalaKeluargaId: kepalaKeluargaId ?? this.kepalaKeluargaId,
      anggotaIds: anggotaIds ?? this.anggotaIds,
      rumahId: rumahId ?? this.rumahId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
