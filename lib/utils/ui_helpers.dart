import 'package:flutter/material.dart';

import '../data/models/mutasi_keluarga_model.dart';
import '../data/models/user_profile_model.dart';

class UIHelpers {
  // Icon dan color untuk Kegiatan berdasarkan kategori
  static IconData getKegiatanIcon(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'kebersihan':
        return Icons.cleaning_services;
      case 'rapat':
        return Icons.groups;
      case 'kesehatan':
        return Icons.fitness_center;
      case 'sosial':
        return Icons.volunteer_activism;
      case 'keagamaan':
        return Icons.mosque;
      default:
        return Icons.event;
    }
  }

  static Color getKegiatanColor(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'kebersihan':
        return Colors.green;
      case 'rapat':
        return Colors.blue;
      case 'kesehatan':
        return Colors.orange;
      case 'sosial':
        return Colors.purple;
      case 'keagamaan':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  // Icon dan color untuk Broadcast berdasarkan kategori
  static IconData getBroadcastIcon(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'kebersihan':
        return Icons.cleaning_services;
      case 'keagamaan':
        return Icons.mosque;
      case 'keuangan':
        return Icons.payment;
      case 'rapat':
        return Icons.groups;
      case 'sosial':
        return Icons.volunteer_activism;
      case 'pengumuman':
        return Icons.campaign;
      default:
        return Icons.notifications;
    }
  }

  static Color getBroadcastColor(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'kebersihan':
        return Colors.green;
      case 'keagamaan':
        return Colors.purple;
      case 'keuangan':
        return Colors.orange;
      case 'rapat':
        return Colors.blue;
      case 'sosial':
        return Colors.pink;
      case 'pengumuman':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  // Icon untuk MutasiKeluarga berdasarkan jenis
  static IconData getMutasiIcon(JenisMutasi jenis) {
    switch (jenis) {
      case JenisMutasi.pindahMasuk:
        return Icons.home;
      case JenisMutasi.pindahKeluar:
        return Icons.house;
      case JenisMutasi.kelahiran:
        return Icons.child_care;
      case JenisMutasi.kematian:
        return Icons.person_off;
    }
  }

  static Color getMutasiColor(JenisMutasi jenis) {
    switch (jenis) {
      case JenisMutasi.pindahMasuk:
        return Colors.green;
      case JenisMutasi.pindahKeluar:
        return Colors.orange;
      case JenisMutasi.kelahiran:
        return Colors.blue;
      case JenisMutasi.kematian:
        return Colors.red;
    }
  }

  // Icon dan color untuk UserProfile berdasarkan role
  static IconData getUserIcon(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.warga:
        return Icons.person;
    }
  }

  static Color getUserColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.blue;
      case UserRole.warga:
        return Colors.green;
    }
  }
}
