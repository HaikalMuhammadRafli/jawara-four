import '../models/aspirasi_model.dart';

final List<Aspirasi> aspirasiMock = [
  Aspirasi(
    id: '1',
    pengirim: 'Budi Santoso',
    judul: 'Perbaikan Jalan Rusak di RT 05',
    tanggalDibuat: DateTime(2023, 3, 1),
    status: StatusAspirasi.selesai,
    createdAt: DateTime(2023, 3, 1),
  ),
  Aspirasi(
    id: '2',
    pengirim: 'Siti Aminah',
    judul: 'Permohonan Penerangan Jalan di Lingkungan',
    tanggalDibuat: DateTime(2023, 3, 5),
    status: StatusAspirasi.diproses,
    createdAt: DateTime(2023, 3, 5),
  ),
  Aspirasi(
    id: '3',
    pengirim: 'Ahmad Fauzi',
    judul: 'Pengadaan Tempat Sampah di Area Publik',
    tanggalDibuat: DateTime(2023, 3, 10),
    status: StatusAspirasi.selesai,
    createdAt: DateTime(2023, 3, 10),
  ),
  Aspirasi(
    id: '4',
    pengirim: 'Lina Marlina',
    judul: 'Permohonan Pembangunan Taman Bermain Anak',
    tanggalDibuat: DateTime(2023, 3, 12),
    status: StatusAspirasi.diproses,
    createdAt: DateTime(2023, 3, 12),
  ),
  Aspirasi(
    id: '5',
    pengirim: 'Rina Wijaya',
    judul: 'Perbaikan Saluran Air di RT 03',
    tanggalDibuat: DateTime(2023, 3, 15),
    status: StatusAspirasi.selesai,
    createdAt: DateTime(2023, 3, 15),
  ),
];
