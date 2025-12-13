import '../models/keluarga_model.dart';

final List<Keluarga> keluargaMock = [
  Keluarga(
    id: '1',
    nomorKK: '3201010101010001',
    kepalaKeluargaId: '1', // Ahmad Budiman
    anggotaIds: ['1', '2'], // Ahmad and Siti
    rumahId: '1',
    createdAt: DateTime(2023, 1, 1),
  ),
  Keluarga(
    id: '2',
    nomorKK: '3201010101010002',
    kepalaKeluargaId: '4', // Budi Santoso
    anggotaIds: ['4'],
    rumahId: '2',
    createdAt: DateTime(2023, 1, 2),
  ),
  Keluarga(
    id: '3',
    nomorKK: '3201010101010003',
    kepalaKeluargaId: '3', // Muhammad Ali
    anggotaIds: ['3'],
    rumahId: '3',
    createdAt: DateTime(2023, 1, 3),
  ),
  Keluarga(
    id: '4',
    nomorKK: '3201010101010004',
    kepalaKeluargaId: '5', // Fatimah Zahra
    anggotaIds: ['5'],
    rumahId: '4',
    createdAt: DateTime(2023, 1, 4),
  ),
];
