import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header drawer
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.apartment, size: 48, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'Jawara Pintar',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('admin1@gmail.com', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          // Menu Dashboard
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => context.goNamed('dashboard'),
          ),

          // Menu Keuangan
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('Keuangan'),
            onTap: () => context.goNamed('keuangan'),
          ),

          // Menu Kependudukan
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Kependudukan'),
            onTap: () => context.goNamed('kependudukan'),
          ),

          // Menu Kegiatan & Broadcast
          ExpansionTile(
            leading: const Icon(Icons.event),
            title: const Text('Kegiatan & Broadcast'),
            children: [
              ListTile(title: const Text('Kegiatan'), onTap: () => context.goNamed('kegiatan')),
              ListTile(title: const Text('Broadcast'), onTap: () => context.goNamed('broadcast')),
            ],
          ),

          // Menu Pesan Warga
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Pesan Warga'),
            onTap: () => context.goNamed('informasi-aspirasi'),
          ),

          // Menu Penerimaan Warga
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Penerimaan Warga'),
            onTap: () => context.goNamed('penerimaan-warga'),
          ),

          // Menu Mutasi Keluarga
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Mutasi Keluarga'),
            onTap: () => context.goNamed('mutasi-keluarga'),
          ),
        ],
      ),
    );
  }
}
