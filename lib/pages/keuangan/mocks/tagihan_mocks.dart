import '../models/tagihan_model.dart';

const List<Tagihan> tagihanMock = [
  Tagihan(
    judul: 'Iuran Bulanan Januari 2025',
    kategori: 'Iuran Bulanan',
    total: 'Rp 1.500.000',
    status: 'Belum Lunas',
    tanggal: '15 Jan 2025',
    warga: '150',
  ),
  Tagihan(
    judul: 'Iuran Keamanan',
    kategori: 'Iuran Keamanan',
    total: 'Rp 750.000',
    status: 'Lunas',
    tanggal: '10 Jan 2025',
    warga: '75',
  ),
  Tagihan(
    judul: 'Iuran Kebersihan',
    kategori: 'Iuran Kebersihan',
    total: 'Rp 500.000',
    status: 'Belum Lunas',
    tanggal: '5 Jan 2025',
    warga: '100',
  ),
  Tagihan(
    judul: 'Iuran Pemeliharaan',
    kategori: 'Iuran Pemeliharaan',
    total: 'Rp 2.000.000',
    status: 'Lunas',
    tanggal: '1 Jan 2025',
    warga: '200',
  ),
];
