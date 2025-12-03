class Kegiatan {
  final String id;
  final String nama;
  final String deskripsi;
  final String kategori;
  final String penanggungJawab;
  final String lokasi;
  final int peserta;
  final DateTime tanggal;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Kegiatan({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.kategori,
    required this.penanggungJawab,
    required this.lokasi,
    required this.peserta,
    required this.tanggal,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'penanggungJawab': penanggungJawab,
      'lokasi': lokasi,
      'peserta': peserta,
      'tanggal': tanggal.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Kegiatan.fromMap(Map<String, dynamic> map) {
    return Kegiatan(
      id: map['id'] as String? ?? '',
      nama: map['nama'] as String? ?? '',
      deskripsi: map['deskripsi'] as String? ?? '',
      kategori: map['kategori'] as String? ?? '',
      penanggungJawab: map['penanggungJawab'] as String? ?? '',
      lokasi: map['lokasi'] as String? ?? '',
      peserta: map['peserta'] as int? ?? 0,
      tanggal: map['tanggal'] != null ? DateTime.parse(map['tanggal'] as String) : DateTime.now(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  Kegiatan copyWith({
    String? id,
    String? nama,
    String? deskripsi,
    String? kategori,
    String? penanggungJawab,
    String? lokasi,
    int? peserta,
    DateTime? tanggal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Kegiatan(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      deskripsi: deskripsi ?? this.deskripsi,
      kategori: kategori ?? this.kategori,
      penanggungJawab: penanggungJawab ?? this.penanggungJawab,
      lokasi: lokasi ?? this.lokasi,
      peserta: peserta ?? this.peserta,
      tanggal: tanggal ?? this.tanggal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
