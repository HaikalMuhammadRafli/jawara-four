import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/data/models/aspirasi_model.dart';
import 'package:jawara_four/data/models/broadcast_model.dart';
import 'package:jawara_four/data/models/kegiatan_model.dart';
import 'package:jawara_four/data/models/keluarga_model.dart';
import 'package:jawara_four/data/models/penerimaan_warga_model.dart';
import 'package:jawara_four/data/models/rumah_model.dart';
import 'package:jawara_four/data/models/user_profile_model.dart';
import 'package:jawara_four/data/models/warga_model.dart';
import 'package:jawara_four/pages/admin/dashboard_menu_page.dart';
import 'package:jawara_four/pages/admin/kegiatan/kegiatan_menu_page.dart';
import 'package:jawara_four/pages/admin/kegiatan/screens/broadcast_detail_page.dart';
import 'package:jawara_four/pages/admin/kegiatan/screens/broadcast_edit_page.dart';
import 'package:jawara_four/pages/admin/kegiatan/screens/broadcast_form_page.dart';
import 'package:jawara_four/pages/admin/kegiatan/screens/broadcast_page.dart';
import 'package:jawara_four/pages/admin/kegiatan/screens/kegiatan_detail_page.dart';
import 'package:jawara_four/pages/admin/kegiatan/screens/kegiatan_edit_page.dart';
import 'package:jawara_four/pages/admin/kegiatan/screens/kegiatan_form_page.dart';
import 'package:jawara_four/pages/admin/kegiatan/screens/kegiatan_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/kependudukan_menu_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/kependudukan/keluarga_form_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/kependudukan/keluarga_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/kependudukan/rumah_edit_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/kependudukan/rumah_form_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/kependudukan/rumah_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/kependudukan/tambah_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/kependudukan/warga_form_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/kependudukan/warga_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/mutasi_keluarga/mutasi_keluarga_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/mutasi_keluarga/mutasi_keluarga_tambah_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/penerimaan_warga/penerimaan_warga_detail_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/penerimaan_warga/penerimaan_warga_edit_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/penerimaan_warga/penerimaan_warga_form_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/penerimaan_warga/penerimaan_warga_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/pesan_warga/aspirasi_detail_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/pesan_warga/aspirasi_edit_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/pesan_warga/aspirasi_form_page.dart';
import 'package:jawara_four/pages/admin/kependudukan/screens/pesan_warga/aspirasi_page.dart';
import 'package:jawara_four/pages/admin/keuangan/keuangan_menu_page.dart';
import 'package:jawara_four/pages/admin/keuangan/screens/iuran_tagihan_form_page.dart';
import 'package:jawara_four/pages/admin/keuangan/screens/iuran_tagihan_page.dart';
import 'package:jawara_four/pages/admin/keuangan/screens/kategori_iuran_form_page.dart';
import 'package:jawara_four/pages/admin/keuangan/screens/kategori_iuran_page.dart';
import 'package:jawara_four/pages/admin/keuangan/screens/keuangan_pengeluaran.dart';
import 'package:jawara_four/pages/admin/keuangan/screens/keuangan_pengeluaran_form_page.dart';
import 'package:jawara_four/pages/admin/keuangan/screens/laporan_keuangan_page.dart';
import 'package:jawara_four/pages/admin/keuangan/screens/pemasukan_lain_form_page.dart';
import 'package:jawara_four/pages/admin/keuangan/screens/pemasukan_lain_page.dart';
import 'package:jawara_four/pages/admin/lainnya/screens/log_aktifitas_page.dart';
import 'package:jawara_four/pages/admin/lainnya/screens/pengguna_form_page.dart';
import 'package:jawara_four/pages/admin/lainnya/screens/pengguna_page.dart';
import 'package:jawara_four/pages/auth/login_page.dart';
import 'package:jawara_four/pages/auth/register_page.dart';
import 'package:jawara_four/pages/warga/dashboard_menu_page.dart';
import 'package:jawara_four/pages/warga/kegiatan/kegiatan_menu_page.dart';
import 'package:jawara_four/pages/warga/kegiatan/screens/broadcast_detail_page.dart';
import 'package:jawara_four/pages/warga/kegiatan/screens/broadcast_page.dart';
import 'package:jawara_four/pages/warga/kegiatan/screens/kegiatan_detail_page.dart';
import 'package:jawara_four/pages/warga/kegiatan/screens/kegiatan_page.dart';
import 'package:jawara_four/pages/warga/kependudukan/kependudukan_menu_page.dart';
import 'package:jawara_four/pages/warga/kependudukan/screens/aspirasi_form_page.dart';
import 'package:jawara_four/pages/warga/keuangan/keuangan_menu_page.dart';
import 'package:jawara_four/pages/warga/keuangan/screens/pemasukan_detail_page.dart';
import 'package:jawara_four/pages/warga/keuangan/screens/pengeluaran_detail_page.dart';
import 'package:jawara_four/services/auth_service.dart';
import 'package:jawara_four/services/role_service.dart';
import 'package:jawara_four/widgets/custom_bottom_navigationbar.dart';
import 'package:jawara_four/widgets/custom_fab.dart';
import 'package:jawara_four/widgets/custom_main_appbar.dart';
import 'package:jawara_four/widgets/custom_push_appbar.dart';
import 'package:jawara_four/widgets/custom_scaffold.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) async {
    final authService = AuthService();
    final roleService = RoleService();
    final isLoggedIn = authService.currentUser != null;
    final currentPath = state.matchedLocation;
    final isAuthPage = currentPath == '/login' || currentPath == '/register';

    // Jika belum login dan bukan di halaman auth, redirect ke login
    if (!isLoggedIn && !isAuthPage) {
      return '/login';
    }

    // Jika sudah login dan di halaman auth, redirect ke dashboard sesuai role
    if (isLoggedIn && isAuthPage) {
      final role = await roleService.getCurrentUserRole();
      if (role == UserRole.admin) {
        return '/admin/dashboard';
      } else if (role == UserRole.warga) {
        return '/warga/dashboard';
      }
    }

    // Role-based access control untuk route admin
    if (isLoggedIn && currentPath.startsWith('/admin')) {
      final role = await roleService.getCurrentUserRole();
      if (role != UserRole.admin) {
        return '/warga/dashboard';
      }
    }

    // Role-based access control untuk route warga
    if (isLoggedIn && currentPath.startsWith('/warga')) {
      final role = await roleService.getCurrentUserRole();
      if (role != UserRole.warga) {
        return '/admin/dashboard';
      }
    }

    return null;
  },
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Halaman tidak ditemukan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Path: ${state.matchedLocation}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Kembali ke Login'),
            ),
          ],
        ),
      ),
    );
  },
  routes: [
    // ===========================================================
    // AUTH ROUTES
    // ===========================================================
    GoRoute(path: '/login', name: 'login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/register', name: 'register', builder: (context, state) => const RegisterPage()),
    GoRoute(
      path: '/logout',
      name: 'logout',
      redirect: (context, state) async {
        await AuthService().signOut();
        return '/login';
      },
    ),

    // ===========================================================
    // ADMIN ROUTES (Shell Route with Bottom Nav)
    // ===========================================================
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
        // Admin Dashboard Route
        // ===========================================================
        GoRoute(
          path: '/admin/dashboard',
          name: 'admin-dashboard',
          builder: (context, state) => const DashboardMenuPage(),
        ),

        // ===========================================================
        // Admin Keuangan Routes
        // ===========================================================
        GoRoute(
          path: '/admin/keuangan',
          name: 'admin-keuangan',
          builder: (context, state) => const KeuanganMenuPage(),
        ),

        // ===========================================================
        // Admin Kependudukan Routes
        // ===========================================================
        GoRoute(
          path: '/admin/kependudukan',
          name: 'admin-kependudukan',
          builder: (context, state) => const KependudukanMenuPage(),
        ),

        // ===========================================================
        // Admin Kegiatan dan Broadcast Routes
        // ===========================================================
        GoRoute(
          path: '/admin/kegiatan-broadcast',
          name: 'admin-kegiatan-broadcast',
          builder: (context, state) => const KegiatanMenuPage(),
        ),
      ],
    ),

    // ===========================================================
    // WARGA ROUTES (Shell Route with Bottom Nav)
    // ===========================================================
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
        // Warga Dashboard Route
        // ===========================================================
        GoRoute(
          path: '/warga/dashboard',
          name: 'warga-dashboard',
          builder: (context, state) => const WargaDashboardMenuPage(),
        ),

        // ===========================================================
        // Warga Keuangan Route
        // ===========================================================
        GoRoute(
          path: '/warga/keuangan',
          name: 'warga-keuangan',
          builder: (context, state) => const WargaKeuanganMenuPage(),
        ),

        // ===========================================================
        // Warga Kependudukan Route
        // ===========================================================
        GoRoute(
          path: '/warga/kependudukan',
          name: 'warga-kependudukan',
          builder: (context, state) => const WargaKependudukanMenuPage(),
        ),

        // ===========================================================
        // Warga Kegiatan Route
        // ===========================================================
        GoRoute(
          path: '/warga/kegiatan',
          name: 'warga-kegiatan-broadcast',
          builder: (context, state) => const WargaKegiatanMenuPage(),
        ),
      ],
    ),

    // ===========================================================
    // ADDITIONAL WARGA ROUTES (Outside BottomNavbar)
    // ===========================================================
    // Warga Keuangan Detail Routes
    GoRoute(
      path: '/warga/keuangan/pemasukan/:id',
      name: 'warga-pemasukan-detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return WargaPemasukanDetailPage(pemasukanId: id);
      },
    ),
    GoRoute(
      path: '/warga/keuangan/pengeluaran/:id',
      name: 'warga-pengeluaran-detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return WargaPengeluaranDetailPage(pengeluaranId: id);
      },
    ),

    // Warga hanya bisa read dan detail, tidak bisa tambah/edit
    // Form routes untuk aspirasi tetap ada karena warga bisa mengajukan aspirasi
    GoRoute(
      path: '/warga/kependudukan/aspirasi/form',
      name: 'warga-aspirasi-form',
      builder: (context, state) => const WargaAspirasiFormPage(),
    ),

    // Warga Kegiatan Detail Routes
    GoRoute(
      path: '/warga/kegiatan/detail/:id',
      name: 'warga-kegiatan-detail',
      builder: (context, state) {
        final kegiatanMap = state.extra as Map<String, dynamic>;
        final kegiatan = Kegiatan.fromMap(kegiatanMap);
        return WargaKegiatanDetailPage(kegiatan: kegiatan);
      },
    ),
    GoRoute(
      path: '/warga/kegiatan/list',
      name: 'warga-kegiatan',
      builder: (context, state) => const WargaKegiatanPage(),
    ),
    GoRoute(
      path: '/warga/broadcast/list',
      name: 'warga-broadcast',
      builder: (context, state) => const WargaBroadcastPage(),
    ),
    GoRoute(
      path: '/warga/broadcast/detail/:id',
      name: 'warga-broadcast-detail',
      builder: (context, state) {
        final broadcastMap = state.extra as Map<String, dynamic>;
        final broadcast = Broadcast.fromMap(broadcastMap);
        return WargaBroadcastDetailPage(broadcast: broadcast);
      },
    ),

    // ===========================================================
    // ADDITIONAL ADMIN ROUTES (Outside BottomNavbar)
    // ===========================================================
    // Admin Keuangan Routes
    GoRoute(
      path: '/admin/keuangan/iuran-tagihan',
      name: 'admin-keuangan-iuran-tagihan',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Iuran dan Tagihan'),
        floatingActionButton: CustomFab(
          label: 'Tambah Tagihan',
          icon: Icons.receipt_long_rounded,
          routeName: 'admin-iuran-tagihan-form',
          backgroundColor: Color(0xFF1E88E5),
        ),
        child: IuranTagihanPage(),
      ),
    ),
    GoRoute(
      path: '/admin/keuangan/pemasukan-lain',
      name: 'admin-keuangan-pemasukan-lain',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Pemasukan Lain'),
        floatingActionButton: const CustomFab(
          label: 'Tambah Pemasukan',
          icon: Icons.account_balance_wallet_rounded,
          routeName: 'admin-pemasukan-lain-form',
          backgroundColor: Color(0xFF43A047),
        ),
        child: PemasukanLainPage(),
      ),
    ),
    GoRoute(
      path: '/admin/keuangan/kategori-iuran',
      name: 'admin-keuangan-kategori-iuran',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Kategori Iuran'),
        floatingActionButton: const CustomFab(
          label: 'Tambah Kategori',
          icon: Icons.category_rounded,
          routeName: 'admin-kategori-iuran-form',
          backgroundColor: Color(0xFF1E88E5),
        ),
        child: KategoriIuranPage(),
      ),
    ),
    GoRoute(
      path: '/admin/keuangan/pengeluaran',
      name: 'admin-keuangan-pengeluaran',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Pengeluaran'),
        child: KeuanganPengeluaranPage(),
      ),
    ),
    GoRoute(
      path: '/admin/keuangan/laporan',
      name: 'admin-keuangan-laporan',
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
      path: '/admin/kependudukan/warga',
      name: 'admin-kependudukan-warga',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Warga'),
        floatingActionButton: CustomFab(
          label: 'Tambah Warga',
          icon: Icons.person_add_rounded,
          routeName: 'admin-warga-form',
        ),
        child: WargaPage(),
      ),
    ),
    GoRoute(
      path: '/admin/kependudukan/warga/form',
      name: 'admin-warga-form',
      builder: (context, state) {
        final warga = state.extra as Warga?;
        return CustomScaffold(
          state: state,
          appBar: CustomPushAppbar(title: warga == null ? 'Tambah Warga Baru' : 'Edit Data Warga'),
          child: WargaFormPage(warga: warga),
        );
      },
    ),
    GoRoute(
      path: '/admin/kependudukan/keluarga',
      name: 'admin-kependudukan-keluarga',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Keluarga'),
        floatingActionButton: CustomFab(
          label: 'Tambah Keluarga',
          icon: Icons.group_add_rounded,
          routeName: 'admin-keluarga-form',
        ),
        child: KeluargaPage(),
      ),
    ),
    GoRoute(
      path: '/admin/kependudukan/keluarga/form',
      name: 'admin-keluarga-form',
      builder: (context, state) {
        final keluarga = state.extra as Keluarga?;
        return CustomScaffold(
          state: state,
          appBar: CustomPushAppbar(
            title: keluarga == null ? 'Tambah Keluarga Baru' : 'Edit Data Keluarga',
          ),
          child: KeluargaFormPage(keluarga: keluarga),
        );
      },
    ),
    GoRoute(
      path: '/admin/kependudukan/rumah',
      name: 'admin-kependudukan-rumah',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Rumah'),
        floatingActionButton: CustomFab(
          label: 'Tambah Rumah',
          icon: Icons.add_home_rounded,
          routeName: 'admin-rumah-form',
        ),
        child: RumahPage(),
      ),
    ),
    GoRoute(
      path: '/admin/kependudukan/rumah/form',
      name: 'admin-rumah-form',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Tambah Rumah Baru'),
        child: RumahFormPage(),
      ),
    ),
    GoRoute(
      path: '/admin/kependudukan/tambah',
      name: 'admin-kependudukan-tambah',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Tambah Warga'),
        child: KependudukanTambahPage(),
      ),
    ),
    GoRoute(
      path: '/admin/informasi-aspirasi',
      name: 'admin-informasi-aspirasi',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Informasi dan Aspirasi'),
        floatingActionButton: const CustomFab(
          label: 'Kirim Aspirasi',
          icon: Icons.feedback_rounded,
          routeName: 'admin-informasi-aspirasi-form',
        ),
        child: AspirasiPage(),
      ),
    ),
    GoRoute(
      path: '/admin/penerimaan-warga',
      name: 'admin-penerimaan-warga',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Penerimaan Warga'),
        floatingActionButton: const CustomFab(
          label: 'Daftar Warga',
          icon: Icons.person_add_rounded,
          routeName: 'admin-penerimaan-warga-form',
        ),
        child: PenerimaanWargaPage(),
      ),
    ),
    GoRoute(
      path: '/admin/mutasi-keluarga',
      name: 'admin-mutasi-keluarga',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Mutasi Keluarga'),
        floatingActionButton: CustomFab(
          label: 'Tambah Mutasi',
          icon: Icons.add_circle_outline_rounded,
          routeName: 'admin-mutasi-keluarga-tambah',
        ),
        child: MutasiKeluargaPage(),
      ),
    ),
    GoRoute(
      path: '/admin/mutasi-keluarga/tambah',
      name: 'admin-mutasi-keluarga-tambah',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Tambah Mutasi Keluarga'),
        child: MutasiKeluargaTambahPage(),
      ),
    ),
    GoRoute(
      path: '/admin/penerimaan-warga/detail',
      name: 'admin-penerimaan-warga-detail',
      builder: (context, state) {
        final warga = state.extra as PenerimaanWarga;
        return PenerimaanWargaDetailPage(warga: warga);
      },
    ),
    GoRoute(
      path: '/admin/penerimaan-warga/edit',
      name: 'admin-penerimaan-warga-edit',
      builder: (context, state) {
        final warga = state.extra as PenerimaanWarga;
        return PenerimaanWargaEditPage(warga: warga);
      },
    ),
    GoRoute(
      path: '/admin/informasi-aspirasi/detail',
      name: 'admin-informasi-aspirasi-detail',
      builder: (context, state) {
        final aspirasi = state.extra as Aspirasi;
        return AspirasiDetailPage(aspirasi: aspirasi);
      },
    ),
    GoRoute(
      path: '/admin/informasi-aspirasi/edit',
      name: 'admin-aspirasi-edit',
      builder: (context, state) {
        final aspirasi = state.extra as Aspirasi;
        return AspirasiEditPage(aspirasi: aspirasi);
      },
    ),
    GoRoute(
      path: '/admin/rumah/edit',
      name: 'admin-rumah-edit',
      builder: (context, state) {
        final rumah = state.extra as Rumah;
        return RumahEditPage(rumah: rumah);
      },
    ),

    // ===========================================================
    // Additional Kegiatan Routes outside BottomNavbar
    // ===========================================================
    GoRoute(
      path: '/admin/kegiatan',
      name: 'admin-kegiatan',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Kegiatan'),
        floatingActionButton: const CustomFab(
          label: 'Tambah Kegiatan',
          icon: Icons.event_rounded,
          routeName: 'admin-kegiatan-form',
        ),
        child: KegiatanPage(),
      ),
    ),
    GoRoute(
      path: '/admin/broadcast',
      name: 'admin-broadcast',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Broadcast'),
        floatingActionButton: const CustomFab(
          label: 'Kirim Broadcast',
          icon: Icons.campaign_rounded,
          routeName: 'admin-broadcast-form',
        ),
        child: BroadcastPage(),
      ),
    ),
    GoRoute(
      path: '/admin/kegiatan/detail',
      name: 'admin-kegiatan-detail',
      builder: (context, state) {
        final kegiatan = state.extra as Kegiatan;
        return KegiatanDetailPage(kegiatan: kegiatan);
      },
    ),
    GoRoute(
      path: '/admin/kegiatan/form',
      name: 'admin-kegiatan-form',
      builder: (context, state) => const KegiatanFormPage(),
    ),
    GoRoute(
      path: '/admin/kegiatan/edit',
      name: 'admin-kegiatan-edit',
      builder: (context, state) {
        final kegiatan = state.extra as Kegiatan;
        return KegiatanEditPage(kegiatan: kegiatan);
      },
    ),
    GoRoute(
      path: '/admin/broadcast/detail',
      name: 'admin-broadcast-detail',
      builder: (context, state) {
        final broadcast = state.extra as Broadcast;
        return BroadcastDetailPage(broadcast: broadcast);
      },
    ),
    GoRoute(
      path: '/admin/broadcast/form',
      name: 'admin-broadcast-form',
      builder: (context, state) => const BroadcastFormPage(),
    ),
    GoRoute(
      path: '/admin/broadcast/edit',
      name: 'admin-broadcast-edit',
      builder: (context, state) {
        final broadcast = state.extra as Broadcast;
        return BroadcastEditPage(broadcast: broadcast);
      },
    ),
    GoRoute(
      path: '/admin/penerimaan-warga/form',
      name: 'admin-penerimaan-warga-form',
      builder: (context, state) => const PenerimaanWargaFormPage(),
    ),
    GoRoute(
      path: '/admin/informasi-aspirasi/form',
      name: 'admin-informasi-aspirasi-form',
      builder: (context, state) => const AspirasiFormPage(),
    ),

    // ===========================================================
    // Keuangan Form Routes
    // ===========================================================
    GoRoute(
      path: '/admin/keuangan/iuran-tagihan/form',
      name: 'admin-iuran-tagihan-form',
      builder: (context, state) => const IuranTagihanFormPage(),
    ),
    GoRoute(
      path: '/admin/keuangan/pemasukan-lain/form',
      name: 'admin-pemasukan-lain-form',
      builder: (context, state) => const PemasukanLainFormPage(),
    ),
    GoRoute(
      path: '/admin/keuangan/pengeluaran/form',
      name: 'admin-keuangan-pengeluaran-form',
      builder: (context, state) => const KeuanganPengeluaranFormPage(),
    ),
    GoRoute(
      path: '/admin/keuangan/kategori-iuran/form',
      name: 'admin-kategori-iuran-form',
      builder: (context, state) => const KategoriIuranFormPage(),
    ),

    // ===========================================================
    // Lainnya Routes
    // ===========================================================
    GoRoute(
      path: '/admin/log-aktifitas',
      name: 'admin-log-aktifitas',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Log Aktifitas'),
        child: LogAktifitasPage(),
      ),
    ),
    GoRoute(
      path: '/admin/daftar-pengguna',
      name: 'admin-daftar-pengguna',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Daftar Pengguna'),
        floatingActionButton: CustomFab(
          label: 'Tambah Pengguna',
          icon: Icons.person_add_rounded,
          routeName: 'admin-pengguna-form',
        ),
        child: PenggunaPage(),
      ),
    ),
    GoRoute(
      path: '/admin/daftar-pengguna/form',
      name: 'admin-pengguna-form',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Tambah Pengguna Baru'),
        child: PenggunaFormPage(),
      ),
    ),

    // ===========================================================
    // Warga Keuangan Detail Routes (Additional)
    // ===========================================================
    GoRoute(
      path: '/warga/keuangan/laporan',
      name: 'warga-keuangan-laporan',
      builder: (context, state) => CustomScaffold(
        state: state,
        appBar: CustomPushAppbar(title: 'Laporan Keuangan'),
        child: LaporanKeuanganPage(),
      ),
    ),
  ],
);
