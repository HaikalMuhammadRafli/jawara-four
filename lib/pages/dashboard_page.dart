import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jawara Pintar'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.apartment, size: 48, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Jawara Pintar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'admin1@gmail.com',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // ====== DASHBOARD ======
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => context.go('/dashboard'),
            ),

            // ====== KEUANGAN ======
            ExpansionTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Keuangan'),
              children: [
                ListTile(
                  title: const Text('Pemasukan'),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Pengeluaran'),
                  onTap: () => context.go('/pengeluaran'),
                ),
                ListTile(
                  title: const Text('Laporan Keuangan'),
                  onTap: () => context.go('/laporan'),
                ),
              ],
            ),

            // ====== KEGIATAN & BROADCAST ======
            ExpansionTile(
              leading: const Icon(Icons.event),
              title: const Text('Kegiatan & Broadcast'),
              children: [
                ListTile(
                  title: const Text('Kegiatan'),
                  onTap: () => context.go('/kegiatan'),
                ),
                ListTile(
                  title: const Text('Broadcast'),
                  onTap: () => context.go('/broadcast'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Selamat Datang di Dashboard Jawara Pintar!',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
