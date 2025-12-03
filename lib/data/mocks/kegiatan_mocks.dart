import '../models/kegiatan_model.dart';

final List<Kegiatan> kegiatanMock = [
  Kegiatan(
    id: '1',
    nama: 'Kerja Bakti Mingguan',
    deskripsi: 'Kegiatan gotong royong membersihkan lingkungan RT setiap hari Minggu pagi. Warga diharapkan membawa peralatan kebersihan masing-masing.',
    kategori: 'Kebersihan',
    penanggungJawab: 'Pak Dedi',
    lokasi: 'Balai RT 05',
    peserta: 25,
    tanggal: DateTime(2025, 10, 15),
    createdAt: DateTime(2025, 10, 15),
  ),
  Kegiatan(
    id: '2',
    nama: 'Rapat Bulanan Warga',
    deskripsi: 'Rapat koordinasi bulanan untuk membahas program kerja, keuangan, dan keluhan warga.',
    kategori: 'Rapat',
    penanggungJawab: 'Bu Rina',
    lokasi: 'Balai RW 02',
    peserta: 40,
    tanggal: DateTime(2025, 10, 20),
    createdAt: DateTime(2025, 10, 20),
  ),
  Kegiatan(
    id: '3',
    nama: 'Senam Bersama',
    deskripsi: 'Senam sehat bersama untuk meningkatkan kesehatan warga, diadakan setiap Sabtu pagi.',
    kategori: 'Kesehatan',
    penanggungJawab: 'Pak Agus',
    lokasi: 'Lapangan RT',
    peserta: 35,
    tanggal: DateTime(2025, 10, 27),
    createdAt: DateTime(2025, 10, 27),
  ),
];
