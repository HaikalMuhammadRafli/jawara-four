import 'package:intl/intl.dart';

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
      id: map['id'] as String? ?? '',
      nama: map['nama'] as String? ?? '',
      deskripsi: map['deskripsi'] as String? ?? '',
      nominal: map['nominal'] as String? ?? '',
      periode: map['periode'] as String? ?? '',
      status: StatusKategori.fromString(map['status'] as String? ?? ''),
      warna: map['warna'] as String? ?? 'blue',
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
