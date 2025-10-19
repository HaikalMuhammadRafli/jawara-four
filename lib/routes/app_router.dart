import 'package:go_router/go_router.dart';
import 'package:jawara_four/pages/kegiatan/kegiatan_menu_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/mutasi_keluarga/mutasi_keluarga_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/mutasi_keluarga/mutasi_keluarga_tambah_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/penerimaan_warga/penerimaan_warga_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/pesan_warga/informasi_aspirasi_page.dart';
import 'package:jawara_four/pages/layout_main.dart';
import 'package:jawara_four/pages/layout_push.dart';

import '../pages/dashboard_menu_page.dart';
import '../pages/kegiatan/screens/broadcast_page.dart';
import '../pages/kependudukan/kependudukan_menu_page.dart';
import '../pages/kependudukan/screens/kependudukan/keluarga_page.dart';
import '../pages/kependudukan/screens/kependudukan/rumah_page.dart';
import '../pages/kependudukan/screens/kependudukan/tambah_page.dart';
import '../pages/kependudukan/screens/kependudukan/warga_page.dart';
import '../pages/keuangan/keuangan_menu_page.dart';
import '../pages/keuangan/screens/iuran_tagihan_page.dart';
import '../pages/keuangan/screens/kategori_iuran_page.dart';
import '../pages/keuangan/screens/keuangan_pengeluaran.dart';
import '../pages/keuangan/screens/laporan_keuangan_page.dart';
import '../pages/keuangan/screens/pemasukan_lain_page.dart';
import '../pages/lainnya/screens/log_aktifitas_page.dart';
import '../pages/lainnya/screens/pengguna_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(path: '/login', name: 'login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/register', name: 'register', builder: (context, state) => const RegisterPage()),
    ShellRoute(
      builder: (context, state, child) {
        return LayoutMain(state: state, child: child);
      },
      routes: [
        // ===========================================================
        // Dashboard Route
        // ===========================================================
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardMenuPage(),
        ),

        // ===========================================================
        // Keuangan Routes
        // ===========================================================
        GoRoute(
          path: '/keuangan',
          name: 'keuangan',
          builder: (context, state) => const KeuanganMenuPage(),
        ),

        // ===========================================================
        // Kependudukan Routes
        // ===========================================================
        GoRoute(
          path: '/kependudukan',
          name: 'kependudukan',
          builder: (context, state) => const KependudukanMenuPage(),
        ),

        // ===========================================================
        // Kegiatan dan Broadcast Routes
        // ===========================================================
        GoRoute(
          path: '/kegiatan',
          name: 'kegiatan',
          builder: (context, state) => const KegiatanMenuPage(),
        ),
      ],
    ),

    ShellRoute(
      builder: (context, state, child) {
        return LayoutPush(state: state, child: child);
      },
      routes: [
        // ===========================================================
        // Additional Keuangan Routes outside BottomNavbar
        // ===========================================================
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

        // ===========================================================
        // Additional Kependudukan Routes outside BottomNavbar
        // ===========================================================
        GoRoute(
          path: '/kependudukan/warga',
          name: 'kependudukan-warga',
          builder: (context, state) => const WargaPage(),
        ),
        GoRoute(
          path: '/kependudukan/keluarga',
          name: 'kependudukan-keluarga',
          builder: (context, state) => const KeluargaPage(),
        ),
        GoRoute(
          path: '/kependudukan/rumah',
          name: 'kependudukan-rumah',
          builder: (context, state) => const RumahPage(),
        ),
        GoRoute(
          path: '/kependudukan/tambah',
          name: 'kependudukan-tambah',
          builder: (context, state) => const KependudukanTambahPage(),
        ),
        GoRoute(
          path: '/informasi-aspirasi',
          name: 'informasi-aspirasi',
          builder: (context, state) => const InformasiAspirasiPage(),
        ),
        GoRoute(
          path: '/penerimaan-warga',
          name: 'penerimaan-warga',
          builder: (context, state) => const PenerimaanWargaPage(),
        ),
        GoRoute(
          path: '/mutasi-keluarga',
          name: 'mutasi-keluarga',
          builder: (context, state) => const MutasiKeluargaPage(),
        ),
        GoRoute(
          path: '/mutasi-keluarga/tambah',
          name: 'mutasi-keluarga-tambah',
          builder: (context, state) => const MutasiKeluargaTambahPage(),
        ),

        // ===========================================================
        // Additional Kegiatan Routes outside BottomNavbar
        // ===========================================================
        GoRoute(
          path: '/broadcast',
          name: 'broadcast',
          builder: (context, state) => const BroadcastPage(),
        ),

        // ===========================================================
        // Lainnya Routes
        // ===========================================================
        GoRoute(
          path: '/log-aktifitas',
          name: 'log-aktifitas',
          builder: (context, state) => const LogAktifitasPage(),
        ),
        GoRoute(
          path: '/daftar-pengguna',
          name: 'daftar-pengguna',
          builder: (context, state) => const PenggunaPage(),
        ),
      ],
    ),
  ],
);
