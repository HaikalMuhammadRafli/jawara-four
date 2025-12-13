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

enum StatusPerkawinan {
  belumKawin('Belum Kawin'),
  kawin('Kawin'),
  ceraiHidup('Cerai Hidup'),
  ceraiMati('Cerai Mati');

  final String value;
  const StatusPerkawinan(this.value);

  static StatusPerkawinan fromString(String value) {
    return StatusPerkawinan.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => StatusPerkawinan.belumKawin,
    );
  }
}

enum Pendidikan {
  tidakSekolah('Tidak Sekolah'),
  sd('SD'),
  smp('SMP'),
  sma('SMA'),
  d3('D3'),
  s1('S1'),
  s2('S2'),
  s3('S3');

  final String value;
  const Pendidikan(this.value);

  static Pendidikan fromString(String value) {
    return Pendidikan.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => Pendidikan.sd,
    );
  }
}

class Warga {
  final String id;
  final String nama;
  final String nik;
  final JenisKelamin jenisKelamin;
  final String email;
  final String noTelepon;
  final DateTime tanggalLahir;
  final String? tempatLahir;
  final StatusPerkawinan statusPerkawinan;
  final String? pekerjaan;
  final Pendidikan? pendidikan;
  final String? alamat; // Alamat sementara sebelum di-assign ke keluarga/rumah
  final DateTime createdAt;
  final DateTime? updatedAt;

  Warga({
    required this.id,
    required this.nama,
    required this.nik,
    required this.jenisKelamin,
    required this.email,
    required this.noTelepon,
    required this.tanggalLahir,
    this.tempatLahir,
    required this.statusPerkawinan,
    this.pekerjaan,
    this.pendidikan,
    this.alamat,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nik': nik,
      'jenisKelamin': jenisKelamin.value,
      'email': email,
      'noTelepon': noTelepon,
      'tanggalLahir': tanggalLahir.toIso8601String(),
      'tempatLahir': tempatLahir,
      'statusPerkawinan': statusPerkawinan.value,
      'pekerjaan': pekerjaan,
      'pendidikan': pendidikan?.value,
      'alamat': alamat,
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
      email: map['email'] as String? ?? '',
      noTelepon: map['noTelepon'] as String? ?? '',
      tanggalLahir: map['tanggalLahir'] != null
          ? DateTime.parse(map['tanggalLahir'] as String)
          : DateTime.now(),
      tempatLahir: map['tempatLahir'] as String?,
      statusPerkawinan: map['statusPerkawinan'] != null
          ? StatusPerkawinan.fromString(map['statusPerkawinan'] as String)
          : StatusPerkawinan.belumKawin,
      pekerjaan: map['pekerjaan'] as String?,
      pendidikan: map['pendidikan'] != null
          ? Pendidikan.fromString(map['pendidikan'] as String)
          : null,
      alamat: map['alamat'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  Warga copyWith({
    String? id,
    String? nama,
    String? nik,
    JenisKelamin? jenisKelamin,
    String? email,
    String? noTelepon,
    DateTime? tanggalLahir,
    String? tempatLahir,
    StatusPerkawinan? statusPerkawinan,
    String? pekerjaan,
    Pendidikan? pendidikan,
    String? alamat,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Warga(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      email: email ?? this.email,
      noTelepon: noTelepon ?? this.noTelepon,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      statusPerkawinan: statusPerkawinan ?? this.statusPerkawinan,
      pekerjaan: pekerjaan ?? this.pekerjaan,
      pendidikan: pendidikan ?? this.pendidikan,
      alamat: alamat ?? this.alamat,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
