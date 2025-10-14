import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_drawer.dart';

class KategoriIuranPage extends StatelessWidget {
  const KategoriIuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        title: const Text('Kategori Iuran'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(
            height: 3,
            color: Colors.purple,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/keuangan'),
        ),
        actions: [
          IconButton(
            onPressed: () => context.go('/tambah-kategori'),
            icon: const Icon(Icons.add),
            color: Colors.purple,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      
      body: Column(
        children: [
          _buildHeader(),
          _buildQuickStats(),
          Expanded(
            child: _buildKategoriList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kategori Iuran',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Master data untuk mengelola jenis-jenis iuran dan pungutan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('Total Kategori', '8', Colors.purple, Icons.category),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Aktif', '6', Colors.green, Icons.check_circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Nonaktif', '2', Colors.orange, Icons.pause_circle),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriList() {
    final List<Map<String, String>> kategoriData = [
      {
        'nama': 'Iuran Bulanan',
        'deskripsi': 'Iuran bulanan untuk operasional RW',
        'nominal': 'Rp 25.000',
        'periode': 'Bulanan',
        'status': 'Aktif',
        'warna': 'blue'
      },
      {
        'nama': 'Iuran Keamanan',
        'deskripsi': 'Iuran untuk keamanan lingkungan',
        'nominal': 'Rp 15.000',
        'periode': 'Bulanan',
        'status': 'Aktif',
        'warna': 'green'
      },
      {
        'nama': 'Iuran Kebersihan',
        'deskripsi': 'Iuran untuk kebersihan lingkungan',
        'nominal': 'Rp 10.000',
        'periode': 'Bulanan',
        'status': 'Aktif',
        'warna': 'orange'
      },
      {
        'nama': 'Iuran Pemeliharaan',
        'deskripsi': 'Iuran untuk pemeliharaan fasilitas umum',
        'nominal': 'Rp 50.000',
        'periode': 'Tahunan',
        'status': 'Aktif',
        'warna': 'purple'
      },
      {
        'nama': 'Iuran Acara',
        'deskripsi': 'Iuran untuk kegiatan dan acara RW',
        'nominal': 'Rp 20.000',
        'periode': 'Per Acara',
        'status': 'Aktif',
        'warna': 'red'
      },
      {
        'nama': 'Iuran Darurat',
        'deskripsi': 'Iuran untuk keperluan darurat',
        'nominal': 'Rp 100.000',
        'periode': 'Per Kejadian',
        'status': 'Aktif',
        'warna': 'teal'
      },
      {
        'nama': 'Iuran Pembangunan',
        'deskripsi': 'Iuran untuk pembangunan infrastruktur',
        'nominal': 'Rp 200.000',
        'periode': 'Sekali',
        'status': 'Nonaktif',
        'warna': 'brown'
      },
      {
        'nama': 'Iuran Sosial',
        'deskripsi': 'Iuran untuk kegiatan sosial',
        'nominal': 'Rp 30.000',
        'periode': 'Per Kegiatan',
        'status': 'Nonaktif',
        'warna': 'pink'
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: kategoriData.length,
      itemBuilder: (context, index) {
        final kategori = kategoriData[index];
        return _buildKategoriCard(kategori);
      },
    );
  }

  Widget _buildKategoriCard(Map<String, String> kategori) {
    Color statusColor = kategori['status'] == 'Aktif' ? Colors.green : Colors.orange;
    Color categoryColor = _getCategoryColor(kategori['warna']!);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: categoryColor.withOpacity(0.3), width: 1),
                ),
                child: Icon(Icons.category, color: categoryColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kategori['nama']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      kategori['deskripsi']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  kategori['status']!,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem('Nominal', kategori['nominal']!),
              ),
              Expanded(
                child: _buildInfoItem('Periode', kategori['periode']!),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.visibility, size: 18, color: Colors.grey),
                tooltip: 'Lihat Detail',
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                tooltip: 'Edit',
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                tooltip: 'Hapus',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String colorName) {
    switch (colorName) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'red':
        return Colors.red;
      case 'teal':
        return Colors.teal;
      case 'brown':
        return Colors.brown;
      case 'pink':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}
