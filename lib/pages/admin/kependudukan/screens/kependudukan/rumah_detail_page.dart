import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../colors/app_colors.dart';
import '../../../../../data/models/rumah_model.dart';
import '../../../../../data/models/warga_model.dart';
import '../../../../../data/repositories/rumah_repository.dart';
import '../../../../../data/repositories/warga_repository.dart';
import '../../../../../utils/date_helpers.dart';

class RumahDetailPage extends StatefulWidget {
  final Rumah rumah;

  const RumahDetailPage({super.key, required this.rumah});

  @override
  State<RumahDetailPage> createState() => _RumahDetailPageState();
}

class _RumahDetailPageState extends State<RumahDetailPage> {
  final _repository = RumahRepository();
  final _wargaRepository = WargaRepository();
  bool _isDeleting = false;

  Color _getStatusColor() {
    switch (widget.rumah.status) {
      case StatusRumah.ditempati:
        return Colors.green;
      case StatusRumah.kosong:
        return Colors.orange;
      case StatusRumah.disewakan:
        return Colors.blue;
    }
  }

  String _getStatusText() {
    switch (widget.rumah.status) {
      case StatusRumah.ditempati:
        return 'Ditempati';
      case StatusRumah.kosong:
        return 'Kosong';
      case StatusRumah.disewakan:
        return 'Disewakan';
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
          'Detail Rumah',
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
            const SizedBox(height: 16),
            _buildInfoCard(),
            const SizedBox(height: 16),
            _buildStatusCard(),
            const SizedBox(height: 16),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final statusColor = _getStatusColor();
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
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.home_rounded, color: statusColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.rumah.alamat,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<Warga?>(
                      future: widget.rumah.pemilikId != null
                          ? _wargaRepository.getWargaById(
                              widget.rumah.pemilikId!,
                            )
                          : Future.value(null),
                      builder: (context, snapshot) {
                        final pemilik = snapshot.data;
                        return Text(
                          pemilik != null
                              ? 'Pemilik: ${pemilik.nama}'
                              : 'Pemilik: Belum diatur',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _getStatusText(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
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
          const Text(
            'Informasi Rumah',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Alamat', widget.rumah.alamat),
          const SizedBox(height: 12),
          FutureBuilder<Warga?>(
            future: widget.rumah.pemilikId != null
                ? _wargaRepository.getWargaById(widget.rumah.pemilikId!)
                : Future.value(null),
            builder: (context, snapshot) {
              final pemilik = snapshot.data;
              return _buildInfoRow(
                'Pemilik',
                pemilik != null ? pemilik.nama : 'Belum diatur',
              );
            },
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Status', _getStatusText()),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Tanggal Terdaftar',
            DateHelpers.formatDate(widget.rumah.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final statusColor = _getStatusColor();
    String statusMessage;
    IconData statusIcon;

    switch (widget.rumah.status) {
      case StatusRumah.ditempati:
        statusMessage = 'Rumah sedang ditempati';
        statusIcon = Icons.check_circle;
        break;
      case StatusRumah.kosong:
        statusMessage = 'Rumah dalam keadaan kosong';
        statusIcon = Icons.home_work;
        break;
      case StatusRumah.disewakan:
        statusMessage = 'Rumah sedang disewakan';
        statusIcon = Icons.key;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Rumah',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusMessage,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (_isDeleting) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            'Edit Rumah',
            Icons.edit_outlined,
            Colors.blue,
            () {
              // TODO: Navigate to edit page
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            context,
            'Hapus Rumah',
            Icons.delete_outline,
            Colors.red,
            () => _showDeleteDialog(context),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Hapus Rumah'),
          content: const Text(
            'Apakah Anda yakin ingin menghapus data rumah ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                setState(() {
                  _isDeleting = true;
                });

                try {
                  await _repository.deleteRumah(widget.rumah.id);

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.white),
                          SizedBox(width: 12),
                          Text('Data rumah berhasil dihapus'),
                        ],
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );

                  context.pop();
                } catch (e) {
                  if (!mounted) return;

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
                      duration: const Duration(seconds: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                } finally {
                  if (mounted) {
                    setState(() {
                      _isDeleting = false;
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
