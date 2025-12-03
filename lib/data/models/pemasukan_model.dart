import 'package:intl/intl.dart';

class Pemasukan {
  final String id;
  final String judul;
  final String kategori;
  final int jumlah;
  final DateTime tanggal;
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
      'tanggal': tanggal.toIso8601String(),
      'keterangan': keterangan,
      'nama': nama,
      'jenisPemasukan': jenisPemasukan,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Pemasukan.fromMap(Map<String, dynamic> map) {
    return Pemasukan(
      id: map['id'] as String? ?? '',
      judul: map['judul'] as String? ?? '',
      kategori: map['kategori'] as String? ?? '',
      jumlah: map['jumlah'] is int
          ? map['jumlah'] as int
          : int.tryParse(map['jumlah'].toString()) ?? 0,
      tanggal: _parseDate(map['tanggal']),
      keterangan: map['keterangan'] as String? ?? '',
      nama: map['nama'] as String? ?? '',
      jenisPemasukan: map['jenisPemasukan'] as String? ?? '',
      createdAt: _parseDate(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? _parseDate(map['updatedAt']) : null,
    );
  }

  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    if (date is DateTime) return date;
    if (date is String) {
      try {
        return DateTime.parse(date);
      } catch (e) {
        try {
          return DateFormat('dd/MM/yyyy').parse(date);
        } catch (e) {
          return DateTime.now();
        }
      }
    }
    return DateTime.now();
  }

  Pemasukan copyWith({
    String? id,
    String? judul,
    String? kategori,
    int? jumlah,
    DateTime? tanggal,
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
