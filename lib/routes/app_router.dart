import 'package:go_router/go_router.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/kegiatan_page.dart';
import '../pages/broadcast_page.dart';
import '../pages/keuangan.dart';
import '../pages/iuran_tagihan_page.dart';
import '../pages/pemasukan_lain_page.dart';
import '../pages/kategori_iuran_page.dart';
import '../pages/keuangan_pengeluaran.dart';
import '../pages/laporan_keuangan_page.dart';
import '../pages/kependudukan.dart';
import '../pages/kependudukan_warga.dart';
import '../pages/kependudukan_keluarga.dart';
import '../pages/kependudukan_rumah.dart';
import '../pages/kependudukan_tambah.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
    ),


    GoRoute(
      path: '/kegiatan',
      name: 'kegiatan',
      builder: (context, state) => const KegiatanPage(),
    ),
    GoRoute(
      path: '/broadcast',
      name: 'broadcast',
      builder: (context, state) => const BroadcastPage(),
    ),
    GoRoute(
      path: '/keuangan',
      name: 'keuangan',
      builder: (context, state) => const KeuanganPage(),
    ),
    GoRoute(
      path: '/keuangan/iuran-tagihan',
      name: 'keuangan-iuran-tagihan',
      builder: (context, state) => const IuranTagihanPage(),
    ),
    GoRoute(
      path: '/keuangan/pemasukan-lain',
      name: 'keuangan-pemasukan-lain',
      builder: (context, state) => const PemasukanLainPage(),
    ),
    GoRoute(
      path: '/keuangan/kategori-iuran',
      name: 'keuangan-kategori-iuran',
      builder: (context, state) => const KategoriIuranPage(),
    ),
    GoRoute(
      path: '/keuangan/pengeluaran',
      name: 'keuangan-pengeluaran',
      builder: (context, state) => const KeuanganPengeluaranPage(),
    ),
    GoRoute(
      path: '/keuangan/laporan',
      name: 'keuangan-laporan',
      builder: (context, state) => const LaporanKeuanganPage(),
    ),
    GoRoute(
      path: '/kependudukan',
      name: 'kependudukan',
      builder: (context, state) => const KependudukanPage(),
    ),
    GoRoute(
      path: '/kependudukan/warga',
      name: 'kependudukan-warga',
      builder: (context, state) => const KependudukanWargaPage(),
    ),
    GoRoute(
      path: '/kependudukan/keluarga',
      name: 'kependudukan-keluarga',
      builder: (context, state) => const KependudukanKeluargaPage(),
    ),
    GoRoute(
      path: '/kependudukan/rumah',
      name: 'kependudukan-rumah',
      builder: (context, state) => const KependudukanRumahPage(),
    ),
    GoRoute(
      path: '/kependudukan/tambah',
      name: 'kependudukan-tambah',
      builder: (context, state) => const KependudukanTambahPage(),
    ),
  ],
);
