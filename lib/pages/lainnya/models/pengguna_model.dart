import 'package:flutter/material.dart';

class Pengguna {
  final int no;
  final String nama;
  final String email;
  final String role;
  final IconData icon;
  final Color color;

  const Pengguna({
    required this.no,
    required this.nama,
    required this.email,
    required this.role,
    required this.icon,
    required this.color,
  });

  factory Pengguna.fromMap(Map<String, dynamic> m) => Pengguna(
    no: m['no'] as int,
    nama: m['nama'] as String,
    email: m['email'] as String,
    role: m['role'] as String,
    icon: m['icon'] as IconData,
    color: m['color'] as Color,
  );
}
