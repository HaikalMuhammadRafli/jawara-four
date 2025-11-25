class Pemasukan {
  final String id;
  final String judul;
  final String kategori;
  final String jumlah;
  final String tanggal;
  final String keterangan;
  final String nama;
  final String jenisPemasukan;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Pemasukan({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.jumlah,
    required this.tanggal,
    required this.keterangan,
    required this.nama,
    required this.jenisPemasukan,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'kategori': kategori,
      'jumlah': jumlah,
      'tanggal': tanggal,
      'keterangan': keterangan,
      'nama': nama,
      'jenisPemasukan': jenisPemasukan,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Pemasukan.fromMap(Map<String, dynamic> map) {
    return Pemasukan(
      id: map['id'] as String,
      judul: map['judul'] as String,
      kategori: map['kategori'] as String,
      jumlah: map['jumlah'] as String,
      tanggal: map['tanggal'] as String,
      keterangan: map['keterangan'] as String,
      nama: map['nama'] as String,
      jenisPemasukan: map['jenisPemasukan'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  Pemasukan copyWith({
    String? id,
    String? judul,
    String? kategori,
    String? jumlah,
    String? tanggal,
    String? keterangan,
    String? nama,
    String? jenisPemasukan,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Pemasukan(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      kategori: kategori ?? this.kategori,
      jumlah: jumlah ?? this.jumlah,
      tanggal: tanggal ?? this.tanggal,
      keterangan: keterangan ?? this.keterangan,
      nama: nama ?? this.nama,
      jenisPemasukan: jenisPemasukan ?? this.jenisPemasukan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
