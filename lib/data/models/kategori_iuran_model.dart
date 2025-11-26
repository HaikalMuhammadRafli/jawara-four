enum StatusKategori {
  aktif('Aktif'),
  nonaktif('Nonaktif');

  final String value;
  const StatusKategori(this.value);

  static StatusKategori fromString(String value) {
    return StatusKategori.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => StatusKategori.aktif,
    );
  }
}

class KategoriIuran {
  final String id;
  final String nama;
  final String deskripsi;
  final String nominal;
  final String periode;
  final StatusKategori status;
  final String warna;
  final DateTime createdAt;
  final DateTime? updatedAt;

  KategoriIuran({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.nominal,
    required this.periode,
    required this.status,
    required this.warna,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'nominal': nominal,
      'periode': periode,
      'status': status.value,
      'warna': warna,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory KategoriIuran.fromMap(Map<String, dynamic> map) {
    return KategoriIuran(
      id: map['id'] as String,
      nama: map['nama'] as String,
      deskripsi: map['deskripsi'] as String,
      nominal: map['nominal'] as String,
      periode: map['periode'] as String,
      status: StatusKategori.fromString(map['status'] as String),
      warna: map['warna'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  KategoriIuran copyWith({
    String? id,
    String? nama,
    String? deskripsi,
    String? nominal,
    String? periode,
    StatusKategori? status,
    String? warna,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return KategoriIuran(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      deskripsi: deskripsi ?? this.deskripsi,
      nominal: nominal ?? this.nominal,
      periode: periode ?? this.periode,
      status: status ?? this.status,
      warna: warna ?? this.warna,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
