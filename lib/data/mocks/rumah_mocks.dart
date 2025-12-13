import '../models/rumah_model.dart';

final List<Rumah> rumahMock = [
  Rumah(
    id: '1',
    alamat: 'Jl. Merdeka No. 15',
    rt: '001',
    rw: '005',
    status: StatusRumah.ditempati,
    pemilikId: '1', // Ahmad Budiman
    createdAt: DateTime(2023, 1, 1),
  ),
  Rumah(
    id: '2',
    alamat: 'Jl. Sudirman No. 25',
    rt: '002',
    rw: '005',
    status: StatusRumah.ditempati,
    pemilikId: '4', // Budi Santoso
    createdAt: DateTime(2023, 1, 2),
  ),
  Rumah(
    id: '3',
    alamat: 'Jl. Gatot Subroto No. 8',
    rt: '003',
    rw: '005',
    status: StatusRumah.ditempati,
    pemilikId: '3', // Muhammad Ali
    createdAt: DateTime(2023, 1, 3),
  ),
  Rumah(
    id: '4',
    alamat: 'Jl. Veteran No. 5',
    rt: '001',
    rw: '006',
    status: StatusRumah.kosong,
    pemilikId: '5', // Fatimah Zahra
    createdAt: DateTime(2023, 1, 4),
  ),
];
