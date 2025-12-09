import 'package:firebase_auth/firebase_auth.dart';

import '../data/models/user_profile_model.dart';
import '../data/repositories/user_repository.dart';

/// Service untuk mengelola role-based access control
class RoleService {
  final UserRepository _userRepository = UserRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Mendapatkan role user yang sedang login
  Future<UserRole?> getCurrentUserRole() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final userProfile = await _userRepository.getUserProfile(user.uid);
      return userProfile?.role;
    } catch (e) {
      return null;
    }
  }

  /// Stream role user yang sedang login
  Stream<UserRole?> getCurrentUserRoleStream() async* {
    final user = _auth.currentUser;
    if (user == null) {
      yield null;
      return;
    }

    await for (final userProfile in _userRepository.getUserProfileStream(user.uid)) {
      yield userProfile?.role;
    }
  }

  /// Cek apakah user adalah admin
  Future<bool> isAdmin() async {
    final role = await getCurrentUserRole();
    return role == UserRole.admin;
  }

  /// Cek apakah user adalah warga
  Future<bool> isWarga() async {
    final role = await getCurrentUserRole();
    return role == UserRole.warga;
  }

  /// Cek apakah user memiliki permission untuk akses fitur tertentu
  Future<bool> hasPermission(Permission permission) async {
    final role = await getCurrentUserRole();
    if (role == null) return false;

    return _checkPermission(role, permission);
  }

  /// Implementasi permission check berdasarkan role
  bool _checkPermission(UserRole role, Permission permission) {
    switch (role) {
      case UserRole.admin:
        // Admin bisa akses semua
        return true;

      case UserRole.warga:
        // Warga hanya bisa akses fitur yang diizinkan
        return _wargaPermissions.contains(permission);
    }
  }

  /// Daftar permission yang diizinkan untuk warga
  static const _wargaPermissions = {
    // Dashboard - Read only
    Permission.dashboardView,

    // Kegiatan - Read dan create aspirasi/laporan
    Permission.kegiatanView,
    Permission.broadcastView,

    // Kependudukan - Read dan update data pribadi
    Permission.kependudukanView,
    Permission.wargaView,
    Permission.penerimaanWargaCreate, // Bisa daftar sebagai warga baru
    Permission.aspirasiView,
    Permission.aspirasiCreate,
    Permission.aspirasiEdit, // Hanya milik sendiri
    // Keuangan - Read tagihan dan bayar
    Permission.keuanganView,
    Permission.iuranTagihanView,
    Permission.laporanKeuanganView,
  };
}

/// Enum untuk mendefinisikan permission dalam aplikasi
enum Permission {
  // Dashboard
  dashboardView,

  // Kegiatan
  kegiatanView,
  kegiatanCreate,
  kegiatanEdit,
  kegiatanDelete,
  broadcastView,
  broadcastCreate,
  broadcastEdit,
  broadcastDelete,

  // Kependudukan
  kependudukanView,
  wargaView,
  wargaCreate,
  wargaEdit,
  wargaDelete,
  keluargaView,
  keluargaCreate,
  keluargaEdit,
  keluargaDelete,
  rumahView,
  rumahCreate,
  rumahEdit,
  rumahDelete,
  mutasiKeluargaView,
  mutasiKeluargaCreate,
  mutasiKeluargaEdit,
  mutasiKeluargaDelete,
  penerimaanWargaView,
  penerimaanWargaCreate,
  penerimaanWargaEdit,
  penerimaanWargaDelete,
  aspirasiView,
  aspirasiCreate,
  aspirasiEdit,
  aspirasiDelete,

  // Keuangan
  keuanganView,
  iuranTagihanView,
  iuranTagihanCreate,
  iuranTagihanEdit,
  iuranTagihanDelete,
  kategoriIuranView,
  kategoriIuranCreate,
  kategoriIuranEdit,
  kategoriIuranDelete,
  pemasukanLainView,
  pemasukanLainCreate,
  pemasukanLainEdit,
  pemasukanLainDelete,
  pengeluaranView,
  pengeluaranCreate,
  pengeluaranEdit,
  pengeluaranDelete,
  laporanKeuanganView,

  // Lainnya
  penggunaView,
  penggunaCreate,
  penggunaEdit,
  penggunaDelete,
  logAktifitasView,
}
