import '../models/penerimaan_warga_model.dart';

final List<PenerimaanWarga> penerimaanWargaMock = [
  PenerimaanWarga(
    id: '1',
    fotoIdentitas:
        'https://registrasi.ut.ac.id/assets/images/landingpage/BerkasValidasi/ktp/ktppria.png',
    nama: 'Ahmad Fauzi',
    nik: '3201012001010001',
    email: 'ahmad.fauzi@example.com',
    jenisKelamin: JenisKelamin.lakiLaki,
    statusRegistrasi: StatusRegistrasi.disetujui,
    createdAt: DateTime(2023, 2, 1),
  ),
  PenerimaanWarga(
    id: '2',
    fotoIdentitas:
        'https://registrasi.ut.ac.id/assets/images/landingpage/BerkasValidasi/ktp/ktppria.png',
    nama: 'Siti Aminah',
    nik: '3201012002020002',
    email: 'siti.aminah@example.com',
    jenisKelamin: JenisKelamin.perempuan,
    statusRegistrasi: StatusRegistrasi.pending,
    createdAt: DateTime(2023, 2, 2),
  ),
];
