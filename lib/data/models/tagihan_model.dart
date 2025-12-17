import 'package:intl/intl.dart';

enum StatusTagihan {
  pending('Pending'),
  lunas('Lunas'),
  terlambat('Terlambat'),
  menungguKonfirmasi('Menunggu Konfirmasi');

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
  final int total;
  final StatusTagihan status;
  final DateTime tanggal;
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
      'tanggal': tanggal.toIso8601String(),
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
      id: map['id'] as String? ?? '',
      judul: map['judul'] as String? ?? '',
      kategori: map['kategori'] as String? ?? '',
      total: map['total'] is int
          ? map['total'] as int
          : int.tryParse(map['total'].toString()) ?? 0,
      status: StatusTagihan.fromString(map['status'] as String? ?? ''),
      tanggal: _parseDate(map['tanggal']),
      warga: map['warga'] as String? ?? '',
      kodeTagihan: map['kodeTagihan'] as String? ?? '',
      namaKeluarga: map['namaKeluarga'] as String? ?? '',
      statusKeluarga: map['statusKeluarga'] as String? ?? '',
      periode: map['periode'] as String? ?? '',
      alamat: map['alamat'] as String? ?? '',
      metodePembayaran: map['metodePembayaran'] as String? ?? '',
      bukti: map['bukti'] as String? ?? '',
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

  Tagihan copyWith({
    String? id,
    String? judul,
    String? kategori,
    int? total,
    StatusTagihan? status,
    DateTime? tanggal,
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
