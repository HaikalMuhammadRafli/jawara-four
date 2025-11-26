enum StatusRegistrasi {
  pending('Pending'),
  disetujui('Disetujui'),
  ditolak('Ditolak');

  final String value;
  const StatusRegistrasi(this.value);

  static StatusRegistrasi fromString(String value) {
    return StatusRegistrasi.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => StatusRegistrasi.pending,
    );
  }
}

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

class PenerimaanWarga {
  final String id;
  final String fotoIdentitas;
  final String nama;
  final String nik;
  final String email;
  final JenisKelamin jenisKelamin;
  final StatusRegistrasi statusRegistrasi;
  final DateTime createdAt;
  final DateTime? updatedAt;

  PenerimaanWarga({
    required this.id,
    required this.fotoIdentitas,
    required this.nama,
    required this.nik,
    required this.email,
    required this.jenisKelamin,
    required this.statusRegistrasi,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fotoIdentitas': fotoIdentitas,
      'nama': nama,
      'nik': nik,
      'email': email,
      'jenisKelamin': jenisKelamin.value,
      'statusRegistrasi': statusRegistrasi.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory PenerimaanWarga.fromMap(Map<String, dynamic> map) {
    return PenerimaanWarga(
      id: map['id'] as String,
      fotoIdentitas: map['fotoIdentitas'] as String,
      nama: map['nama'] as String,
      nik: map['nik'] as String,
      email: map['email'] as String,
      jenisKelamin: JenisKelamin.fromString(map['jenisKelamin'] as String),
      statusRegistrasi: StatusRegistrasi.fromString(map['statusRegistrasi'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  PenerimaanWarga copyWith({
    String? id,
    String? fotoIdentitas,
    String? nama,
    String? nik,
    String? email,
    JenisKelamin? jenisKelamin,
    StatusRegistrasi? statusRegistrasi,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PenerimaanWarga(
      id: id ?? this.id,
      fotoIdentitas: fotoIdentitas ?? this.fotoIdentitas,
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      email: email ?? this.email,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      statusRegistrasi: statusRegistrasi ?? this.statusRegistrasi,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
