import 'package:flutter/material.dart';

import '../../mocks/rumah_mocks.dart';
import '../../models/rumah_model.dart';

// ==================== DEFINISI WARNA ====================
const Color primaryBlue = Color(0xFF1E88E5);
const Color backgroundWhite = Color(0xFFFFFFFF);
const Color textPrimary = Color(0xFF212121);
const Color textSecondary = Color(0xFF757575);
const Color dividerGray = Color(0xFFE0E0E0);

class RumahPage extends StatelessWidget {
  const RumahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundWhite, // Background putih untuk seluruh halaman
      child: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(child: _buildRumahList()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundWhite,
        border: Border(
          bottom: BorderSide(color: dividerGray.withValues(alpha: 0.6), width: 1.5),
        ),
      ),
      child: Column(
        children: [
          // Search field dengan design modern
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari rumah...',
              hintStyle: TextStyle(color: textSecondary, fontSize: 15),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: textSecondary,
                size: 22,
              ),
              filled: true,
              fillColor: dividerGray.withValues(alpha: 0.15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: primaryBlue, width: 1.5),
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
                _buildFilterChip('Semua', true),
                const SizedBox(width: 10),
                _buildFilterChip('Ditempati', false),
                const SizedBox(width: 10),
                _buildFilterChip('Tersedia', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? primaryBlue : backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? primaryBlue : dividerGray.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? backgroundWhite : textSecondary,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildRumahList() {
    final List<Rumah> rumahData = rumahMock;

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: rumahData.length,
      itemBuilder: (context, index) {
        final rumah = rumahData[index];
        return _buildRumahCard(context, rumah);
      },
    );
  }

  Widget _buildRumahCard(BuildContext context, Rumah rumah) {
    Color statusColor = rumah.status == 'Ditempati'
        ? const Color(0xFF43A047)
        : const Color(0xFFE53935);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dividerGray.withValues(alpha: 0.6), width: 1.5),
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
                      primaryBlue.withValues(alpha: 0.15),
                      primaryBlue.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryBlue.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(Icons.home_rounded, color: primaryBlue, size: 24),
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
                        color: textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Pemilik: ${rumah.pemilik}',
                      style: TextStyle(
                        fontSize: 12,
                        color: textSecondary,
                        letterSpacing: 0.2,
                      ),
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
                  rumah.status,
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
          Divider(color: dividerGray.withValues(alpha: 0.5), height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 16, color: textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  rumah.alamat,
                  style: TextStyle(
                    fontSize: 13,
                    color: textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Action buttons modern
              Container(
                decoration: BoxDecoration(
                  color: dividerGray.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    _showEditDialog(context, rumah);
                  },
                  icon: Icon(
                    Icons.edit_rounded,
                    size: 18,
                    color: textSecondary,
                  ),
                  tooltip: 'Edit',
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    _showDetailDialog(context, rumah);
                  },
                  icon: Icon(
                    Icons.visibility_rounded,
                    size: 18,
                    color: primaryBlue,
                  ),
                  tooltip: 'Lihat Detail',
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Dialog untuk edit rumah (tampilan saja)
  void _showEditDialog(BuildContext context, Rumah rumah) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.edit_rounded, color: primaryBlue, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Edit Rumah',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fitur edit untuk:',
              style: TextStyle(color: textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              rumah.alamat,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pemilik: ${rumah.pemilik}',
              style: TextStyle(fontSize: 13, color: textSecondary),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: primaryBlue.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: primaryBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Fitur ini akan segera tersedia',
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
              'Tutup',
              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog untuk detail rumah (tampilan saja)
  void _showDetailDialog(BuildContext context, Rumah rumah) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.home_rounded, color: primaryBlue, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Detail Rumah',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Alamat', rumah.alamat),
            const SizedBox(height: 12),
            _buildDetailRow('Pemilik', rumah.pemilik),
            const SizedBox(height: 12),
            _buildDetailRow('Status', rumah.status),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: primaryBlue.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: primaryBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Detail lengkap akan ditampilkan di halaman khusus',
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
              'Tutup',
              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk menampilkan baris detail
  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            color: textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

