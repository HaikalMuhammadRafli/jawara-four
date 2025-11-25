import '../models/user_profile_model.dart';

final List<UserProfile> userProfileMock = [
  UserProfile(
    uid: '1',
    nama: 'Kania Talitha',
    email: 'kania.talitha@email.com',
    nik: '3201012001010001',
    noTelepon: '081234567890',
    jenisKelamin: JenisKelamin.perempuan,
    role: UserRole.admin,
    createdAt: DateTime(2023, 1, 1),
  ),
  UserProfile(
    uid: '2',
    nama: 'Siti Aminah',
    email: 'siti.aminah@email.com',
    nik: '3201012002020002',
    noTelepon: '081234567891',
    jenisKelamin: JenisKelamin.perempuan,
    role: UserRole.admin,
    createdAt: DateTime(2023, 1, 2),
  ),
  UserProfile(
    uid: '3',
    nama: 'Budi Santoso',
    email: 'budi.santoso@email.com',
    nik: '3201012003030003',
    noTelepon: '081234567892',
    jenisKelamin: JenisKelamin.lakiLaki,
    role: UserRole.warga,
    createdAt: DateTime(2023, 1, 3),
  ),
];
