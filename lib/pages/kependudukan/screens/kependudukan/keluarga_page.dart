import 'package:flutter/material.dart';

import '../../mocks/keluarga_mocks.dart';
import '../../models/keluarga_model.dart';

// ==================== DEFINISI WARNA ====================
const Color primaryBlue = Color(0xFF1E88E5);
const Color backgroundWhite = Color(0xFFFFFFFF);
const Color textPrimary = Color(0xFF212121);
const Color textSecondary = Color(0xFF757575);
const Color dividerGray = Color(0xFFE0E0E0);

class KeluargaPage extends StatelessWidget {
  const KeluargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundWhite, // Background putih untuk seluruh halaman
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
        color: backgroundWhite,
        border: Border(
          bottom: BorderSide(color: dividerGray.withOpacity(0.6), width: 1.5),
        ),
      ),
      child: Column(
        children: [
          // Search field dengan design modern
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari keluarga...',
              hintStyle: TextStyle(color: textSecondary, fontSize: 15),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: textSecondary,
                size: 22,
              ),
              filled: true,
              fillColor: dividerGray.withOpacity(0.15),
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
                _buildFilterChip('Kepemilikan', false),
                const SizedBox(width: 10),
                _buildFilterChip('Sewa', false),
                const SizedBox(width: 10),
                _buildFilterChip('Kontrak', false),
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
          color: isSelected ? primaryBlue : dividerGray.withOpacity(0.6),
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

  Widget _buildKeluargaList() {
    final List<Keluarga> keluargaData = keluargaMock;

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: keluargaData.length,
      itemBuilder: (context, index) {
        final keluarga = keluargaData[index];
        return _buildKeluargaCard(context, keluarga);
      },
    );
  }

  Widget _buildKeluargaCard(BuildContext context, Keluarga keluarga) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dividerGray.withOpacity(0.6), width: 1.5),
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
                      primaryBlue.withOpacity(0.15),
                      primaryBlue.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: primaryBlue.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.family_restroom_rounded,
                  color: primaryBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      keluarga.kepalaKeluarga,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${keluarga.jumlahAnggota} Anggota',
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
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: primaryBlue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Aktif',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: primaryBlue,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: dividerGray.withOpacity(0.5), height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 16, color: textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  keluarga.alamat,
                  style: TextStyle(
                    fontSize: 13,
                    color: textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              // Action buttons modern
              Container(
                decoration: BoxDecoration(
                  color: dividerGray.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    _showEditDialog(context, keluarga);
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
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    _showDetailDialog(context, keluarga);
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

  // Dialog untuk edit keluarga (tampilan saja)
  void _showEditDialog(BuildContext context, Keluarga keluarga) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.edit_rounded, color: primaryBlue, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Edit Keluarga',
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
              keluarga.kepalaKeluarga,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${keluarga.jumlahAnggota} Anggota',
              style: TextStyle(fontSize: 13, color: textSecondary),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: primaryBlue.withOpacity(0.2),
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

  // Dialog untuk detail keluarga (tampilan saja)
  void _showDetailDialog(BuildContext context, Keluarga keluarga) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.family_restroom_rounded, color: primaryBlue, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Detail Keluarga',
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
            _buildDetailRow('Kepala Keluarga', keluarga.kepalaKeluarga),
            const SizedBox(height: 12),
            _buildDetailRow(
              'Jumlah Anggota',
              '${keluarga.jumlahAnggota} Orang',
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Alamat', keluarga.alamat),
            const SizedBox(height: 12),
            _buildDetailRow('Status', 'Aktif'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: primaryBlue.withOpacity(0.2),
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
