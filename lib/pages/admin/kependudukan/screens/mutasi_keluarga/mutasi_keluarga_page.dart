import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../../../../data/models/mutasi_keluarga_model.dart';
import '../../../../../data/repositories/mutasi_keluarga_repository.dart';

import '../../../../../utils/ui_helpers.dart';

class MutasiKeluargaPage extends StatefulWidget {
  const MutasiKeluargaPage({super.key});

  @override
  State<MutasiKeluargaPage> createState() => _MutasiKeluargaPageState();
}

class _MutasiKeluargaPageState extends State<MutasiKeluargaPage> {
  final _repository = MutasiKeluargaRepository();

  Future<void> _showDeleteConfirmation(MutasiKeluarga mutasi) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Mutasi?'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus data mutasi ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _repository.delete(mutasi.id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mutasi berhasil dihapus')),
        );
        setState(() {}); // Refresh list
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _buildSearchAndFilter(),
            Expanded(child: _buildMutasiKeluargaList()),
          ],
        ),
      ],
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
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              filled: true,
              fillColor: AppColors.backgroundGray.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Semua', true),
                const SizedBox(width: 8),
                _buildFilterChip('Pindah Rumah', false),
                const SizedBox(width: 8),
                _buildFilterChip('Pindah Domisili', false),
                const SizedBox(width: 8),
                _buildFilterChip('Lainnya', false),
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
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      checkmarkColor: AppColors.primary,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.divider,
        ),
      ),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        fontSize: 13,
      ),
    );
  }

  final MutasiKeluargaRepository _mutasiRepository = MutasiKeluargaRepository();

  Widget _buildMutasiKeluargaList() {
    return StreamBuilder<List<MutasiKeluarga>>(
      stream: _mutasiRepository.streamAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final mutasiKeluargaData = snapshot.data ?? [];

        if (mutasiKeluargaData.isEmpty) {
          return const Center(child: Text('Belum ada data mutasi'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: mutasiKeluargaData.length,
          itemBuilder: (context, index) {
            final mutasiKeluarga = mutasiKeluargaData[index];
            return _buildMutasiKeluargaCard(mutasiKeluarga);
          },
        );
      },
    );
  }

  Widget _buildMutasiKeluargaCard(MutasiKeluarga mutasi) {
    final color = UIHelpers.getMutasiColor(mutasi.jenisMutasi);

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
                      color.withValues(alpha: 0.15),
                      color.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(Icons.swap_horiz_rounded, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mutasi.jenisMutasi.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'KK: ${mutasi.nomorKK}',
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
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  DateFormat('dd/MM/yy').format(mutasi.tanggal),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
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
                  mutasi,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  'Hapus',
                  Icons.delete_outline_rounded,
                  const Color(0xFFE53935),
                  mutasi,
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
    MutasiKeluarga mutasi,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (label == 'Detail') {
            context.pushNamed('admin-mutasi-keluarga-detail', extra: mutasi);
          } else if (label == 'Hapus') {
            _showDeleteConfirmation(mutasi);
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
