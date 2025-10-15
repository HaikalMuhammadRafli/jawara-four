import 'package:flutter/material.dart';

class MutasiKeluarga {
  final IconData icon;
  final String keluarga;
  final String tanggal;
  final String jenisMutasi;

  const MutasiKeluarga({
    required this.icon,
    required this.keluarga,
    required this.tanggal,
    required this.jenisMutasi,
  });

  factory MutasiKeluarga.fromMap(Map<String, dynamic> m) {
    return MutasiKeluarga(
      icon: m['icon'] as IconData,
      keluarga: m['keluarga'] as String,
      tanggal: m['tanggal'] as String,
      jenisMutasi: m['jenisMutasi'] as String,
    );
  }
}
