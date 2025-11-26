import '../models/pengeluaran_model.dart';

final List<Pengeluaran> pengeluaranMock = [
  Pengeluaran(
    id: '1',
    nama: 'Perbaikan Jalan',
    jenis: 'Infrastruktur',
    nominal: 2000000,
    tanggal: DateTime(2025, 1, 9),
    createdAt: DateTime(2025, 1, 9),
  ),
  Pengeluaran(
    id: '2',
    nama: 'Alat Kebersihan',
    jenis: 'Operasional',
    nominal: 500000,
    tanggal: DateTime(2025, 1, 7),
    createdAt: DateTime(2025, 1, 7),
  ),
  Pengeluaran(
    id: '3',
    nama: 'Listrik Kantor',
    jenis: 'Operasional',
    nominal: 300000,
    tanggal: DateTime(2025, 1, 5),
    createdAt: DateTime(2025, 1, 5),
  ),
  Pengeluaran(
    id: '4',
    nama: 'Air Minum',
    jenis: 'Operasional',
    nominal: 150000,
    tanggal: DateTime(2025, 1, 3),
    createdAt: DateTime(2025, 1, 3),
  ),
];
