import '../models/log_model.dart';

final List<LogEntry> logMock = [
  LogEntry(
    id: '1',
    deskripsi: 'Mengubah iuran bulanan',
    aktor: 'Admin',
    tanggal: DateTime(2025, 10, 10),
    createdAt: DateTime(2025, 10, 10),
  ),
  LogEntry(
    id: '2',
    deskripsi: 'Menambah data pengeluaran',
    aktor: 'Bendahara',
    tanggal: DateTime(2025, 10, 11),
    createdAt: DateTime(2025, 10, 11),
  ),
  LogEntry(
    id: '3',
    deskripsi: 'Edit profil pengguna',
    aktor: 'Admin',
    tanggal: DateTime(2025, 10, 12),
    createdAt: DateTime(2025, 10, 12),
  ),
  LogEntry(
    id: '4',
    deskripsi: 'Menghapus kegiatan',
    aktor: 'Admin',
    tanggal: DateTime(2025, 10, 13),
    createdAt: DateTime(2025, 10, 13),
  ),
  LogEntry(
    id: '5',
    deskripsi: 'Menambah data user baru',
    aktor: 'Admin',
    tanggal: DateTime(2025, 10, 14),
    createdAt: DateTime(2025, 10, 14),
  ),
];
