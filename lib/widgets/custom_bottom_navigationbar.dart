import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/data/models/user_profile_model.dart';
import 'package:jawara_four/services/role_service.dart';

class CustomBottomNavigationbar extends StatelessWidget {
  const CustomBottomNavigationbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.1 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTap(context, index),
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xFF1A1A1A),
        unselectedItemColor: const Color(0xFF666666),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          _buildNavItem(Icons.dashboard_outlined, Icons.dashboard, 0, context),
          _buildNavItem(Icons.people_outline, Icons.people, 1, context),
          _buildNavItem(
            Icons.account_balance_wallet_outlined,
            Icons.account_balance_wallet,
            2,
            context,
          ),
          _buildNavItem(Icons.event_outlined, Icons.event, 3, context),
          _buildNavItem(
            Icons.more_horiz_outlined,
            Icons.more_horiz,
            4,
            context,
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData outlinedIcon,
    IconData filledIcon,
    int index,
    BuildContext context,
  ) {
    final isActive = index == _getCurrentIndex(context);

    return BottomNavigationBarItem(
      icon: Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE3F2FD) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isActive ? filledIcon : outlinedIcon,
          color: isActive ? const Color(0xFF1976D2) : const Color(0xFF666666),
          size: 24,
        ),
      ),
      label: '',
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).fullPath;

    // Admin routes - check for main routes and their sub-routes
    if (location == '/admin/dashboard') return 0;
    if (location == '/admin/kependudukan' ||
        location?.startsWith('/admin/kependudukan/') == true) {
      return 1;
    }
    if (location == '/admin/keuangan' ||
        location?.startsWith('/admin/keuangan/') == true)
      return 2;
    if (location == '/admin/kegiatan-broadcast' ||
        location?.startsWith('/admin/kegiatan') == true ||
        location?.startsWith('/admin/broadcast') == true) {
      return 3;
    }

    // Warga routes - check for main routes and their sub-routes
    if (location == '/warga/dashboard') return 0;
    if (location == '/warga/kependudukan' ||
        location?.startsWith('/warga/kependudukan/') == true) {
      return 1;
    }
    if (location == '/warga/keuangan' ||
        location?.startsWith('/warga/keuangan/') == true)
      return 2;
    if (location == '/warga/kegiatan' ||
        location?.startsWith('/warga/kegiatan') == true ||
        location?.startsWith('/warga/broadcast') == true) {
      return 3;
    }

    // Admin Lainnya routes (menu "more")
    if (location?.startsWith('/admin/informasi-aspirasi') == true ||
        location?.startsWith('/admin/penerimaan-warga') == true ||
        location?.startsWith('/admin/mutasi-keluarga') == true ||
        location?.startsWith('/admin/log-aktifitas') == true ||
        location?.startsWith('/admin/daftar-pengguna') == true) {
      return 4;
    }

    return 0;
  }

  void _onTap(BuildContext context, int index) async {
    // Get user role to determine routing
    final roleService = RoleService();
    final role = await roleService.getCurrentUserRole();
    final isWarga = role == UserRole.warga;

    switch (index) {
      case 0:
        context.goNamed(isWarga ? 'warga-dashboard' : 'admin-dashboard');
        break;
      case 1:
        context.goNamed(isWarga ? 'warga-kependudukan' : 'admin-kependudukan');
        break;
      case 2:
        context.goNamed(isWarga ? 'warga-keuangan' : 'admin-keuangan');
        break;
      case 3:
        context.goNamed(
          isWarga ? 'warga-kegiatan-broadcast' : 'admin-kegiatan-broadcast',
        );
        break;
      case 4:
        _showAllMenus(context, isWarga);
        break;
    }
  }

  void _showAllMenus(BuildContext context, bool isWarga) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Semua Menu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Only show admin menus if not warga
            if (!isWarga) ...[
              _buildMenuTile(
                context,
                Icons.camera_alt_outlined,
                'Face Detection',
                () {
                  Navigator.pop(context);
                  context.pushNamed('admin-detection');
                },
              ),
              _buildMenuTile(context, Icons.history, 'Log Aktifitas', () {
                Navigator.pop(context);
                context.pushNamed('admin-log-aktifitas');
              }),
              _buildMenuTile(
                context,
                Icons.supervised_user_circle,
                'Daftar Pengguna',
                () {
                  Navigator.pop(context);
                  context.pushNamed('admin-daftar-pengguna');
                },
              ),
            ],
            _buildMenuTile(context, Icons.logout, 'Log Out', () {
              Navigator.pop(context);
              context.goNamed('logout');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}
