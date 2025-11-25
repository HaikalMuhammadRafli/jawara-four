enum JenisKelamin {
  lakiLaki('Laki-laki'),
  perempuan('Perempuan');

  final String value;
  const JenisKelamin(this.value);

  static JenisKelamin fromString(String value) {
    return JenisKelamin.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => JenisKelamin.lakiLaki,
    );
  }
}

class Warga {
  final String id;
  final String nama;
  final String nik;
  final JenisKelamin jenisKelamin;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Warga({
    required this.id,
    required this.nama,
    required this.nik,
    required this.jenisKelamin,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nik': nik,
      'jenisKelamin': jenisKelamin.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Warga.fromMap(Map<String, dynamic> map) {
    return Warga(
      id: map['id'] as String,
      nama: map['nama'] as String,
      nik: map['nik'] as String,
      jenisKelamin: JenisKelamin.fromString(map['jenisKelamin'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  Warga copyWith({
    String? id,
    String? nama,
    String? nik,
    JenisKelamin? jenisKelamin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Warga(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
