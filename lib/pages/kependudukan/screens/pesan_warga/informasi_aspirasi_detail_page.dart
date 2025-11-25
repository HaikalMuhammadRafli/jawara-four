import 'package:flutter/material.dart';

import '../../../../data/models/aspirasi_model.dart';
import '../../../../utils/date_helpers.dart';

class InformasiAspirasiDetailPage extends StatelessWidget {
  final Aspirasi aspirasi;

  const InformasiAspirasiDetailPage({super.key, required this.aspirasi});

  Color _getStatusColor() {
    switch (aspirasi.status.value.toLowerCase()) {
      case 'diterima':
        return const Color(0xFF43A047);
      case 'diproses':
        return const Color(0xFFFB8C00);
      case 'ditolak':
        return const Color(0xFFE53935);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, statusColor),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 16),
                  _buildSenderCard(),
                  const SizedBox(height: 16),
                  _buildContentCard(),
                  const SizedBox(height: 16),
                  _buildStatusCard(statusColor),
                  const SizedBox(height: 16),
                  _buildActionButtons(context, statusColor),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Color statusColor) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: statusColor,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          padding: EdgeInsets.zero,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              // TODO: Implement bookmark functionality
            },
            icon: const Icon(Icons.bookmark_border, color: Colors.black87),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [statusColor, statusColor.withValues(alpha: 0.7)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -50,
                top: -50,
                child: Icon(
                  Icons.message_rounded,
                  size: 200,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 3),
                      ),
                      child: const Icon(Icons.message_rounded, size: 52, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'INFORMASI & ASPIRASI',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Judul',
                style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            aspirasi.judul,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSenderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF7E57C2).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.person_outline, color: Color(0xFF7E57C2), size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pengirim',
                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  aspirasi.pengirim,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.verified_user, color: Colors.blue, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description_outlined, color: const Color(0xFF7E57C2), size: 22),
              const SizedBox(width: 8),
              const Text(
                'Isi Pesan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: const Text(
              'Isi pesan atau aspirasi dari warga akan ditampilkan di sini. Saat ini data hanya berisi judul, pengirim, tanggal, dan status. Anda dapat menambahkan field "isi" atau "deskripsi" pada model untuk menampilkan konten lengkap aspirasi.',
              style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Status',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          _buildMetadataItem(
            Icons.calendar_today_outlined,
            'Tanggal Dibuat',
            DateHelpers.formatDate(aspirasi.tanggalDibuat),
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildMetadataItem(_getStatusIcon(), 'Status', aspirasi.status.value, statusColor),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withValues(alpha: 0.2), width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: statusColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getStatusDescription(),
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataItem(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (aspirasi.status.value.toLowerCase()) {
      case 'diterima':
        return Icons.check_circle;
      case 'diproses':
        return Icons.autorenew;
      case 'ditolak':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusDescription() {
    switch (aspirasi.status.value.toLowerCase()) {
      case 'diterima':
        return 'Aspirasi telah diterima dan akan ditindaklanjuti';
      case 'diproses':
        return 'Aspirasi sedang dalam proses peninjauan';
      case 'ditolak':
        return 'Aspirasi tidak dapat ditindaklanjuti';
      default:
        return 'Status tidak diketahui';
    }
  }

  Widget _buildActionButtons(BuildContext context, Color statusColor) {
    if (aspirasi.status.value.toLowerCase() == 'diproses') {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Terima',
                  Icons.check_circle_outline,
                  const Color(0xFF43A047),
                  () {
                    _showConfirmDialog(
                      context,
                      'Terima Aspirasi',
                      'Apakah Anda yakin ingin menerima aspirasi ini?',
                      const Color(0xFF43A047),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Tolak',
                  Icons.cancel_outlined,
                  const Color(0xFFE53935),
                  () {
                    _showConfirmDialog(
                      context,
                      'Tolak Aspirasi',
                      'Apakah Anda yakin ingin menolak aspirasi ini?',
                      const Color(0xFFE53935),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActionButton('Balas Pesan', Icons.reply_outlined, Colors.blue, () {
            // TODO: Navigate to reply page
          }),
        ],
      );
    } else {
      return Column(
        children: [
          _buildActionButton('Balas Pesan', Icons.reply_outlined, Colors.blue, () {
            // TODO: Navigate to reply page
          }),
          const SizedBox(height: 12),
          _buildActionButton('Ubah Status', Icons.edit_outlined, Colors.orange, () {
            // TODO: Navigate to edit status page
          }),
        ],
      );
    }
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, String title, String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.help_outline, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 18))),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to previous page
                // TODO: Implement accept/reject functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Ya, Lanjutkan',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
