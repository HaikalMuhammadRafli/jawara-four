import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Halaman Laporan Keuangan
/// Menampilkan ringkasan keuangan, statistik, dan riwayat transaksi
class LaporanKeuanganPage extends StatelessWidget {
  const LaporanKeuanganPage({super.key});

  // ==================== COLOR PALETTE ====================
  // Palet warna monokromatik elegan dengan aksen biru

  /// Warna biru utama untuk aksen dan elemen penting
  static const Color primaryBlue = Color(0xFF1E88E5);

  /// Warna biru gelap untuk gradient
  static const Color darkBlue = Color(0xFF1565C0);

  /// Warna biru muda untuk background elemen
  static const Color lightBlue = Color(0xFFE3F2FD);

  /// Warna teks utama (hitam)
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// Warna teks sekunder (abu-abu sedang)
  static const Color textSecondary = Color(0xFF6B7280);

  /// Warna teks tersier (abu-abu muda)
  static const Color textTertiary = Color(0xFF9CA3AF);

  /// Background putih untuk card
  static const Color backgroundWhite = Color(0xFFFFFFFF);

  /// Background abu-abu untuk halaman dan elemen
  static const Color backgroundGray = Color(0xFFF9FAFB);

  /// Warna untuk divider dan border
  static const Color dividerGray = Color(0xFFE5E7EB);

