import 'package:go_router/go_router.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/pengeluaran_page.dart';
import '../pages/laporan_keuangan_page.dart';
import '../pages/kegiatan_page.dart';
import '../pages/broadcast_page.dart';

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

    // ====== KEUANGAN ======
    GoRoute(
      path: '/pengeluaran',
      name: 'pengeluaran',
      builder: (context, state) => const PengeluaranPage(),
    ),
    GoRoute(
      path: '/laporan',
      name: 'laporan',
      builder: (context, state) => const LaporanKeuanganPage(),
    ),

    // ====== KEGIATAN & BROADCAST ======
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
  ],
);
