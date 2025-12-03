class Broadcast {
  final String id;
  final String nama;
  final String pengirim;
  final String judul;
  final String isi;
  final String kategori;
  final String prioritas;
  final DateTime tanggal;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Broadcast({
    required this.id,
    required this.nama,
    required this.pengirim,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.prioritas,
    required this.tanggal,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'pengirim': pengirim,
      'judul': judul,
      'isi': isi,
      'kategori': kategori,
      'prioritas': prioritas,
      'tanggal': tanggal.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Broadcast.fromMap(Map<String, dynamic> map) {
    return Broadcast(
      id: map['id'] as String? ?? '',
      nama: map['nama'] as String? ?? '',
      pengirim: map['pengirim'] as String? ?? '',
      judul: map['judul'] as String? ?? '',
      isi: map['isi'] as String? ?? '',
      kategori: map['kategori'] as String? ?? '',
      prioritas: map['prioritas'] as String? ?? 'Normal',
      tanggal: map['tanggal'] != null ? DateTime.parse(map['tanggal'] as String) : DateTime.now(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  Broadcast copyWith({
    String? id,
    String? nama,
    String? pengirim,
    String? judul,
    String? isi,
    String? kategori,
    String? prioritas,
    DateTime? tanggal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Broadcast(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      pengirim: pengirim ?? this.pengirim,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      kategori: kategori ?? this.kategori,
      prioritas: prioritas ?? this.prioritas,
      tanggal: tanggal ?? this.tanggal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
