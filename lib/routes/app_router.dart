import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/data/models/aspirasi_model.dart';
import 'package:jawara_four/data/models/broadcast_model.dart';
import 'package:jawara_four/data/models/kegiatan_model.dart';
import 'package:jawara_four/data/models/penerimaan_warga_model.dart';
import 'package:jawara_four/data/models/rumah_model.dart';
import 'package:jawara_four/pages/dashboard_menu_page.dart';
import 'package:jawara_four/pages/kegiatan/kegiatan_menu_page.dart';
import 'package:jawara_four/pages/kegiatan/screens/broadcast_detail_page.dart';
import 'package:jawara_four/pages/kegiatan/screens/broadcast_edit_page.dart';
import 'package:jawara_four/pages/kegiatan/screens/broadcast_form_page.dart';
import 'package:jawara_four/pages/kegiatan/screens/broadcast_page.dart';
import 'package:jawara_four/pages/kegiatan/screens/kegiatan_detail_page.dart';
import 'package:jawara_four/pages/kegiatan/screens/kegiatan_edit_page.dart';
import 'package:jawara_four/pages/kegiatan/screens/kegiatan_form_page.dart';
import 'package:jawara_four/pages/kegiatan/screens/kegiatan_page.dart';
import 'package:jawara_four/pages/kependudukan/kependudukan_menu_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/kependudukan/keluarga_form_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/kependudukan/keluarga_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/kependudukan/rumah_edit_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/kependudukan/rumah_form_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/kependudukan/rumah_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/kependudukan/tambah_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/kependudukan/warga_form_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/kependudukan/warga_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/mutasi_keluarga/mutasi_keluarga_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/mutasi_keluarga/mutasi_keluarga_tambah_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/penerimaan_warga/penerimaan_warga_detail_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/penerimaan_warga/penerimaan_warga_edit_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/penerimaan_warga/penerimaan_warga_form_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/penerimaan_warga/penerimaan_warga_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/pesan_warga/aspirasi_detail_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/pesan_warga/aspirasi_edit_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/pesan_warga/aspirasi_form_page.dart';
import 'package:jawara_four/pages/kependudukan/screens/pesan_warga/aspirasi_page.dart';
import 'package:jawara_four/pages/keuangan/keuangan_menu_page.dart';
import 'package:jawara_four/pages/keuangan/screens/iuran_tagihan_form_page.dart';
import 'package:jawara_four/pages/keuangan/screens/iuran_tagihan_page.dart';
import 'package:jawara_four/pages/keuangan/screens/kategori_iuran_form_page.dart';
import 'package:jawara_four/pages/keuangan/screens/kategori_iuran_page.dart';
import 'package:jawara_four/pages/keuangan/screens/keuangan_pengeluaran.dart';
import 'package:jawara_four/pages/keuangan/screens/keuangan_pengeluaran_form_page.dart';
import 'package:jawara_four/pages/keuangan/screens/laporan_keuangan_page.dart';
import 'package:jawara_four/pages/keuangan/screens/pemasukan_lain_form_page.dart';
import 'package:jawara_four/pages/keuangan/screens/pemasukan_lain_page.dart';
import 'package:jawara_four/pages/lainnya/screens/log_aktifitas_page.dart';
import 'package:jawara_four/pages/lainnya/screens/pengguna_form_page.dart';
import 'package:jawara_four/pages/lainnya/screens/pengguna_page.dart';
import 'package:jawara_four/pages/login_page.dart';
import 'package:jawara_four/pages/register_page.dart';
import 'package:jawara_four/widgets/custom_bottom_navigationbar.dart';
import 'package:jawara_four/widgets/custom_fab.dart';
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
        floatingActionButton: CustomFab(
          label: 'Tambah Tagihan',
          icon: Icons.receipt_long_rounded,
          routeName: 'iuran-tagihan-form',
          backgroundColor: Color(0xFF1E88E5),
        ),
        child: IuranTagihanPage(),
      ),
    ),
    GoRoute(
      path: '/keuangan/pemasukan-lain',
      name: 'keuangan-pemasukan-lain',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Pemasukan Lain'),
        floatingActionButton: const CustomFab(
          label: 'Tambah Pemasukan',
          icon: Icons.account_balance_wallet_rounded,
          routeName: 'pemasukan-lain-form',
          backgroundColor: Color(0xFF43A047),
        ),
        child: PemasukanLainPage(),
      ),
    ),
    GoRoute(
      path: '/keuangan/kategori-iuran',
      name: 'keuangan-kategori-iuran',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Kategori Iuran'),
        floatingActionButton: const CustomFab(
          label: 'Tambah Kategori',
          icon: Icons.category_rounded,
          routeName: 'kategori-iuran-form',
          backgroundColor: Color(0xFF1E88E5),
        ),
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
        floatingActionButton: CustomFab(
          label: 'Tambah Warga',
          icon: Icons.person_add_rounded,
          routeName: 'warga-form',
        ),
        child: WargaPage(),
      ),
    ),
    GoRoute(
      path: '/kependudukan/warga/form',
      name: 'warga-form',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Tambah Warga Baru'),
        child: WargaFormPage(),
      ),
    ),
    GoRoute(
      path: '/kependudukan/keluarga',
      name: 'kependudukan-keluarga',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Keluarga'),
        floatingActionButton: CustomFab(
          label: 'Tambah Keluarga',
          icon: Icons.group_add_rounded,
          routeName: 'keluarga-form',
        ),
        child: KeluargaPage(),
      ),
    ),
    GoRoute(
      path: '/kependudukan/keluarga/form',
      name: 'keluarga-form',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Tambah Keluarga Baru'),
        child: KeluargaFormPage(),
      ),
    ),
    GoRoute(
      path: '/kependudukan/rumah',
      name: 'kependudukan-rumah',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Rumah'),
        floatingActionButton: CustomFab(
          label: 'Tambah Rumah',
          icon: Icons.add_home_rounded,
          routeName: 'rumah-form',
        ),
        child: RumahPage(),
      ),
    ),
    GoRoute(
      path: '/kependudukan/rumah/form',
      name: 'rumah-form',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Tambah Rumah Baru'),
        child: RumahFormPage(),
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
        floatingActionButton: const CustomFab(
          label: 'Kirim Aspirasi',
          icon: Icons.feedback_rounded,
          routeName: 'informasi-aspirasi-form',
        ),
        child: AspirasiPage(),
      ),
    ),
    GoRoute(
      path: '/penerimaan-warga',
      name: 'penerimaan-warga',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Penerimaan Warga'),
        floatingActionButton: const CustomFab(
          label: 'Daftar Warga',
          icon: Icons.person_add_rounded,
          routeName: 'penerimaan-warga-form',
        ),
        child: PenerimaanWargaPage(),
      ),
    ),
    GoRoute(
      path: '/mutasi-keluarga',
      name: 'mutasi-keluarga',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Mutasi Keluarga'),
        floatingActionButton: CustomFab(
          label: 'Tambah Mutasi',
          icon: Icons.add_circle_outline_rounded,
          routeName: 'mutasi-keluarga-tambah',
        ),
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
      path: '/penerimaan-warga/edit',
      name: 'penerimaan-warga-edit',
      builder: (context, state) {
        final warga = state.extra as PenerimaanWarga;
        return PenerimaanWargaEditPage(warga: warga);
      },
    ),
    GoRoute(
      path: '/informasi-aspirasi/detail',
      name: 'informasi-aspirasi-detail',
      builder: (context, state) {
        final aspirasi = state.extra as Aspirasi;
        return AspirasiDetailPage(aspirasi: aspirasi);
      },
    ),
    GoRoute(
      path: '/informasi-aspirasi/edit',
      name: 'aspirasi-edit',
      builder: (context, state) {
        final aspirasi = state.extra as Aspirasi;
        return AspirasiEditPage(aspirasi: aspirasi);
      },
    ),
    GoRoute(
      path: '/rumah/edit',
      name: 'rumah-edit',
      builder: (context, state) {
        final rumah = state.extra as Rumah;
        return RumahEditPage(rumah: rumah);
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
        floatingActionButton: const CustomFab(
          label: 'Tambah Kegiatan',
          icon: Icons.event_rounded,
          routeName: 'kegiatan-form',
        ),
        child: KegiatanPage(),
      ),
    ),
    GoRoute(
      path: '/broadcast',
      name: 'broadcast',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Broadcast'),
        floatingActionButton: const CustomFab(
          label: 'Kirim Broadcast',
          icon: Icons.campaign_rounded,
          routeName: 'broadcast-form',
        ),
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
      path: '/kegiatan/form',
      name: 'kegiatan-form',
      builder: (context, state) => const KegiatanFormPage(),
    ),
    GoRoute(
      path: '/kegiatan/edit',
      name: 'kegiatan-edit',
      builder: (context, state) {
        final kegiatan = state.extra as Kegiatan;
        return KegiatanEditPage(kegiatan: kegiatan);
      },
    ),
    GoRoute(
      path: '/broadcast/detail',
      name: 'broadcast-detail',
      builder: (context, state) {
        final broadcast = state.extra as Broadcast;
        return BroadcastDetailPage(broadcast: broadcast);
      },
    ),
    GoRoute(
      path: '/broadcast/form',
      name: 'broadcast-form',
      builder: (context, state) => const BroadcastFormPage(),
    ),
    GoRoute(
      path: '/broadcast/edit',
      name: 'broadcast-edit',
      builder: (context, state) {
        final broadcast = state.extra as Broadcast;
        return BroadcastEditPage(broadcast: broadcast);
      },
    ),
    GoRoute(
      path: '/penerimaan-warga/form',
      name: 'penerimaan-warga-form',
      builder: (context, state) => const PenerimaanWargaFormPage(),
    ),
    GoRoute(
      path: '/informasi-aspirasi/form',
      name: 'informasi-aspirasi-form',
      builder: (context, state) => const AspirasiFormPage(),
    ),

    // ===========================================================
    // Keuangan Form Routes
    // ===========================================================
    GoRoute(
      path: '/keuangan/iuran-tagihan/form',
      name: 'iuran-tagihan-form',
      builder: (context, state) => const IuranTagihanFormPage(),
    ),
    GoRoute(
      path: '/keuangan/pemasukan-lain/form',
      name: 'pemasukan-lain-form',
      builder: (context, state) => const PemasukanLainFormPage(),
    ),
    GoRoute(
      path: '/keuangan/pengeluaran/form',
      name: 'keuangan-pengeluaran-form',
      builder: (context, state) => const KeuanganPengeluaranFormPage(),
    ),
    GoRoute(
      path: '/keuangan/kategori-iuran/form',
      name: 'kategori-iuran-form',
      builder: (context, state) => const KategoriIuranFormPage(),
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
        floatingActionButton: CustomFab(
          label: 'Tambah Pengguna',
          icon: Icons.person_add_rounded,
          routeName: 'pengguna-form',
        ),
        child: PenggunaPage(),
      ),
    ),
    GoRoute(
      path: '/daftar-pengguna/form',
      name: 'pengguna-form',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Tambah Pengguna Baru'),
        child: PenggunaFormPage(),
      ),
    ),
  ],
);
