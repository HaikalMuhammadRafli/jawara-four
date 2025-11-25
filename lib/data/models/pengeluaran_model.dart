class Pengeluaran {
  final String id;
  final String nama;
  final String jenis;
  final String nominal;
  final String tanggal;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Pengeluaran({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.nominal,
    required this.tanggal,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'jenis': jenis,
      'nominal': nominal,
      'tanggal': tanggal,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Pengeluaran.fromMap(Map<String, dynamic> map) {
    return Pengeluaran(
      id: map['id'] as String,
      nama: map['nama'] as String,
      jenis: map['jenis'] as String,
      nominal: map['nominal'] as String,
      tanggal: map['tanggal'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  Pengeluaran copyWith({
    String? id,
    String? nama,
    String? jenis,
    String? nominal,
    String? tanggal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Pengeluaran(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      jenis: jenis ?? this.jenis,
      nominal: nominal ?? this.nominal,
      tanggal: tanggal ?? this.tanggal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
