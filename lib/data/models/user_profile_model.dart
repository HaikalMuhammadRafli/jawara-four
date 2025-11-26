enum UserRole {
  warga('Warga'),
  admin('Admin');

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => UserRole.warga,
    );
  }
}

enum JenisKelamin {
  lakiLaki('Laki-laki'),
  perempuan('Perempuan');

  final String value;
  const JenisKelamin(this.value);

  static JenisKelamin fromString(String value) {
    return JenisKelamin.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => JenisKelamin.lakiLaki,
    );
  }
}

class UserProfile {
  final String uid;
  final String nama;
  final String email;
  final String nik;
  final String noTelepon;
  final JenisKelamin jenisKelamin;
  final UserRole role;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.uid,
    required this.nama,
    required this.email,
    required this.nik,
    required this.noTelepon,
    required this.jenisKelamin,
    required this.role,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nama': nama,
      'email': email,
      'nik': nik,
      'noTelepon': noTelepon,
      'jenisKelamin': jenisKelamin.value,
      'role': role.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String,
      nama: map['nama'] as String,
      email: map['email'] as String,
      nik: map['nik'] as String,
      noTelepon: map['noTelepon'] as String,
      jenisKelamin: JenisKelamin.fromString(map['jenisKelamin'] as String),
      role: UserRole.fromString(map['role'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  UserProfile copyWith({
    String? uid,
    String? nama,
    String? email,
    String? nik,
    String? noTelepon,
    JenisKelamin? jenisKelamin,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      nik: nik ?? this.nik,
      noTelepon: noTelepon ?? this.noTelepon,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
