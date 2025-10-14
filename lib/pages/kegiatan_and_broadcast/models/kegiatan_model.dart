import 'package:flutter/material.dart';

class Kegiatan {
  final int no;
  final String nama;
  final String kategori;
  final String penanggungJawab;
  final String tanggal;
  final IconData icon;
  final Color color;

  const Kegiatan({
    required this.no,
    required this.nama,
    required this.kategori,
    required this.penanggungJawab,
    required this.tanggal,
    required this.icon,
    required this.color,
  });

  factory Kegiatan.fromMap(Map<String, dynamic> m) {
    return Kegiatan(
      no: m['no'] as int,
      nama: m['nama'] as String,
      kategori: m['kategori'] as String,
      penanggungJawab: m['penanggungJawab'] as String,
      tanggal: m['tanggal'] as String,
      icon: m['icon'] as IconData,
      color: m['color'] as Color,
    );
  }
}
