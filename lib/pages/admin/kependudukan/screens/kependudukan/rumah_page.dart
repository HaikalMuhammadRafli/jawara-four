import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../../../../data/models/rumah_model.dart';
import '../../../../../data/models/warga_model.dart';
import '../../../../../data/repositories/rumah_repository.dart';
import '../../../../../data/repositories/warga_repository.dart';
import 'rumah_detail_page.dart';

class RumahPage extends StatefulWidget {
  const RumahPage({super.key});

  @override
  State<RumahPage> createState() => _RumahPageState();
}

class _RumahPageState extends State<RumahPage> {
  final RumahRepository _repository = RumahRepository();
  final WargaRepository _wargaRepository = WargaRepository();
  String _searchQuery = '';
  String _selectedFilter = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: StreamBuilder<List<Rumah>>(
              stream: _repository.getRumahStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Terjadi kesalahan: ${snapshot.error}',
                          style: TextStyle(color: AppColors.error),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final rumahList = snapshot.data ?? [];

                if (rumahList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_outlined,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada data rumah',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Filter data
                final filteredList = rumahList.where((rumah) {
                  final matchesSearch =
                      rumah.alamat.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      ) ||
                      (rumah.pemilikId?.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          ) ??
                          false);

                  final matchesFilter =
                      _selectedFilter == 'Semua' ||
                      (_selectedFilter == 'Ditempati' &&
                          rumah.status == StatusRumah.ditempati) ||
                      (_selectedFilter == 'Tersedia' &&
                          rumah.status != StatusRumah.ditempati);

                  return matchesSearch && matchesFilter;
                }).toList();

                if (filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada rumah yang sesuai',
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
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    return _buildRumahCard(context, filteredList[index]);
                  },
                );
              },
            ),
          ),
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
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Cari rumah...',
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
                _buildFilterChip('Semua', _selectedFilter == 'Semua'),
                const SizedBox(width: 10),
                _buildFilterChip('Ditempati', _selectedFilter == 'Ditempati'),
                const SizedBox(width: 10),
                _buildFilterChip('Tersedia', _selectedFilter == 'Tersedia'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
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

  Widget _buildRumahCard(BuildContext context, Rumah rumah) {
    Color statusColor = rumah.status == StatusRumah.ditempati
        ? const Color(0xFF43A047)
        : const Color(0xFFE53935);

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
              // Icon dengan design modern
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
                  Icons.home_rounded,
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
                      rumah.alamat,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    FutureBuilder<Warga?>(
                      future: rumah.pemilikId != null
                          ? _wargaRepository.getWargaById(rumah.pemilikId!)
                          : Future.value(null),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            'Loading...',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.2,
                            ),
                          );
                        }

                        final pemilik = snapshot.data;
                        return Text(
                          pemilik != null
                              ? 'Pemilik: ${pemilik.nama}'
                              : 'Pemilik: Belum diatur',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.2,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Badge status
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  rumah.status.value,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
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
                  rumah,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  'Edit',
                  Icons.edit_outlined,
                  AppColors.primary,
                  rumah,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  'Hapus',
                  Icons.delete_outline_rounded,
                  const Color(0xFFE53935),
                  rumah,
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
    Rumah rumah,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (label == 'Detail') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RumahDetailPage(rumah: rumah),
              ),
            );
          } else if (label == 'Edit') {
            context.pushNamed('admin-rumah-edit', extra: rumah);
          } else if (label == 'Hapus') {
            _showDeleteConfirmation(context, rumah);
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

  // Dialog konfirmasi hapus
  void _showDeleteConfirmation(BuildContext context, Rumah rumah) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Hapus Rumah',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah Anda yakin ingin menghapus rumah ini?',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rumah.alamat,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder<Warga?>(
                    future: rumah.pemilikId != null
                        ? _wargaRepository.getWargaById(rumah.pemilikId!)
                        : Future.value(null),
                    builder: (context, snapshot) {
                      final pemilik = snapshot.data;
                      return Text(
                        pemilik != null
                            ? 'Pemilik: ${pemilik.nama}'
                            : 'Pemilik: Belum diatur',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _repository.deleteRumah(rumah.id);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.white),
                        SizedBox(width: 12),
                        Expanded(child: Text('Rumah berhasil dihapus!')),
                      ],
                    ),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('Gagal menghapus rumah: ${e.toString()}'),
                        ),
                      ],
                    ),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            },
            child: Text(
              'Hapus',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
