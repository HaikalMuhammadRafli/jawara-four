import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KependudukanTambahPage extends StatelessWidget {
  const KependudukanTambahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Expanded(child: _buildMenuOptions(context)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.1 * 255).round()),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tambah Data Kependudukan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          const Text(
            'Pilih jenis data yang ingin ditambahkan',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilihan Menu',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildOptionCard(
                context,
                'Tambah Warga',
                'Tambahkan data warga baru ke sistem',
                Icons.person_add,
                Colors.blue,
                'kependudukan-tambah',
              ),
              _buildOptionCard(
                context,
                'Tambah Rumah',
                'Tambahkan data rumah baru ke sistem',
                Icons.home_work,
                Colors.orange,
                'kependudukan-tambah',
              ),
              _buildOptionCard(
                context,
                'Tambah Keluarga',
                'Buat keluarga baru dan hubungkan warga',
                Icons.family_restroom,
                Colors.green,
                'kependudukan-tambah',
              ),
              _buildOptionCard(
                context,
                'Import Data',
                'Import data dari file Excel',
                Icons.upload_file,
                Colors.purple,
                'kependudukan-tambah',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String routeName,
  ) {
    return GestureDetector(
      onTap: () => context.goNamed(routeName),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha((0.1 * 255).round()),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withAlpha((0.3 * 255).round()), width: 1),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
