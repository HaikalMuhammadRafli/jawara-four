import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../colors/app_colors.dart';
import '../../../../../data/models/warga_model.dart';
import '../../../../../data/repositories/warga_repository.dart';

class WargaDetailPage extends StatefulWidget {
  final Warga warga;

  const WargaDetailPage({super.key, required this.warga});

  @override
  State<WargaDetailPage> createState() => _WargaDetailPageState();
}

class _WargaDetailPageState extends State<WargaDetailPage> {
  final _repository = WargaRepository();
  bool _isDeleting = false;

  Future<void> _deleteWarga() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_rounded, color: AppColors.error, size: 28),
            SizedBox(width: 12),
            Text('Hapus Warga?'),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus data warga "${widget.warga.nama}"? Tindakan ini tidak dapat dibatalkan.',
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
        await _repository.deleteWarga(widget.warga.id);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 12),
                Text('Data warga berhasil dihapus'),
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
          'Detail Warga',
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
            _buildPersonalInfoCard(),
            const SizedBox(height: 16),
            _buildContactInfoCard(),
            const SizedBox(height: 16),
            _buildKependudukanInfoCard(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.warga.jenisKelamin == JenisKelamin.lakiLaki
                  ? Icons.male
                  : Icons.female,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.warga.nama,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'NIK: ${widget.warga.nik}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,

                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return _buildCard(
      title: 'Data Pribadi',
      icon: Icons.person_outline_rounded,
      children: [
        _buildInfoRow(
          'Tempat Lahir',
          widget.warga.tempatLahir ?? 'Tidak diketahui',
          Icons.place_outlined,
        ),
        _buildInfoRow(
          'Tanggal Lahir',
          DateFormat('dd MMMM yyyy', 'id_ID').format(widget.warga.tanggalLahir),
          Icons.cake_outlined,
        ),
        _buildInfoRow(
          'Jenis Kelamin',
          widget.warga.jenisKelamin.value,
          Icons.wc_rounded,
        ),
        _buildInfoRow(
          'Status Perkawinan',
          widget.warga.statusPerkawinan.value,
          Icons.favorite_border_rounded,
        ),
      ],
    );
  }

  Widget _buildContactInfoCard() {
    return _buildCard(
      title: 'Data Kontak',
      icon: Icons.contact_phone_outlined,
      children: [
        _buildInfoRow('Email', widget.warga.email, Icons.email_outlined),
        _buildInfoRow(
          'Nomor Telepon',
          widget.warga.noTelepon,
          Icons.phone_outlined,
        ),
      ],
    );
  }

  Widget _buildKependudukanInfoCard() {
    return _buildCard(
      title: 'Data Kependudukan',
      icon: Icons.badge_outlined,
      children: [
        _buildInfoRow(
          'Pekerjaan',
          widget.warga.pekerjaan ?? 'Tidak diketahui',
          Icons.work_outline_rounded,
        ),
        _buildInfoRow(
          'Pendidikan',
          widget.warga.pendidikan?.value ?? 'Tidak diketahui',
          Icons.school_outlined,
        ),
        _buildInfoRow(
          'Alamat',
          widget.warga.alamat ?? 'Belum ditentukan',
          Icons.home_outlined,
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
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
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: AppColors.primary),
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.pushNamed('admin-warga-form', extra: widget.warga);
                },
                borderRadius: BorderRadius.circular(12),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Edit',
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
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: _isDeleting ? Colors.grey : AppColors.error,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isDeleting ? null : _deleteWarga,
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
                            Icon(
                              Icons.delete_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Hapus',
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
          ),
        ),
      ],
    );
  }
}
