class Kegiatan {
  final String id;
  final String nama;
  final String kategori;
  final String penanggungJawab;
  final DateTime tanggal;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Kegiatan({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.penanggungJawab,
    required this.tanggal,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'kategori': kategori,
      'penanggungJawab': penanggungJawab,
      'tanggal': tanggal.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Kegiatan.fromMap(Map<String, dynamic> map) {
    return Kegiatan(
      id: map['id'] as String,
      nama: map['nama'] as String,
      kategori: map['kategori'] as String,
      penanggungJawab: map['penanggungJawab'] as String,
      tanggal: DateTime.parse(map['tanggal'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  Kegiatan copyWith({
    String? id,
    String? nama,
    String? kategori,
    String? penanggungJawab,
    DateTime? tanggal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Kegiatan(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kategori: kategori ?? this.kategori,
      penanggungJawab: penanggungJawab ?? this.penanggungJawab,
      tanggal: tanggal ?? this.tanggal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
