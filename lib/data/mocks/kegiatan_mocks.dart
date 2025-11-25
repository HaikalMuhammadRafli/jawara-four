import '../models/kegiatan_model.dart';

final List<Kegiatan> kegiatanMock = [
  Kegiatan(
    id: '1',
    nama: 'Kerja Bakti Mingguan',
    kategori: 'Kebersihan',
    penanggungJawab: 'Pak Dedi',
    tanggal: DateTime(2025, 10, 15),
    createdAt: DateTime(2025, 10, 15),
  ),
  Kegiatan(
    id: '2',
    nama: 'Rapat Bulanan Warga',
    kategori: 'Rapat',
    penanggungJawab: 'Bu Rina',
    tanggal: DateTime(2025, 10, 20),
    createdAt: DateTime(2025, 10, 20),
  ),
  Kegiatan(
    id: '3',
    nama: 'Senam Bersama',
    kategori: 'Kesehatan',
    penanggungJawab: 'Pak Agus',
    tanggal: DateTime(2025, 10, 27),
    createdAt: DateTime(2025, 10, 27),
  ),
];
