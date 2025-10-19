import 'package:flutter/material.dart';

class BroadcastItem {
  final int no;
  final String nama;
  final String pengirim;
  final String judul;
  final String tanggal;
  final IconData icon;
  final Color color;

  const BroadcastItem({
    required this.no,
    required this.nama,
    required this.pengirim,
    required this.judul,
    required this.tanggal,
    required this.icon,
    required this.color,
  });

  factory BroadcastItem.fromMap(Map<String, dynamic> m) {
    return BroadcastItem(
      no: m['no'] as int,
      nama: m['nama'] as String,
      pengirim: m['pengirim'] as String,
      judul: m['judul'] as String,
      tanggal: m['tanggal'] as String,
      icon: m['icon'] as IconData,
      color: m['color'] as Color,
    );
  }
}
