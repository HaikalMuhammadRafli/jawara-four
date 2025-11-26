import '../models/pemasukan_model.dart';

final List<Pemasukan> pemasukanMock = [
  Pemasukan(
    id: '1',
    judul: 'Dana Bantuan Pemerintah',
    kategori: 'Bantuan',
    jumlah: 11,
    tanggal: DateTime(2025, 10, 15),
    keterangan: 'Dana bantuan dari pemerintah untuk pembangunan',
    nama: 'aaaaa',
    jenisPemasukan: 'Dana Bantuan Pemerintah',
    createdAt: DateTime(2025, 10, 15),
  ),
  Pemasukan(
    id: '2',
    judul: 'Joki by firman',
    kategori: 'Pendapatan Lainnya',
    jumlah: 49999997,
    tanggal: DateTime(2025, 10, 13),
    keterangan: 'Pendapatan dari joki',
    nama: 'Joki by firman',
    jenisPemasukan: 'Pendapatan Lainnya',
    createdAt: DateTime(2025, 10, 13),
  ),
  Pemasukan(
    id: '3',
    judul: 'tes',
    kategori: 'Pendapatan Lainnya',
    jumlah: 10000,
    tanggal: DateTime(2025, 8, 12),
    keterangan: 'Pendapatan lainnya untuk tes',
    nama: 'tes',
    jenisPemasukan: 'Pendapatan Lainnya',
    createdAt: DateTime(2025, 8, 12),
  ),
];
