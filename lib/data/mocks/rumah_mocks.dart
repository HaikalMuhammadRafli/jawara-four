import '../models/rumah_model.dart';

final List<Rumah> rumahMock = [
  Rumah(
    id: '1',
    alamat: 'Jl. Merdeka No. 15',
    status: StatusRumah.ditempati,
    pemilik: 'Ahmad Budiman',
    createdAt: DateTime(2023, 1, 1),
  ),
  Rumah(
    id: '2',
    alamat: 'Jl. Sudirman No. 25',
    status: StatusRumah.ditempati,
    pemilik: 'Budi Santoso',
    createdAt: DateTime(2023, 1, 2),
  ),
  Rumah(
    id: '3',
    alamat: 'Jl. Gatot Subroto No. 8',
    status: StatusRumah.ditempati,
    pemilik: 'Suryadi',
    createdAt: DateTime(2023, 1, 3),
  ),
  Rumah(
    id: '4',
    alamat: 'Jl. Veteran No. 5',
    status: StatusRumah.kosong,
    pemilik: '-',
    createdAt: DateTime(2023, 1, 4),
  ),
];
