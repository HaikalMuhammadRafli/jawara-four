enum StatusAspirasi {
  pending('Pending'),
  diproses('Diproses'),
  selesai('Selesai'),
  ditolak('Ditolak');

  final String value;
  const StatusAspirasi(this.value);

  static StatusAspirasi fromString(String value) {
    return StatusAspirasi.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => StatusAspirasi.pending,
    );
  }
}

class Aspirasi {
  final String id;
  final String pengirim;
  final String judul;
  final String isi;
  final String kategori;
  final String kontak;
  final bool isAnonim;
  final DateTime tanggalDibuat;
  final StatusAspirasi status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Aspirasi({
    required this.id,
    required this.pengirim,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.kontak,
    required this.isAnonim,
    required this.tanggalDibuat,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'pengirim': pengirim,
      'judul': judul,
      'isi': isi,
      'kategori': kategori,
      'kontak': kontak,
      'isAnonim': isAnonim,
      'tanggalDibuat': tanggalDibuat.toIso8601String(),
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Aspirasi.fromMap(Map<String, dynamic> map) {
    return Aspirasi(
      id: map['id'] as String? ?? '',
      pengirim: map['pengirim'] as String? ?? '',
      judul: map['judul'] as String? ?? '',
      isi: map['isi'] as String? ?? '',
      kategori: map['kategori'] as String? ?? 'Aspirasi',
      kontak: map['kontak'] as String? ?? '',
      isAnonim: map['isAnonim'] as bool? ?? false,
      tanggalDibuat: map['tanggalDibuat'] != null
          ? DateTime.parse(map['tanggalDibuat'] as String)
          : DateTime.now(),
      status: StatusAspirasi.fromString(map['status'] as String? ?? 'Pending'),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  Aspirasi copyWith({
    String? id,
    String? pengirim,
    String? judul,
    String? isi,
    String? kategori,
    String? kontak,
    bool? isAnonim,
    DateTime? tanggalDibuat,
    StatusAspirasi? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Aspirasi(
      id: id ?? this.id,
      pengirim: pengirim ?? this.pengirim,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      kategori: kategori ?? this.kategori,
      kontak: kontak ?? this.kontak,
      isAnonim: isAnonim ?? this.isAnonim,
      tanggalDibuat: tanggalDibuat ?? this.tanggalDibuat,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
