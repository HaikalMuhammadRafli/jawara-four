import '../models/broadcast_model.dart';

final List<Broadcast> broadcastMock = [
  Broadcast(
    id: '1',
    nama: 'Pengumuman Kebersihan',
    pengirim: 'Admin RW 05',
    judul: 'Kerja Bakti Minggu Depan',
    kategori: 'Kebersihan',
    tanggal: DateTime(2025, 10, 11),
    createdAt: DateTime(2025, 10, 11),
  ),
  Broadcast(
    id: '2',
    nama: 'Peringatan Hari Santri',
    pengirim: 'Pak RT 02',
    judul: 'Akan diadakan doa bersama',
    kategori: 'Keagamaan',
    tanggal: DateTime(2025, 10, 14),
    createdAt: DateTime(2025, 10, 14),
  ),
  Broadcast(
    id: '3',
    nama: 'Tagihan Iuran',
    pengirim: 'Admin Keuangan',
    judul: 'Pembayaran Iuran Bulan Oktober',
    kategori: 'Keuangan',
    tanggal: DateTime(2025, 10, 15),
    createdAt: DateTime(2025, 10, 15),
  ),
];
