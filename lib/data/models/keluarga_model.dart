class Keluarga {
  final String id;
  final String kepalaKeluarga;
  final String alamat;
  final String jumlahAnggota;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Keluarga({
    required this.id,
    required this.kepalaKeluarga,
    required this.alamat,
    required this.jumlahAnggota,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kepalaKeluarga': kepalaKeluarga,
      'alamat': alamat,
      'jumlahAnggota': jumlahAnggota,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Keluarga.fromMap(Map<String, dynamic> map) {
    return Keluarga(
      id: map['id'] as String,
      kepalaKeluarga: map['kepalaKeluarga'] as String,
      alamat: map['alamat'] as String,
      jumlahAnggota: map['jumlahAnggota'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  Keluarga copyWith({
    String? id,
    String? kepalaKeluarga,
    String? alamat,
    String? jumlahAnggota,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Keluarga(
      id: id ?? this.id,
      kepalaKeluarga: kepalaKeluarga ?? this.kepalaKeluarga,
      alamat: alamat ?? this.alamat,
      jumlahAnggota: jumlahAnggota ?? this.jumlahAnggota,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
