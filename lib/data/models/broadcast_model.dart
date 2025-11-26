class Broadcast {
  final String id;
  final String nama;
  final String pengirim;
  final String judul;
  final String kategori;
  final DateTime tanggal;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Broadcast({
    required this.id,
    required this.nama,
    required this.pengirim,
    required this.judul,
    required this.kategori,
    required this.tanggal,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'pengirim': pengirim,
      'judul': judul,
      'kategori': kategori,
      'tanggal': tanggal.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Broadcast.fromMap(Map<String, dynamic> map) {
    return Broadcast(
      id: map['id'] as String,
      nama: map['nama'] as String,
      pengirim: map['pengirim'] as String,
      judul: map['judul'] as String,
      kategori: map['kategori'] as String,
      tanggal: DateTime.parse(map['tanggal'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  Broadcast copyWith({
    String? id,
    String? nama,
    String? pengirim,
    String? judul,
    String? kategori,
    DateTime? tanggal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Broadcast(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      pengirim: pengirim ?? this.pengirim,
      judul: judul ?? this.judul,
      kategori: kategori ?? this.kategori,
      tanggal: tanggal ?? this.tanggal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
