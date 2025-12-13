enum JenisMutasi {
  pindahMasuk('Pindah Masuk'),
  pindahKeluar('Pindah Keluar'),
  pindahAntarRTRW('Pindah Antar RT/RW'),
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
  final String keluargaId; // Referensi ke ID keluarga
  final String nomorKK; // Denormalized untuk performa
  final String namaKepalaKeluarga; // Denormalized untuk performa
  final String namaWarga; // Nama warga yang pindah
  final DateTime tanggal;
  final JenisMutasi jenisMutasi;
  final String alamatAsal;
  final String alamatTujuan;
  final String alasan;
  final String? keterangan;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MutasiKeluarga({
    required this.id,
    required this.keluargaId,
    required this.nomorKK,
    required this.namaKepalaKeluarga,
    required this.namaWarga,
    required this.tanggal,
    required this.jenisMutasi,
    required this.alamatAsal,
    required this.alamatTujuan,
    required this.alasan,
    this.keterangan,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'keluargaId': keluargaId,
      'nomorKK': nomorKK,
      'namaKepalaKeluarga': namaKepalaKeluarga,
      'namaWarga': namaWarga,
      'tanggal': tanggal.toIso8601String(),
      'jenisMutasi': jenisMutasi.value,
      'alamatAsal': alamatAsal,
      'alamatTujuan': alamatTujuan,
      'alasan': alasan,
      'keterangan': keterangan,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory MutasiKeluarga.fromMap(Map<String, dynamic> map) {
    return MutasiKeluarga(
      id: map['id'] as String? ?? '',
      keluargaId:
          map['keluargaId'] as String? ?? map['keluarga'] as String? ?? '',
      nomorKK: map['nomorKK'] as String? ?? '',
      namaKepalaKeluarga: map['namaKepalaKeluarga'] as String? ?? '',
      namaWarga: map['namaWarga'] as String? ?? '',
      tanggal: map['tanggal'] != null
          ? DateTime.parse(map['tanggal'] as String)
          : DateTime.now(),
      jenisMutasi: map['jenisMutasi'] != null
          ? JenisMutasi.fromString(map['jenisMutasi'] as String)
          : JenisMutasi.pindahMasuk,
      alamatAsal: map['alamatAsal'] as String? ?? '',
      alamatTujuan: map['alamatTujuan'] as String? ?? '',
      alasan: map['alasan'] as String? ?? '',
      keterangan: map['keterangan'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  MutasiKeluarga copyWith({
    String? id,
    String? keluargaId,
    String? nomorKK,
    String? namaKepalaKeluarga,
    String? namaWarga,
    DateTime? tanggal,
    JenisMutasi? jenisMutasi,
    String? alamatAsal,
    String? alamatTujuan,
    String? alasan,
    String? keterangan,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MutasiKeluarga(
      id: id ?? this.id,
      keluargaId: keluargaId ?? this.keluargaId,
      nomorKK: nomorKK ?? this.nomorKK,
      namaKepalaKeluarga: namaKepalaKeluarga ?? this.namaKepalaKeluarga,
      namaWarga: namaWarga ?? this.namaWarga,
      tanggal: tanggal ?? this.tanggal,
      jenisMutasi: jenisMutasi ?? this.jenisMutasi,
      alamatAsal: alamatAsal ?? this.alamatAsal,
      alamatTujuan: alamatTujuan ?? this.alamatTujuan,
      alasan: alasan ?? this.alasan,
      keterangan: keterangan ?? this.keterangan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
