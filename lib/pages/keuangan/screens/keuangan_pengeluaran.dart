import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../../data/models/pengeluaran_model.dart';
import '../../../data/repositories/pengeluaran_repository.dart';
import '../../../utils/date_helpers.dart';
import '../../../utils/number_helpers.dart';
import 'keuangan_pengeluaran_form_page.dart';

class KeuanganPengeluaranPage extends StatelessWidget {
  const KeuanganPengeluaranPage({super.key});

  // Instance repository untuk akses data pengeluaran dari Firestore
  static final PengeluaranRepository _repository = PengeluaranRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFFFF),
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
                heroTag: null,
                onPressed: () {
                  context.pushNamed('keuangan-pengeluaran-form');
                },
                backgroundColor: AppColors.primary,
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
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
              color: AppColors.backgroundGray,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.divider.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: TextField(
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Cari pengeluaran...',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 12),
                  child: Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
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
                    color: AppColors.primary.withValues(alpha: 0.5),
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
    // Menggunakan StreamBuilder untuk mendapatkan data real-time dari Firestore
    return StreamBuilder<List<Pengeluaran>>(
      stream: _repository.getPengeluaranStream(),
      builder: (context, snapshot) {
        // Loading state - tampilkan loading indicator saat data sedang dimuat
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        // Error state - tampilkan pesan error jika terjadi kesalahan
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Terjadi kesalahan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Empty state - tampilkan pesan jika tidak ada data
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 64,
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada data pengeluaran',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap tombol + untuk menambah data',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        // Success state - tampilkan list data pengeluaran
        final pengeluaranData = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
          itemCount: pengeluaranData.length,
          itemBuilder: (context, index) {
            final pengeluaran = pengeluaranData[index];
            return _buildPengeluaranCard(context, pengeluaran);
          },
        );
      },
    );
  }

  // ==================== CARD ITEM PENGELUARAN ====================
  Widget _buildPengeluaranCard(BuildContext context, Pengeluaran pengeluaran) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.6),
          width: 1.5,
        ),
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
                        AppColors.primary.withValues(alpha: 0.1),
                        AppColors.primary.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: AppColors.primary,
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
                          color: AppColors.textPrimary,
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
                              color: AppColors.primaryLight.withValues(
                                alpha: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              pengeluaran.jenis,
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.primaryDark,
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
                      NumberHelpers.formatCurrency(pengeluaran.nominal),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
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
                          color: AppColors.textHint.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateHelpers.formatDateShort(pengeluaran.tanggal),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint.withValues(alpha: 0.8),
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
                  AppColors.divider.withValues(alpha: 0.3),
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
                // Button Edit - membuka form page untuk edit
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.edit_outlined,
                    label: 'Edit',
                    color: AppColors.textSecondary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KeuanganPengeluaranFormPage(
                            pengeluaran: pengeluaran,
                          ),
                        ),
                      );
                    },
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
                        AppColors.divider.withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // Button Detail - saat ini hanya placeholder
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.visibility_outlined,
                    label: 'Detail',
                    color: AppColors.textSecondary,
                    onPressed: () {
                      // TODO: Implement detail view
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Fitur detail akan segera tersedia',
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
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
                        AppColors.divider.withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // Button Hapus - menampilkan dialog konfirmasi sebelum menghapus
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.delete_outline_rounded,
                    label: 'Hapus',
                    color: AppColors.primary,
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, pengeluaran);
                    },
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

  // ==================== DIALOG TAMBAH/EDIT PENGELUARAN ====================
  /// Menampilkan dialog untuk menambah atau mengedit data pengeluaran
  /// [context] - BuildContext dari widget pemanggil
  /// [pengeluaran] - Data pengeluaran yang akan diedit (null jika tambah baru)
  static void _showTambahPengeluaranDialog(
    BuildContext context, [
    Pengeluaran? pengeluaran,
  ]) {
    // Controller untuk form input
    final namaController = TextEditingController(text: pengeluaran?.nama ?? '');
    final jenisController = TextEditingController(
      text: pengeluaran?.jenis ?? '',
    );
    final nominalController = TextEditingController(
      text: pengeluaran != null ? pengeluaran.nominal.toString() : '',
    );
    DateTime selectedDate = pengeluaran?.tanggal ?? DateTime.now();

    // Variabel untuk menyimpan tanggal yang dipilih dalam StatefulBuilder
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.zero,
              content: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header dialog dengan icon dan judul
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.1),
                                  AppColors.primary.withValues(alpha: 0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Icon(
                              pengeluaran == null
                                  ? Icons.add_circle_outline
                                  : Icons.edit_outlined,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            pengeluaran == null
                                ? 'Tambah Pengeluaran'
                                : 'Edit Pengeluaran',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Form input nama pengeluaran
                      _buildInputLabel('Nama Pengeluaran'),
                      TextField(
                        controller: namaController,
                        decoration: _buildInputDecoration(
                          hint: 'Contoh: Gaji Perangkat Desa',
                          icon: Icons.receipt_long_rounded,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Form input jenis pengeluaran
                      _buildInputLabel('Jenis Pengeluaran'),
                      TextField(
                        controller: jenisController,
                        decoration: _buildInputDecoration(
                          hint: 'Contoh: Operasional',
                          icon: Icons.category_outlined,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Form input nominal
                      _buildInputLabel('Nominal (Rp)'),
                      TextField(
                        controller: nominalController,
                        keyboardType: TextInputType.number,
                        decoration: _buildInputDecoration(
                          hint: 'Contoh: 5000000',
                          icon: Icons.payments_outlined,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Form input tanggal dengan date picker
                      _buildInputLabel('Tanggal'),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppColors.primary,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null && picked != selectedDate) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.divider.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 18,
                                color: AppColors.primary.withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                DateHelpers.formatDate(selectedDate),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action buttons (Batal & Simpan)
                      Row(
                        children: [
                          // Button Batal
                          Expanded(
                            child: TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: AppColors.divider.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Batal',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Button Simpan
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Validasi input
                                if (namaController.text.isEmpty ||
                                    jenisController.text.isEmpty ||
                                    nominalController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Mohon lengkapi semua field',
                                      ),
                                      backgroundColor: Colors.red.shade400,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  // Parse nominal ke integer
                                  final nominal = int.tryParse(
                                    nominalController.text,
                                  );
                                  if (nominal == null || nominal <= 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Nominal harus berupa angka valid',
                                        ),
                                        backgroundColor: Colors.red.shade400,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  // Jika mode edit, update data existing
                                  if (pengeluaran != null) {
                                    final updatedPengeluaran = pengeluaran
                                        .copyWith(
                                          nama: namaController.text.trim(),
                                          jenis: jenisController.text.trim(),
                                          nominal: nominal,
                                          tanggal: selectedDate,
                                        );
                                    await _repository.updatePengeluaran(
                                      updatedPengeluaran,
                                    );
                                  } else {
                                    // Jika mode tambah, buat data baru
                                    final newPengeluaran = Pengeluaran(
                                      id: '', // Firestore akan generate ID otomatis
                                      nama: namaController.text.trim(),
                                      jenis: jenisController.text.trim(),
                                      nominal: nominal,
                                      tanggal: selectedDate,
                                      createdAt: DateTime.now(),
                                      updatedAt: DateTime.now(),
                                    );
                                    await _repository.addPengeluaran(
                                      newPengeluaran,
                                    );
                                  }

                                  // Tutup dialog
                                  Navigator.of(dialogContext).pop();

                                  // Tampilkan snackbar sukses
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        pengeluaran == null
                                            ? 'Data pengeluaran berhasil ditambahkan'
                                            : 'Data pengeluaran berhasil diperbarui',
                                      ),
                                      backgroundColor: Colors.green.shade400,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  // Handle error
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Gagal menyimpan data: $e'),
                                      backgroundColor: Colors.red.shade400,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Simpan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Helper untuk membuat label input field
  static Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  // Helper untuk membuat decoration input field
  static InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 14,
        color: AppColors.textHint.withValues(alpha: 0.6),
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Icon(
        icon,
        size: 20,
        color: AppColors.primary.withValues(alpha: 0.6),
      ),
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.divider.withValues(alpha: 0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.divider.withValues(alpha: 0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  // ==================== DIALOG KONFIRMASI HAPUS ====================
  /// Menampilkan dialog konfirmasi sebelum menghapus data pengeluaran
  /// [context] - BuildContext dari widget pemanggil
  /// [pengeluaran] - Data pengeluaran yang akan dihapus
  static void _showDeleteConfirmationDialog(
    BuildContext context,
    Pengeluaran pengeluaran,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon warning dengan background merah
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red.shade100, width: 2),
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red.shade400,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                // Judul konfirmasi
                const Text(
                  'Hapus Pengeluaran?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                // Detail pengeluaran yang akan dihapus
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.divider.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pengeluaran.nama,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pengeluaran.jenis,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                          Text(
                            NumberHelpers.formatCurrency(pengeluaran.nominal),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Pesan peringatan
                Text(
                  'Data yang sudah dihapus tidak dapat dikembalikan',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Action buttons
                Row(
                  children: [
                    // Button Batal
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: AppColors.divider.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Button Hapus
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            // Hapus data dari Firestore
                            await _repository.deletePengeluaran(pengeluaran.id);

                            // Tutup dialog
                            Navigator.of(dialogContext).pop();

                            // Tampilkan snackbar sukses
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Data pengeluaran berhasil dihapus',
                                ),
                                backgroundColor: Colors.green.shade400,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          } catch (e) {
                            // Handle error
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gagal menghapus data: $e'),
                                backgroundColor: Colors.red.shade400,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Hapus',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