  // ==================== BUILD METHOD ====================
  /// Method utama untuk membangun tampilan halaman
  @override
  Widget build(BuildContext context) {
    return Container(
      // Background putih untuk seluruh halaman
      color: const Color(0xFFFFFFFF),
      child: SingleChildScrollView(
        // Padding 20px di semua sisi
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. Card Ringkasan Keuangan (Saldo, Pemasukan, Pengeluaran)
            _buildSummaryCard(),
            const SizedBox(height: 20),

            // 2. Statistik dan Insight Cards
            _buildStatsSection(),
            const SizedBox(height: 20),

            // 3. Card Riwayat Transaksi (List transaksi)
            _buildTransactionHistory(),
          ],
        ),
      ),
    );
  }

  // ==================== SECTION 1: RINGKASAN KEUANGAN ====================
  /// Widget untuk menampilkan ringkasan keuangan
  /// Berisi: Saldo Akhir, Pemasukan, dan Pengeluaran
  /// UBAH DI SINI: Untuk mengubah nominal saldo, pemasukan, atau pengeluaran
  Widget _buildSummaryCard() {
    // Formatter untuk format mata uang Indonesia (Rp)
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      width: double.infinity,
      // === DEKORASI CARD UTAMA ===
      decoration: BoxDecoration(
        color: backgroundWhite, // UBAH BACKGROUND CARD: Ganti backgroundWhite
        borderRadius: BorderRadius.circular(
          20,
        ), // UBAH SUDUT CARD: Ubah angka 20
        border: Border.all(
          color: dividerGray,
          width: 1,
        ), // UBAH BORDER: Warna & ketebalan
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), // UBAH SHADOW: Ubah opacity
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          20,
        ), // UBAH PADDING DALAM CARD: Ubah angka 28
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER: Judul "Ringkasan Keuangan" ---
            Row(
              children: [
                // Bar biru di sebelah kiri judul (accent indicator)
                Container(
                  width: 4, // UBAH LEBAR BAR: Ubah angka 4
                  height: 24, // UBAH TINGGI BAR: Ubah angka 24
                  decoration: BoxDecoration(
                    color: primaryBlue, // UBAH WARNA BAR: Ganti primaryBlue
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                // Teks judul
                const Text(
                  'Ringkasan Keuangan', // UBAH JUDUL: Ganti teks ini
                  style: TextStyle(
                    fontSize: 20, // UBAH UKURAN FONT JUDUL: Ubah angka 20
                    fontWeight: FontWeight.w700,
                    color: textPrimary, // UBAH WARNA JUDUL: Ganti textPrimary
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- SALDO AKHIR: Display utama ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              // Dekorasi box saldo akhir
              decoration: BoxDecoration(
                color:
                    backgroundGray, // UBAH BACKGROUND SALDO: Ganti backgroundGray
                borderRadius: BorderRadius.circular(16), // UBAH SUDUT BOX SALDO
                border: Border.all(
                  color: dividerGray,
                  width: 1,
                ), // UBAH BORDER: Warna & ketebalan
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon dan label "Saldo Akhir"
                  Row(
                    children: [
                      // Icon wallet dalam circle biru
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(
                            0.1,
                          ), // UBAH BACKGROUND ICON
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons
                              .account_balance_wallet_outlined, // UBAH ICON SALDO
                          color: primaryBlue, // UBAH WARNA ICON
                          size: 20, // UBAH UKURAN ICON
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Label "Saldo Akhir"
                      const Text(
                        'Saldo Akhir', // UBAH LABEL: Ganti teks
                        style: TextStyle(
                          fontSize: 13, // UBAH UKURAN FONT LABEL
                          fontWeight: FontWeight.w500,
                          color: textSecondary, // UBAH WARNA LABEL
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // ⭐ UBAH NOMINAL SALDO AKHIR: Ganti angka 15000000 ⭐
                  Text(
                    formatter.format(
                      15000000,
                    ), // << UBAH ANGKA INI untuk nominal saldo
                    style: const TextStyle(
                      fontSize: 34, // UBAH UKURAN FONT NOMINAL SALDO
                      fontWeight: FontWeight.w800,
                      color: textPrimary, // UBAH WARNA NOMINAL
                      letterSpacing: -1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- PEMASUKAN & PENGELUARAN: Row dengan 2 card ---
            Row(
              children: [
                // CARD PEMASUKAN (Kiri)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(
                      12,
                    ), // UBAH PADDING CARD PEMASUKAN
                    // Dekorasi card pemasukan (biru lembut)
                    decoration: BoxDecoration(
                      color: primaryBlue.withOpacity(
                        0.08,
                      ), // UBAH BACKGROUND PEMASUKAN
                      borderRadius: BorderRadius.circular(
                        14,
                      ), // UBAH SUDUT CARD PEMASUKAN
                      border: Border.all(
                        color: primaryBlue.withOpacity(
                          0.2,
                        ), // UBAH BORDER PEMASUKAN
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon dan label "Pemasukan"
                        Row(
                          children: [
                            // Icon trending up dalam square biru
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color:
                                    primaryBlue, // UBAH BACKGROUND ICON PEMASUKAN
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons
                                    .trending_up_rounded, // UBAH ICON PEMASUKAN
                                color: Colors.white, // UBAH WARNA ICON
                                size: 16, // UBAH UKURAN ICON
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Pemasukan', // UBAH LABEL: Ganti teks
                              style: TextStyle(
                                fontSize: 12, // UBAH UKURAN FONT LABEL
                                color: textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // ⭐ UBAH NOMINAL PEMASUKAN: Ganti angka 5000000 ⭐
                        Text(
                          formatter.format(
                            5000000,
                          ), // << UBAH ANGKA INI untuk nominal pemasukan
                          style: const TextStyle(
                            fontSize: 18, // UBAH UKURAN FONT NOMINAL
                            fontWeight: FontWeight.w700,
                            color: textPrimary, // UBAH WARNA NOMINAL
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ), // UBAH JARAK ANTAR CARD: Ubah angka 16
                // CARD PENGELUARAN (Kanan)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(
                      12,
                    ), // UBAH PADDING CARD PENGELUARAN
                    // Dekorasi card pengeluaran (abu-abu)
                    decoration: BoxDecoration(
                      color: backgroundGray, // UBAH BACKGROUND PENGELUARAN
                      borderRadius: BorderRadius.circular(
                        14,
                      ), // UBAH SUDUT CARD PENGELUARAN
                      border: Border.all(
                        color: dividerGray,
                        width: 1,
                      ), // UBAH BORDER
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon dan label "Pengeluaran"
                        Row(
                          children: [
                            // Icon trending down dalam square abu
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: textSecondary.withOpacity(
                                  0.2,
                                ), // UBAH BACKGROUND ICON
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons
                                    .trending_down_rounded, // UBAH ICON PENGELUARAN
                                color: textSecondary, // UBAH WARNA ICON
                                size: 16, // UBAH UKURAN ICON
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Pengeluaran', // UBAH LABEL: Ganti teks
                              style: TextStyle(
                                fontSize: 12, // UBAH UKURAN FONT LABEL
                                color: textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // ⭐ UBAH NOMINAL PENGELUARAN: Ganti angka 2500000 ⭐
                        Text(
                          formatter.format(
                            2500000,
                          ), // << UBAH ANGKA INI untuk nominal pengeluaran
                          style: const TextStyle(
                            fontSize: 18, // UBAH UKURAN FONT NOMINAL
                            fontWeight: FontWeight.w700,
                            color: textPrimary, // UBAH WARNA NOMINAL
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SECTION 2: KATEGORI & INSIGHT ====================
  /// Widget untuk menampilkan kategori pengeluaran dan insight bulanan
  /// UBAH DI SINI: Untuk menambah/mengurangi kategori atau mengubah data kategori
  Widget _buildStatsSection() {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Column(
      children: [
        // Card: Kategori Pengeluaran
        Container(
          width: double.infinity,
          // UBAH WARNA BACKGROUND CARD: Ganti 'backgroundWhite' dengan warna lain
          decoration: BoxDecoration(
            color: backgroundWhite,
            borderRadius: BorderRadius.circular(
              20,
            ), // UBAH BORDER RADIUS: Ubah angka 20
            border: Border.all(
              color: dividerGray,
              width: 1,
            ), // UBAH BORDER: Warna & ketebalan
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                spreadRadius: 0,
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(28), // UBAH PADDING: Ubah angka 28
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER: Judul Section ---
                Row(
                  children: [
                    // Bar biru di sebelah kiri (accent indicator)
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: primaryBlue, // UBAH WARNA BAR: Ganti primaryBlue
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Kategori Pengeluaran', // UBAH JUDUL: Ganti teks ini
                      style: TextStyle(
                        fontSize: 20, // UBAH UKURAN FONT JUDUL: Ubah angka 20
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- LIST KATEGORI ---
                // UBAH DATA KATEGORI: Modifikasi parameter di bawah ini

                // Kategori 1: Infrastruktur
                _buildCategoryItem(
                  'Infrastruktur', // Parameter 1: Nama kategori
                  formatter.format(
                    2000000,
                  ), // Parameter 2: Nominal (dalam rupiah)
                  Icons.construction_rounded, // Parameter 3: Icon
                  0.8, // Parameter 4: Persentase (0.0 - 1.0)
                ),
                const SizedBox(height: 16), // Jarak antar item kategori
                // Kategori 2: Operasional
                _buildCategoryItem(
                  'Operasional', // Ubah nama kategori
                  formatter.format(300000), // Ubah nominal
                  Icons.settings_rounded, // Ubah icon
                  0.12, // Ubah persentase (12%)
                ),
                const SizedBox(height: 16),

                // Kategori 3: Sosial & Acara
                _buildCategoryItem(
                  'Sosial & Acara',
                  formatter.format(150000),
                  Icons.celebration_rounded,
                  0.06, // 6%
                ),
                const SizedBox(height: 16),

                // Kategori 4: Lainnya
                _buildCategoryItem(
                  'Lainnya',
                  formatter.format(50000),
                  Icons.more_horiz_rounded,
                  0.02, // 2%
                ),

                // TAMBAH KATEGORI BARU: Copy-paste salah satu _buildCategoryItem di atas
                // dan ubah parameternya sesuai kebutuhan
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Helper method untuk membuat item kategori dengan bar
  /// PARAMETER YANG BISA DIUBAH:
  /// [category] = Nama kategori (String)
  /// [amount] = Nominal yang sudah diformat (String dengan Rp)
  /// [icon] = Icon dari Icons.nama_icon
  /// [percentage] = Persentase dalam desimal (0.0 - 1.0), misal: 0.5 = 50%
  Widget _buildCategoryItem(
    String category,
    String amount,
    IconData icon,
    double percentage,
  ) {
    return Row(
      children: [
        // --- ICON KATEGORI ---
        Container(
          padding: const EdgeInsets.all(10), // UBAH PADDING ICON: Ubah angka 10
          decoration: BoxDecoration(
            color: primaryBlue.withOpacity(
              0.1,
            ), // UBAH BACKGROUND ICON: Ubah primaryBlue atau opacity
            borderRadius: BorderRadius.circular(10), // UBAH BORDER RADIUS ICON
          ),
          child: Icon(
            icon,
            color: primaryBlue, // UBAH WARNA ICON: Ganti primaryBlue
            size: 20, // UBAH UKURAN ICON: Ubah angka 20
          ),
        ),
        const SizedBox(width: 16), // UBAH JARAK ICON KE TEKS: Ubah angka 16
        // --- INFO & PROGRESS BAR ---
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row: Nama kategori dan nominal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nama kategori
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 14, // UBAH UKURAN FONT KATEGORI: Ubah angka 14
                      fontWeight: FontWeight.w600,
                      color: textPrimary, // UBAH WARNA TEKS KATEGORI
                    ),
                  ),
                  // Nominal
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 14, // UBAH UKURAN FONT NOMINAL: Ubah angka 14
                      fontWeight: FontWeight.w700,
                      color: textPrimary, // UBAH WARNA NOMINAL
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8), // Jarak antara teks dan progress bar
              // --- PROGRESS BAR ---
              Container(
                height: 6, // UBAH TINGGI PROGRESS BAR: Ubah angka 6
                decoration: BoxDecoration(
                  color:
                      backgroundGray, // UBAH WARNA BACKGROUND BAR: Background abu-abu
                  borderRadius: BorderRadius.circular(
                    3,
                  ), // UBAH BORDER RADIUS BAR
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor:
                      percentage, // Lebar bar sesuai persentase (otomatis dari parameter)
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          primaryBlue, // UBAH WARNA PROGRESS BAR: Warna biru untuk bar fill
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== SECTION 3: RIWAYAT TRANSAKSI ====================
  /// Widget untuk menampilkan daftar riwayat transaksi
  /// UBAH DI SINI: Untuk menambah/menghapus transaksi atau mengubah tampilan list
  Widget _buildTransactionHistory() {
    // Formatter untuk format mata uang Indonesia
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      // === DEKORASI CARD RIWAYAT ===
      decoration: BoxDecoration(
        color: backgroundWhite, // UBAH BACKGROUND CARD: Ganti backgroundWhite
        borderRadius: BorderRadius.circular(
          20,
        ), // UBAH SUDUT CARD: Ubah angka 20
        border: Border.all(
          color: dividerGray,
          width: 1,
        ), // UBAH BORDER: Warna & ketebalan
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), // UBAH SHADOW: Ubah opacity
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          28,
        ), // UBAH PADDING DALAM CARD: Ubah angka 28
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER: Judul "Riwayat Transaksi" ---
            Row(
              children: [
                // Bar biru di sebelah kiri
                Container(
                  width: 4, // UBAH LEBAR BAR: Ubah angka 4
                  height: 24, // UBAH TINGGI BAR: Ubah angka 24
                  decoration: BoxDecoration(
                    color: primaryBlue, // UBAH WARNA BAR: Ganti primaryBlue
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Riwayat Transaksi', // UBAH JUDUL: Ganti teks ini
                  style: TextStyle(
                    fontSize: 20, // UBAH UKURAN FONT JUDUL: Ubah angka 20
                    fontWeight: FontWeight.w700,
                    color: textPrimary, // UBAH WARNA JUDUL: Ganti textPrimary
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24), // UBAH JARAK HEADER-LIST: Ubah angka 24
            // ⭐ DAFTAR TRANSAKSI - UBAH/TAMBAH/HAPUS TRANSAKSI DI SINI ⭐
            // Setiap _buildTransactionItem() membuat 1 baris transaksi
            // Format: _buildTransactionItem(judul, nominal_formatted, tanggal, icon, isIncome)
            // isIncome: true = pemasukan (icon naik, warna biru), false = pengeluaran (icon turun, warna abu)

            // Transaksi 1: Iuran Bulanan (Pemasukan)
            _buildTransactionItem(
              'Iuran Bulanan', // UBAH JUDUL TRANSAKSI 1
              formatter.format(50000), // ⭐ UBAH NOMINAL 1: Ganti 50000
              '10 Okt 2025', // UBAH TANGGAL 1
              Icons.arrow_upward_rounded, // UBAH ICON 1: Icon untuk pemasukan
              true, // UBAH TIPE 1: true=pemasukan, false=pengeluaran
            ),
            // Transaksi 2: Perbaikan Jalan (Pengeluaran)
            _buildTransactionItem(
              'Perbaikan Jalan', // UBAH JUDUL TRANSAKSI 2
              formatter.format(2000000), // ⭐ UBAH NOMINAL 2: Ganti 2000000
              '9 Okt 2025', // UBAH TANGGAL 2
              Icons
                  .arrow_downward_rounded, // UBAH ICON 2: Icon untuk pengeluaran
              false, // UBAH TIPE 2: false=pengeluaran
            ),
            // Transaksi 3: Donasi Acara (Pemasukan)
            _buildTransactionItem(
              'Donasi Acara', // UBAH JUDUL TRANSAKSI 3
              formatter.format(5000000), // ⭐ UBAH NOMINAL 3: Ganti 5000000
              '8 Okt 2025', // UBAH TANGGAL 3
              Icons.arrow_upward_rounded, // UBAH ICON 3
              true, // UBAH TIPE 3: true=pemasukan
            ),
            // Transaksi 4: Alat Kebersihan (Pengeluaran)
            _buildTransactionItem(
              'Alat Kebersihan', // UBAH JUDUL TRANSAKSI 4
              formatter.format(500000), // ⭐ UBAH NOMINAL 4: Ganti 500000
              '7 Okt 2025', // UBAH TANGGAL 4
              Icons.arrow_downward_rounded, // UBAH ICON 4
              false, // UBAH TIPE 4: false=pengeluaran
            ),

            // ⭐ TAMBAH TRANSAKSI BARU: Copy-paste block di bawah ini ⭐
            // _buildTransactionItem(
            //   'Nama Transaksi',           // Judul transaksi
            //   formatter.format(1000000),  // Nominal (format otomatis ke Rp)
            //   'DD MMM YYYY',              // Tanggal
            //   Icons.arrow_upward_rounded, // Icon (arrow_upward untuk pemasukan, arrow_downward untuk pengeluaran)
            //   true,                       // true=pemasukan, false=pengeluaran
            // ),
          ],
        ),
      ),
    );
  }

  // ==================== HELPER: ITEM TRANSAKSI ====================
  /// Helper method untuk membuat item transaksi individual
  /// UBAH DI SINI: Untuk mengubah tampilan setiap baris transaksi
  ///
  /// Parameters:
  /// [title] = Nama/deskripsi transaksi (contoh: "Iuran Bulanan")
  /// [amount] = Nominal transaksi yang sudah diformat (contoh: "Rp 50.000")
  /// [date] = Tanggal transaksi (contoh: "10 Okt 2025")
  /// [icon] = Icon untuk transaksi (contoh: Icons.arrow_upward_rounded)
  /// [isIncome] = true jika pemasukan (warna biru), false jika pengeluaran (warna abu)
  Widget _buildTransactionItem(
    String title,
    String amount,
    String date,
    IconData icon,
    bool isIncome,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ), // UBAH JARAK ANTAR ITEM: Ubah angka 12
      padding: const EdgeInsets.all(
        18,
      ), // UBAH PADDING DALAM ITEM: Ubah angka 18
      // === DEKORASI ITEM TRANSAKSI ===
      decoration: BoxDecoration(
        color: backgroundGray, // UBAH BACKGROUND ITEM: Ganti backgroundGray
        borderRadius: BorderRadius.circular(
          12,
        ), // UBAH SUDUT ITEM: Ubah angka 12
        border: Border.all(
          color: dividerGray.withOpacity(0.5), // UBAH BORDER: Warna & opacity
          width: 1, // UBAH KETEBALAN BORDER: Ubah angka 1
        ),
      ),
      child: Row(
        children: [
          // --- ICON TRANSAKSI ---
          Container(
            padding: const EdgeInsets.all(
              10,
            ), // UBAH PADDING ICON: Ubah angka 10
            decoration: BoxDecoration(
              // Background berbeda untuk income/expense (otomatis dari isIncome)
              color: isIncome
                  ? lightBlue.withOpacity(
                      0.15,
                    ) // UBAH BG ICON PEMASUKAN: Ganti lightBlue
                  : backgroundWhite, // UBAH BG ICON PENGELUARAN: Ganti backgroundWhite
              borderRadius: BorderRadius.circular(
                10,
              ), // UBAH SUDUT ICON: Ubah angka 10
              border: Border.all(
                // Border biru untuk income, abu untuk expense (otomatis)
                color: isIncome
                    ? primaryBlue.withOpacity(0.2) // UBAH BORDER ICON PEMASUKAN
                    : dividerGray, // UBAH BORDER ICON PENGELUARAN
                width: 1, // UBAH KETEBALAN BORDER ICON
              ),
            ),
            child: Icon(
              icon, // Icon diambil dari parameter (otomatis)
              // Warna icon: biru untuk income, abu untuk expense (otomatis)
              color: isIncome
                  ? primaryBlue
                  : textSecondary, // UBAH WARNA ICON: Pemasukan/Pengeluaran
              size: 18, // UBAH UKURAN ICON: Ubah angka 18
            ),
          ),
          const SizedBox(width: 16), // UBAH JARAK ICON-TEXT: Ubah angka 16
          // --- DETAIL TRANSAKSI (Judul dan Tanggal) ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama transaksi
                Text(
                  title, // Judul diambil dari parameter
                  style: const TextStyle(
                    fontSize: 14, // UBAH UKURAN FONT JUDUL: Ubah angka 14
                    fontWeight: FontWeight.w600,
                    color: textPrimary, // UBAH WARNA JUDUL: Ganti textPrimary
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ), // UBAH JARAK JUDUL-TANGGAL: Ubah angka 4
                // Tanggal transaksi
                Text(
                  date, // Tanggal diambil dari parameter
                  style: const TextStyle(
                    fontSize: 12, // UBAH UKURAN FONT TANGGAL: Ubah angka 12
                    color:
                        textTertiary, // UBAH WARNA TANGGAL: Ganti textTertiary
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // --- NOMINAL TRANSAKSI ---
          Text(
            amount, // Nominal diambil dari parameter (sudah format Rupiah)
            style: TextStyle(
              fontSize: 14, // UBAH UKURAN FONT NOMINAL: Ubah angka 14
              fontWeight: FontWeight.w700,
              // Warna: biru untuk income, abu untuk expense (otomatis dari isIncome)
              color: isIncome
                  ? primaryBlue
                  : textSecondary, // UBAH WARNA NOMINAL: Pemasukan/Pengeluaran
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
