import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../../../../data/models/keluarga_model.dart';
import '../../../../../data/repositories/keluarga_repository.dart';

class KeluargaPage extends StatefulWidget {
  const KeluargaPage({super.key});

  @override
  State<KeluargaPage> createState() => _KeluargaPageState();
}

class _KeluargaPageState extends State<KeluargaPage> {
  final KeluargaRepository _repository = KeluargaRepository();

  String _searchQuery = '';
  String _selectedFilter = 'Semua';

  Future<void> _deleteKeluarga(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Keluarga'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus data keluarga ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _repository.deleteKeluarga(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data keluarga berhasil dihapus')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gagal menghapus data: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(child: _buildKeluargaList()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
      ),
      child: Column(
        children: [
          // Search field dengan design modern
          TextField(
            onChanged: (value) =>
                setState(() => _searchQuery = value.toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Cari keluarga...',
              hintStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.textSecondary,
                size: 22,
              ),
              filled: true,
              fillColor: AppColors.divider.withValues(alpha: 0.15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Filter chips modern
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Semua'),
                const SizedBox(width: 10),
                _buildFilterChip('Kepemilikan'),
                const SizedBox(width: 10),
                _buildFilterChip('Sewa'),
                const SizedBox(width: 10),
                _buildFilterChip('Kontrak'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.divider.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.background : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  Widget _buildKeluargaList() {
    return StreamBuilder<List<Keluarga>>(
      stream: _repository.getKeluargaStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final allData = snapshot.data ?? [];

        // Filter berdasarkan search query dan filter kategori
        final filteredData = allData.where((keluarga) {
          final matchesSearch = keluarga.nomorKK.toLowerCase().contains(
            _searchQuery,
          );

          // Filter berdasarkan kategori (placeholder - bisa disesuaikan dengan field di model)
          final matchesFilter = _selectedFilter == 'Semua';

          return matchesSearch && matchesFilter;
        }).toList();

        if (filteredData.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.family_restroom_rounded,
                  size: 64,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  allData.isEmpty
                      ? 'Belum ada data keluarga'
                      : 'Tidak ada hasil pencarian',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: filteredData.length,
          itemBuilder: (context, index) {
            final keluarga = filteredData[index];
            return _buildKeluargaCard(context, keluarga);
          },
        );
      },
    );
  }

  Widget _buildKeluargaCard(BuildContext context, Keluarga keluarga) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.15),
                      AppColors.primary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.family_restroom_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KK: ${keluarga.nomorKK}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${keluarga.jumlahAnggota} Anggota',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Aktif',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: AppColors.divider.withValues(alpha: 0.5), height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Detail',
                  Icons.visibility_outlined,
                  AppColors.textSecondary,
                  keluarga,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  'Edit',
                  Icons.edit_outlined,
                  AppColors.primary,
                  keluarga,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  'Hapus',
                  Icons.delete_outline_rounded,
                  const Color(0xFFE53935),
                  keluarga,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    Keluarga keluarga,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (label == 'Detail') {
            context.pushNamed('admin-keluarga-detail', extra: keluarga);
          } else if (label == 'Edit') {
            context.pushNamed('admin-keluarga-form', extra: keluarga);
          } else if (label == 'Hapus') {
            _deleteKeluarga(keluarga.id);
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
