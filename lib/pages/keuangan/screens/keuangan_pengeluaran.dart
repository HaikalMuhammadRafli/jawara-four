import 'package:flutter/material.dart';
import '../mocks/pengeluaran_mocks.dart';
import '../models/pengeluaran_model.dart';

// ==================== DEFINISI WARNA ====================
// Palet warna monokromatik biru untuk konsistensi desain
const Color primaryBlue = Color(0xFF1E88E5); // Biru utama #1E88E5
const Color darkBlue = Color(0xFF1565C0); // Biru gelap untuk emphasis
const Color lightBlue = Color(0xFFE3F2FD); // Biru sangat muda untuk background
const Color backgroundWhite = Color(0xFFFFFFFF); // Putih untuk card
const Color backgroundGray = Color(
  0xFFF8F9FA,
); // Abu-abu lembut untuk background
const Color textPrimary = Color(0xFF212121); // Hitam untuk teks utama
const Color textSecondary = Color(0xFF757575); // Abu-abu untuk teks sekunder
const Color textTertiary = Color(0xFF9E9E9E); // Abu-abu muda untuk teks tersier
const Color dividerGray = Color(0xFFE0E0E0); // Abu-abu untuk border/divider

class KeuanganPengeluaranPage extends StatelessWidget {
  const KeuanganPengeluaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(
        0xFFFFFFFF,
      ), // Background putih untuk keseluruhan halaman
      child: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildPengeluaranList()),
            ],
          ),
          // Floating Action Button dengan desain yang lebih elegant
          Positioned(
            right: 24,
            bottom: 24,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
              ),
              child: FloatingActionButton.extended(
                onPressed: () {
                  _showTambahPengeluaranDialog(context);
                },
                backgroundColor: primaryBlue,
                elevation: 0,
                icon: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                label: const Text(
                  'Tambah',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== HEADER: TOTAL PENGELUARAN & SEARCH ====================
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      decoration: BoxDecoration(
        color: backgroundWhite,
        border: Border.all(color: dividerGray.withValues(alpha: 0.6), width: 1.5),
      ),
      child: Column(
        children: [
          // Card Total Pengeluaran dengan desain yang lebih elegant
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [primaryBlue, darkBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Icon trending down dengan styling yang lebih refined
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_downward_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Total Pengeluaran',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Rp 2.500.000',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -1.5,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Search Field dengan desain yang lebih subtle dan elegant
          Container(
            decoration: BoxDecoration(
              color: backgroundGray,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: dividerGray.withValues(alpha: 0.3), width: 1),
            ),
            child: TextField(
              style: const TextStyle(
                fontSize: 14,
                color: textPrimary,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Cari pengeluaran...',
                hintStyle: TextStyle(
                  color: textSecondary.withValues(alpha: 0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 12),
                  child: Icon(
                    Icons.search_rounded,
                    color: textSecondary.withValues(alpha: 0.5),
                    size: 22,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 50,
                  minHeight: 50,
                ),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: primaryBlue.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                enabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== LIST PENGELUARAN ====================
  Widget _buildPengeluaranList() {
    final List<Pengeluaran> pengeluaranData = pengeluaranMock;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
      itemCount: pengeluaranData.length,
      itemBuilder: (context, index) {
        final pengeluaran = pengeluaranData[index];
        return _buildPengeluaranCard(pengeluaran);
      },
    );
  }

  // ==================== CARD ITEM PENGELUARAN ====================
  Widget _buildPengeluaranCard(Pengeluaran pengeluaran) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: dividerGray.withValues(alpha: 0.6), width: 1.5),
      ),
      child: Column(
        children: [
          // Bagian utama dengan info pengeluaran
          Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                // Icon dalam container dengan background biru gradient
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryBlue.withValues(alpha: 0.1),
                        primaryBlue.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: primaryBlue.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: primaryBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 18),
                // Detail pengeluaran (nama dan jenis)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pengeluaran.nama,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                          letterSpacing: -0.4,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: lightBlue.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              pengeluaran.jenis,
                              style: TextStyle(
                                fontSize: 11,
                                color: darkBlue,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Nominal dan tanggal
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      pengeluaran.nominal,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: primaryBlue,
                        letterSpacing: -0.5,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 11,
                          color: textTertiary.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pengeluaran.tanggal,
                          style: TextStyle(
                            fontSize: 12,
                            color: textTertiary.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Divider dengan gradient subtle
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  dividerGray.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Action buttons dengan desain yang lebih refined
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: [
                // Button Edit
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.edit_outlined,
                    label: 'Edit',
                    color: textSecondary,
                    onPressed: () {},
                  ),
                ),
                // Vertical divider
                Container(
                  width: 1,
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        dividerGray.withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // Button Detail
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.visibility_outlined,
                    label: 'Detail',
                    color: textSecondary,
                    onPressed: () {},
                  ),
                ),
                // Vertical divider
                Container(
                  width: 1,
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        dividerGray.withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // Button Hapus
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.delete_outline_rounded,
                    label: 'Hapus',
                    color: primaryBlue,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk action button
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== DIALOG TAMBAH PENGELUARAN ====================
  void _showTambahPengeluaranDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add_circle_outline,
                  color: primaryBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tambah Pengeluaran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          content: const Text(
            'Fitur tambah pengeluaran akan segera tersedia',
            style: TextStyle(fontSize: 14, color: textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                backgroundColor: primaryBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

