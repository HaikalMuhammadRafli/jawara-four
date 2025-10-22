import 'package:go_router/go_router.dart';
import 'package:jawara_four/pages/dashboard_menu_page.dart';
import 'package:jawara_four/pages/kegiatan/kegiatan_menu_page.dart';
import 'package:jawara_four/pages/kegiatan/models/broadcast_model.dart';
import 'package:jawara_four/pages/kegiatan/models/kegiatan_model.dart';
import 'package:jawara_four/pages/kegiatan/screens/broadcast_detail_page.dart';
import 'package:jawara_four/pages/kegiatan/screens/broadcast_page.dart';
import 'package:jawara_four/pages/kegiatan/screens/kegiatan_detail_page.dart';
import 'package:jawara_four/pages/kegiatan/screens/kegiatan_page.dart';
import 'package:jawara_four/pages/kependudukan/kependudukan_menu_page.dart';
import 'package:jawara_four/pages/kependudukan/models/informasi_aspirasi_model.dart';
import 'package:jawara_four/pages/kependudukan/models/penerimaan_warga_model.dart';
import 'package:jawara_four/pages/kependudukan/screens/kependudukan/keluarga_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/kependudukan/rumah_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/kependudukan/tambah_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/kependudukan/warga_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/mutasi_keluarga/mutasi_keluarga_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/mutasi_keluarga/mutasi_keluarga_tambah_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/penerimaan_warga/penerimaan_warga_detail_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/penerimaan_warga/penerimaan_warga_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/pesan_warga/informasi_aspirasi_detail_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/pesan_warga/informasi_aspirasi_page.dart';
import 'package:jawara_four/pages/keuangan/keuangan_menu_page.dart';
import 'package:jawara_four/pages/keuangan/screens/iuran_tagihan_page.dart';
import 'package:jawara_four/pages/keuangan/screens/kategori_iuran_page.dart';
import 'package:jawara_four/pages/keuangan/screens/keuangan_pengeluaran.dart';
import 'package:jawara_four/pages/keuangan/screens/laporan_keuangan_page.dart';
import 'package:jawara_four/pages/keuangan/screens/pemasukan_lain_page.dart';
import 'package:jawara_four/pages/lainnya/screens/log_aktifitas_page.dart';
import 'package:jawara_four/pages/lainnya/screens/pengguna_page.dart';
import 'package:jawara_four/pages/login_page.dart';
import 'package:jawara_four/pages/register_page.dart';
import 'package:jawara_four/widgets/custom_bottom_navigationbar.dart';
import 'package:jawara_four/widgets/custom_main_appbar.dart';
import 'package:jawara_four/widgets/custom_push_appbar.dart';
import 'package:jawara_four/widgets/custom_scaffold.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', name: 'login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/register', name: 'register', builder: (context, state) => const RegisterPage()),
    GoRoute(path: '/logout', name: 'logout', builder: (context, state) => const LoginPage()),
    ShellRoute(
      builder: (context, state, child) {
        return CustomScaffold(
          state: state,
          appBar: CustomMainAppbar(),
          bottomNavigationBar: CustomBottomNavigationbar(),
          child: child,
        );
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
          path: '/kegiatan-broadcast',
          name: 'kegiatan-broadcast',
          builder: (context, state) => const KegiatanMenuPage(),
        ),
      ],
    ),
    // ===========================================================
    // Additional Keuangan Routes outside BottomNavbar
    // ===========================================================
    GoRoute(
      path: '/keuangan/iuran-tagihan',
      name: 'keuangan-iuran-tagihan',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Iuran dan Tagihan'),
        child: IuranTagihanPage(),
      ),
    ),
    GoRoute(
      path: '/keuangan/pemasukan-lain',
      name: 'keuangan-pemasukan-lain',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Pemasukan Lain'),
        child: PemasukanLainPage(),
      ),
    ),
    GoRoute(
      path: '/keuangan/kategori-iuran',
      name: 'keuangan-kategori-iuran',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Kategori Iuran'),
        child: KategoriIuranPage(),
      ),
    ),
    GoRoute(
      path: '/keuangan/pengeluaran',
      name: 'keuangan-pengeluaran',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Pengeluaran'),
        child: KeuanganPengeluaranPage(),
      ),
    ),
    GoRoute(
      path: '/keuangan/laporan',
      name: 'keuangan-laporan',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Laporan Keuangan'),
        child: LaporanKeuanganPage(),
      ),
    ),

    // ===========================================================
    // Additional Kependudukan Routes outside BottomNavbar
    // ===========================================================
    GoRoute(
      path: '/kependudukan/warga',
      name: 'kependudukan-warga',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Warga'),
        child: WargaPage(),
      ),
    ),
    GoRoute(
      path: '/kependudukan/keluarga',
      name: 'kependudukan-keluarga',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Keluarga'),
        child: KeluargaPage(),
      ),
    ),
    GoRoute(
      path: '/kependudukan/rumah',
      name: 'kependudukan-rumah',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Rumah'),
        child: RumahPage(),
      ),
    ),
    GoRoute(
      path: '/kependudukan/tambah',
      name: 'kependudukan-tambah',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Tambah Warga'),
        child: KependudukanTambahPage(),
      ),
    ),
    GoRoute(
      path: '/informasi-aspirasi',
      name: 'informasi-aspirasi',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Informasi dan Aspirasi'),
        child: InformasiAspirasiPage(),
      ),
    ),
    GoRoute(
      path: '/penerimaan-warga',
      name: 'penerimaan-warga',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Penerimaan Warga'),
        child: PenerimaanWargaPage(),
      ),
    ),
    GoRoute(
      path: '/mutasi-keluarga',
      name: 'mutasi-keluarga',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Mutasi Keluarga'),
        child: MutasiKeluargaPage(),
      ),
    ),
    GoRoute(
      path: '/mutasi-keluarga/tambah',
      name: 'mutasi-keluarga-tambah',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Tambah Mutasi Keluarga'),
        child: MutasiKeluargaTambahPage(),
      ),
    ),
    GoRoute(
      path: '/penerimaan-warga/detail',
      name: 'penerimaan-warga-detail',
      builder: (context, state) {
        final warga = state.extra as PenerimaanWarga;
        return PenerimaanWargaDetailPage(warga: warga);
      },
    ),
    GoRoute(
      path: '/informasi-aspirasi/detail',
      name: 'informasi-aspirasi-detail',
      builder: (context, state) {
        final aspirasi = state.extra as InformasiAspirasi;
        return InformasiAspirasiDetailPage(aspirasi: aspirasi);
      },
    ),

    // ===========================================================
    // Additional Kegiatan Routes outside BottomNavbar
    // ===========================================================
    GoRoute(
      path: '/kegiatan',
      name: 'kegiatan',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Kegiatan'),
        child: KegiatanPage(),
      ),
    ),
    GoRoute(
      path: '/broadcast',
      name: 'broadcast',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Broadcast'),
        child: BroadcastPage(),
      ),
    ),
    GoRoute(
      path: '/kegiatan/detail',
      name: 'kegiatan-detail',
      builder: (context, state) {
        final kegiatan = state.extra as Kegiatan;
        return KegiatanDetailPage(kegiatan: kegiatan);
      },
    ),
    GoRoute(
      path: '/broadcast/detail',
      name: 'broadcast-detail',
      builder: (context, state) {
        final broadcast = state.extra as BroadcastItem;
        return BroadcastDetailPage(broadcast: broadcast);
      },
    ),

    // ===========================================================
    // Lainnya Routes
    // ===========================================================
    GoRoute(
      path: '/log-aktifitas',
      name: 'log-aktifitas',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Log Aktifitas'),
        child: LogAktifitasPage(),
      ),
    ),
    GoRoute(
      path: '/daftar-pengguna',
      name: 'daftar-pengguna',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Daftar Pengguna'),
        child: PenggunaPage(),
      ),
    ),
  ],
);
