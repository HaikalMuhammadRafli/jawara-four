import 'package:flutter/material.dart';

import '../models/kegiatan_model.dart';

const List<Kegiatan> kegiatanMock = [
  Kegiatan(
    no: 1,
    nama: 'Kerja Bakti Mingguan',
    kategori: 'Kebersihan',
    penanggungJawab: 'Pak Dedi',
    tanggal: '15 Okt 2025',
    icon: Icons.cleaning_services,
    color: Colors.green,
  ),
  Kegiatan(
    no: 2,
    nama: 'Rapat Bulanan Warga',
    kategori: 'Rapat',
    penanggungJawab: 'Bu Rina',
    tanggal: '20 Okt 2025',
    icon: Icons.groups,
    color: Colors.blue,
  ),
  Kegiatan(
    no: 3,
    nama: 'Senam Bersama',
    kategori: 'Kesehatan',
    penanggungJawab: 'Pak Agus',
    tanggal: '27 Okt 2025',
    icon: Icons.fitness_center,
    color: Colors.orange,
  ),
];
