import '../models/aspirasi_model.dart';

final List<Aspirasi> aspirasiMock = [
  Aspirasi(
    id: '1',
    pengirim: 'Budi Santoso',
    judul: 'Perbaikan Jalan Rusak di RT 05',
    isi:
        'Jalan di RT 05 sudah sangat rusak dan berlubang. Mohon untuk segera diperbaiki karena membahayakan pengguna jalan, terutama kendaraan roda dua.',
    kategori: 'Aspirasi',
    kontak: '081234567890',
    isAnonim: false,
    tanggalDibuat: DateTime(2023, 3, 1),
    status: StatusAspirasi.selesai,
    createdAt: DateTime(2023, 3, 1),
  ),
  Aspirasi(
    id: '2',
    pengirim: 'Siti Aminah',
    judul: 'Permohonan Penerangan Jalan di Lingkungan',
    isi:
        'Mohon dipasang lampu penerangan jalan di area gang karena sangat gelap pada malam hari dan rawan tindak kejahatan.',
    kategori: 'Pengaduan',
    kontak: 'siti.aminah@email.com',
    isAnonim: false,
    tanggalDibuat: DateTime(2023, 3, 5),
    status: StatusAspirasi.diproses,
    createdAt: DateTime(2023, 3, 5),
  ),
  Aspirasi(
    id: '3',
    pengirim: 'Ahmad Fauzi',
    judul: 'Pengadaan Tempat Sampah di Area Publik',
    isi:
        'Usulan untuk menambah tempat sampah di area publik agar lingkungan lebih bersih dan warga tidak membuang sampah sembarangan.',
    kategori: 'Saran',
    kontak: '082345678901',
    isAnonim: false,
    tanggalDibuat: DateTime(2023, 3, 10),
    status: StatusAspirasi.selesai,
    createdAt: DateTime(2023, 3, 10),
  ),
  Aspirasi(
    id: '4',
    pengirim: 'Lina Marlina',
    judul: 'Permohonan Pembangunan Taman Bermain Anak',
    isi:
        'Mengusulkan pembangunan taman bermain untuk anak-anak di area kosong dekat pos RT agar anak-anak memiliki tempat bermain yang aman.',
    kategori: 'Aspirasi',
    kontak: 'lina.m@email.com',
    isAnonim: false,
    tanggalDibuat: DateTime(2023, 3, 12),
    status: StatusAspirasi.diproses,
    createdAt: DateTime(2023, 3, 12),
  ),
  Aspirasi(
    id: '5',
    pengirim: 'Anonim',
    judul: 'Perbaikan Saluran Air di RT 03',
    isi:
        'Saluran air di RT 03 tersumbat dan menyebabkan banjir saat hujan. Mohon segera dibersihkan.',
    kategori: 'Keluhan',
    kontak: '-',
    isAnonim: true,
    tanggalDibuat: DateTime(2023, 3, 15),
    status: StatusAspirasi.pending,
    createdAt: DateTime(2023, 3, 15),
  ),
];
