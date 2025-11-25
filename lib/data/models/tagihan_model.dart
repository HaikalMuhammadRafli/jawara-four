enum StatusTagihan {
  pending('Pending'),
  lunas('Lunas'),
  terlambat('Terlambat');

  final String value;
  const StatusTagihan(this.value);

  static StatusTagihan fromString(String value) {
    return StatusTagihan.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => StatusTagihan.pending,
    );
  }
}

class Tagihan {
  final String id;
  final String judul;
  final String kategori;
  final String total;
  final StatusTagihan status;
  final String tanggal;
  final String warga;
  final String kodeTagihan;
  final String namaKeluarga;
  final String statusKeluarga;
  final String periode;
  final String alamat;
  final String metodePembayaran;
  final String bukti;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Tagihan({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.total,
    required this.status,
    required this.tanggal,
    required this.warga,
    required this.kodeTagihan,
    required this.namaKeluarga,
    required this.statusKeluarga,
    required this.periode,
    required this.alamat,
    required this.metodePembayaran,
    required this.bukti,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'kategori': kategori,
      'total': total,
      'status': status.value,
      'tanggal': tanggal,
      'warga': warga,
      'kodeTagihan': kodeTagihan,
      'namaKeluarga': namaKeluarga,
      'statusKeluarga': statusKeluarga,
      'periode': periode,
      'alamat': alamat,
      'metodePembayaran': metodePembayaran,
      'bukti': bukti,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Tagihan.fromMap(Map<String, dynamic> map) {
    return Tagihan(
      id: map['id'] as String,
      judul: map['judul'] as String,
      kategori: map['kategori'] as String,
      total: map['total'] as String,
      status: StatusTagihan.fromString(map['status'] as String),
      tanggal: map['tanggal'] as String,
      warga: map['warga'] as String,
      kodeTagihan: map['kodeTagihan'] as String,
      namaKeluarga: map['namaKeluarga'] as String,
      statusKeluarga: map['statusKeluarga'] as String,
      periode: map['periode'] as String,
      alamat: map['alamat'] as String,
      metodePembayaran: map['metodePembayaran'] as String,
      bukti: map['bukti'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  Tagihan copyWith({
    String? id,
    String? judul,
    String? kategori,
    String? total,
    StatusTagihan? status,
    String? tanggal,
    String? warga,
    String? kodeTagihan,
    String? namaKeluarga,
    String? statusKeluarga,
    String? periode,
    String? alamat,
    String? metodePembayaran,
    String? bukti,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tagihan(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      kategori: kategori ?? this.kategori,
      total: total ?? this.total,
      status: status ?? this.status,
      tanggal: tanggal ?? this.tanggal,
      warga: warga ?? this.warga,
      kodeTagihan: kodeTagihan ?? this.kodeTagihan,
      namaKeluarga: namaKeluarga ?? this.namaKeluarga,
      statusKeluarga: statusKeluarga ?? this.statusKeluarga,
      periode: periode ?? this.periode,
      alamat: alamat ?? this.alamat,
      metodePembayaran: metodePembayaran ?? this.metodePembayaran,
      bukti: bukti ?? this.bukti,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
