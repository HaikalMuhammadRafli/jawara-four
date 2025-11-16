class UserProfile {
  final String uid;
  final String nama;
  final String email;
  final String nik;
  final String noTelepon;
  final String jenisKelamin;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? role;

  UserProfile({
    required this.uid,
    required this.nama,
    required this.email,
    required this.nik,
    required this.noTelepon,
    required this.jenisKelamin,
    required this.createdAt,
    this.updatedAt,
    this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nama': nama,
      'email': email,
      'nik': nik,
      'noTelepon': noTelepon,
      'jenisKelamin': jenisKelamin,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'role': role ?? 'Warga',
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String,
      nama: map['nama'] as String,
      email: map['email'] as String,
      nik: map['nik'] as String,
      noTelepon: map['noTelepon'] as String,
      jenisKelamin: map['jenisKelamin'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      role: map['role'] as String?,
    );
  }

  UserProfile copyWith({
    String? uid,
    String? nama,
    String? email,
    String? nik,
    String? noTelepon,
    String? jenisKelamin,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? role,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      nik: nik ?? this.nik,
      noTelepon: noTelepon ?? this.noTelepon,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      role: role ?? this.role,
    );
  }
}

