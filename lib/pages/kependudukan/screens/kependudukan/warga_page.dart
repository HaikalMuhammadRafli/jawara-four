import 'package:flutter/material.dart';

import '../../mocks/warga_mocks.dart';
import '../../models/warga_model.dart';

// ==================== DEFINISI WARNA ====================
const Color primaryBlue = Color(0xFF1E88E5);
const Color backgroundWhite = Color(0xFFFFFFFF);
const Color textPrimary = Color(0xFF212121);
const Color textSecondary = Color(0xFF757575);
const Color dividerGray = Color(0xFFE0E0E0);

class WargaPage extends StatelessWidget {
  const WargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundWhite, // Background putih untuk seluruh halaman
      child: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(child: _buildWargaList()),
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
              hintText: 'Cari warga...',
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
                _buildFilterChip('Laki-laki', false),
                const SizedBox(width: 10),
                _buildFilterChip('Perempuan', false),
                const SizedBox(width: 10),
                _buildFilterChip('Kepala Keluarga', false),
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

  Widget _buildWargaList() {
    final List<Warga> wargaData = wargaMock;

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: wargaData.length,
      itemBuilder: (context, index) {
        final warga = wargaData[index];
        return _buildWargaCard(context, warga);
      },
    );
  }

  Widget _buildWargaCard(BuildContext context, Warga warga) {
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
              // Avatar dengan design modern
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: warga.jenisKelamin == 'Laki-laki'
                        ? [
                            primaryBlue.withValues(alpha: 0.15),
                            primaryBlue.withValues(alpha: 0.05),
                          ]
                        : [
                            const Color(0xFFEC407A).withValues(alpha: 0.15),
                            const Color(0xFFEC407A).withValues(alpha: 0.05),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: warga.jenisKelamin == 'Laki-laki'
                        ? primaryBlue.withValues(alpha: 0.3)
                        : const Color(0xFFEC407A).withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  warga.jenisKelamin == 'Laki-laki'
                      ? Icons.person_rounded
                      : Icons.person_outline_rounded,
                  color: warga.jenisKelamin == 'Laki-laki'
                      ? primaryBlue
                      : const Color(0xFFEC407A),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      warga.nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'NIK: ${warga.nik}',
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
                  color: const Color(0xFF43A047).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF43A047).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Aktif',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF43A047),
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
              Icon(Icons.wc_rounded, size: 16, color: textSecondary),
              const SizedBox(width: 8),
              Text(
                warga.jenisKelamin,
                style: TextStyle(
                  fontSize: 13,
                  color: textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              // Action buttons modern
              Container(
                decoration: BoxDecoration(
                  color: dividerGray.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    _showEditDialog(context, warga);
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
                    _showDetailDialog(context, warga);
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

  // Dialog untuk edit warga (tampilan saja)
  void _showEditDialog(BuildContext context, Warga warga) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.edit_rounded, color: primaryBlue, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Edit Warga',
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
              warga.nama,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'NIK: ${warga.nik}',
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

  // Dialog untuk detail warga (tampilan saja)
  void _showDetailDialog(BuildContext context, Warga warga) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.person_rounded, color: primaryBlue, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Detail Warga',
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
            _buildDetailRow('Nama', warga.nama),
            const SizedBox(height: 12),
            _buildDetailRow('NIK', warga.nik),
            const SizedBox(height: 12),
            _buildDetailRow('Jenis Kelamin', warga.jenisKelamin),
            const SizedBox(height: 12),
            _buildDetailRow('Status', 'Aktif'),
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

