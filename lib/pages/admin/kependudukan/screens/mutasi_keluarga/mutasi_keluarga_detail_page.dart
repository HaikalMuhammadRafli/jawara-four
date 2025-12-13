import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../colors/app_colors.dart';
import '../../../../../data/models/mutasi_keluarga_model.dart';
import '../../../../../data/repositories/mutasi_keluarga_repository.dart';

class MutasiKeluargaDetailPage extends StatefulWidget {
  final MutasiKeluarga mutasi;

  const MutasiKeluargaDetailPage({super.key, required this.mutasi});

  @override
  State<MutasiKeluargaDetailPage> createState() =>
      _MutasiKeluargaDetailPageState();
}

class _MutasiKeluargaDetailPageState extends State<MutasiKeluargaDetailPage> {
  final _repository = MutasiKeluargaRepository();
  bool _isDeleting = false;

  Color _getJenisColor(JenisMutasi jenis) {
    switch (jenis) {
      case JenisMutasi.pindahMasuk:
        return AppColors.success;
      case JenisMutasi.pindahKeluar:
        return Colors.orange;
      case JenisMutasi.pindahAntarRTRW:
        return AppColors.primary;
      case JenisMutasi.kelahiran:
        return Colors.pink;
      case JenisMutasi.kematian:
        return Colors.grey;
    }
  }

  IconData _getJenisIcon(JenisMutasi jenis) {
    switch (jenis) {
      case JenisMutasi.pindahMasuk:
        return Icons.arrow_circle_down_rounded;
      case JenisMutasi.pindahKeluar:
        return Icons.arrow_circle_up_rounded;
      case JenisMutasi.pindahAntarRTRW:
        return Icons.swap_horiz_rounded;
      case JenisMutasi.kelahiran:
        return Icons.child_friendly_rounded;
      case JenisMutasi.kematian:
        return Icons.favorite_border;
    }
  }

  Future<void> _deleteMutasi() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_rounded, color: AppColors.error, size: 28),
            SizedBox(width: 12),
            Text('Hapus Mutasi?'),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus data mutasi ini? Tindakan ini tidak dapat dibatalkan.',
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
      setState(() => _isDeleting = true);

      try {
        await _repository.delete(widget.mutasi.id);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 12),
                Text('Data mutasi berhasil dihapus'),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        context.pop();
      } catch (e) {
        if (!mounted) return;

        setState(() => _isDeleting = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Gagal menghapus: $e')),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: const Text(
          'Detail Mutasi Keluarga',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 24),
            _buildKeluargaInfoCard(),
            const SizedBox(height: 16),
            _buildMutasiDetailCard(),
            const SizedBox(height: 32),
            _buildDeleteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final jenisColor = _getJenisColor(widget.mutasi.jenisMutasi);
    final jenisIcon = _getJenisIcon(widget.mutasi.jenisMutasi);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: jenisColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(jenisIcon, color: jenisColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.mutasi.jenisMutasi.value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat(
                        'dd MMMM yyyy',
                        'id_ID',
                      ).format(widget.mutasi.tanggal),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeluargaInfoCard() {
    return _buildCard(
      title: 'Informasi Keluarga',
      icon: Icons.family_restroom_rounded,
      color: AppColors.primary,
      children: [
        _buildInfoRow('Nomor KK', widget.mutasi.nomorKK, Icons.badge_outlined),
        _buildInfoRow(
          'Kepala Keluarga',
          widget.mutasi.namaKepalaKeluarga,
          Icons.person_outline,
        ),
        _buildInfoRow(
          'Nama Warga',
          widget.mutasi.namaWarga,
          Icons.person_pin_rounded,
        ),
      ],
    );
  }

  Widget _buildMutasiDetailCard() {
    return _buildCard(
      title: 'Detail Mutasi',
      icon: Icons.info_outline_rounded,
      color: _getJenisColor(widget.mutasi.jenisMutasi),
      children: [
        _buildInfoRow(
          'Alamat Asal',
          widget.mutasi.alamatAsal,
          Icons.location_on_outlined,
        ),
        _buildInfoRow(
          'Alamat Tujuan',
          widget.mutasi.alamatTujuan,
          Icons.my_location_rounded,
        ),
        _buildInfoRow(
          'Alasan',
          widget.mutasi.alasan,
          Icons.description_outlined,
        ),
        if (widget.mutasi.keterangan != null &&
            widget.mutasi.keterangan!.isNotEmpty)
          _buildInfoRow(
            'Keterangan',
            widget.mutasi.keterangan!,
            Icons.note_outlined,
          ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: _isDeleting ? Colors.grey : AppColors.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isDeleting ? null : _deleteMutasi,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: _isDeleting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Hapus Mutasi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
