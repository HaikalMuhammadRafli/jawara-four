import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/app_drawer.dart';

class KeluargaPage extends StatelessWidget {
  const KeluargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        title: const Text('Data Keluarga'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(
            height: 3,
            color: Colors.green,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/kependudukan'),
        ),
      ),
      
      drawer: const AppDrawer(),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: _buildKeluargaList(),
          ),
        ],
      ),
    );
  }


  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari keluarga...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Semua', true),
                const SizedBox(width: 8),
                _buildFilterChip('Kepemilikan', false),
                const SizedBox(width: 8),
                _buildFilterChip('Sewa', false),
                const SizedBox(width: 8),
                _buildFilterChip('Kontrak', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {},
      selectedColor: Colors.green[100],
      checkmarkColor: Colors.green,
      labelStyle: TextStyle(
        color: isSelected ? Colors.green : Colors.grey[600],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildKeluargaList() {
    final List<Map<String, String>> keluargaData = [
      {
        'kepalaKeluarga': 'Ahmad Budiman',
        'alamat': 'Jl. Merdeka No. 15',
        'jumlahAnggota': '4'
      },
      {
        'kepalaKeluarga': 'Budi Santoso',
        'alamat': 'Jl. Sudirman No. 25',
        'jumlahAnggota': '3'
      },
      {
        'kepalaKeluarga': 'Suryadi',
        'alamat': 'Jl. Gatot Subroto No. 8',
        'jumlahAnggota': '2'
      },
      {
        'kepalaKeluarga': 'Muhammad Yusuf',
        'alamat': 'Jl. Pahlawan No. 12',
        'jumlahAnggota': '5'
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: keluargaData.length,
      itemBuilder: (context, index) {
        final keluarga = keluargaData[index];
        return _buildKeluargaCard(keluarga);
      },
    );
  }

  Widget _buildKeluargaCard(Map<String, String> keluarga) {
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
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!, width: 1),
                ),
                child: const Icon(Icons.family_restroom, color: Colors.green, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      keluarga['kepalaKeluarga']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${keluarga['jumlahAnggota']} Anggota',
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
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Aktif',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[400]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  keluarga['alamat']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                tooltip: 'Edit',
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.visibility, size: 18, color: Colors.grey),
                tooltip: 'Lihat Detail',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
