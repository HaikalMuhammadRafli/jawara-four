import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          _buildNavItem(Icons.more_horiz_outlined, Icons.more_horiz, 4, context),
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

    if (location == '/dashboard') return 0;
    if (location == '/kependudukan') return 1;
    if (location == '/keuangan') return 2;
    if (location == '/kegiatan' || location == '/broadcast') return 3;
    if (location == '/informasi-aspirasi' ||
        location == '/penerimaan-warga' ||
        location == '/mutasi-keluarga' ||
        location == '/log-aktifitas' ||
        location == '/daftar-pengguna') {
      return 4;
    }

    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed('dashboard');
        break;
      case 1:
        context.goNamed('kependudukan');
        break;
      case 2:
        context.goNamed('keuangan');
        break;
      case 3:
        context.goNamed('kegiatan');
        break;
      case 4:
        _showAllMenus(context);
        break;
    }
  }

  void _showAllMenus(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Semua Menu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildMenuTile(context, Icons.message, 'Pesan Warga', 'informasi-aspirasi'),
            _buildMenuTile(context, Icons.person_add, 'Penerimaan Warga', 'penerimaan-warga'),
            _buildMenuTile(context, Icons.swap_horiz, 'Mutasi Keluarga', 'mutasi-keluarga'),
            _buildMenuTile(context, Icons.history, 'Log Aktifitas', 'log-aktifitas'),
            _buildMenuTile(
              context,
              Icons.supervised_user_circle,
              'Daftar Pengguna',
              'daftar-pengguna',
            ),
            _buildMenuTile(context, Icons.broadcast_on_personal, 'Broadcast', 'broadcast'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context, IconData icon, String title, String routeName) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        context.goNamed(routeName);
      },
    );
  }
}
