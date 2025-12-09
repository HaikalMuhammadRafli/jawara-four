import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_four/colors/app_colors.dart';
import 'package:jawara_four/data/models/pemasukan_model.dart';
import 'package:jawara_four/data/models/pengeluaran_model.dart';
import 'package:jawara_four/data/repositories/pemasukan_repository.dart';
import 'package:jawara_four/data/repositories/pengeluaran_repository.dart';
import 'package:jawara_four/utils/date_helpers.dart';

/// Halaman Laporan Keuangan
/// Menampilkan ringkasan keuangan, statistik, dan riwayat transaksi
class LaporanKeuanganPage extends StatefulWidget {
  const LaporanKeuanganPage({super.key});

  @override
  State<LaporanKeuanganPage> createState() => _LaporanKeuanganPageState();
}

class _LaporanKeuanganPageState extends State<LaporanKeuanganPage> {
  final PemasukanRepository _pemasukanRepository = PemasukanRepository();
  final PengeluaranRepository _pengeluaranRepository = PengeluaranRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFFFF),
      child: StreamBuilder<List<Pemasukan>>(
        stream: _pemasukanRepository.getPemasukanStream(),
        builder: (context, pemasukanSnapshot) {
          return StreamBuilder<List<Pengeluaran>>(
            stream: _pengeluaranRepository.getPengeluaranStream(),
            builder: (context, pengeluaranSnapshot) {
              // Show loading only if both are waiting or one is waiting and other hasn't emitted
              if (pemasukanSnapshot.connectionState ==
                      ConnectionState.waiting &&
                  !pemasukanSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (pengeluaranSnapshot.connectionState ==
                      ConnectionState.waiting &&
                  !pengeluaranSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (pemasukanSnapshot.hasError || pengeluaranSnapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${pemasukanSnapshot.error ?? pengeluaranSnapshot.error}',
                  ),
                );
              }

              final pemasukanList = pemasukanSnapshot.data ?? [];
              final pengeluaranList = pengeluaranSnapshot.data ?? [];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildSummaryCard(pemasukanList, pengeluaranList),
                    const SizedBox(height: 20),
                    _buildStatsSection(pengeluaranList),
                    const SizedBox(height: 20),
                    _buildTransactionHistory(pemasukanList, pengeluaranList),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ==================== SECTION 1: RINGKASAN KEUANGAN ====================
  Widget _buildSummaryCard(
    List<Pemasukan> pemasukanList,
    List<Pengeluaran> pengeluaranList,
  ) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // Calculate totals
    int totalPemasukan = pemasukanList.fold(
      0,
      (sum, item) => sum + item.jumlah,
    );
    int totalPengeluaran = pengeluaranList.fold(
      0,
      (sum, item) => sum + item.nominal,
    );
    int saldoAkhir = totalPemasukan - totalPengeluaran;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Ringkasan Keuangan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.backgroundGray,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider, width: 1),
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
                        child: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Saldo Akhir',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    formatter.format(saldoAkhir),
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.trending_up_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Pemasukan',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          formatter.format(totalPemasukan),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGray,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.divider, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.trending_down_rounded,
                                color: AppColors.textSecondary,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Pengeluaran',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          formatter.format(totalPengeluaran),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
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
  Widget _buildStatsSection(List<Pengeluaran> pengeluaranList) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // Group pengeluaran by category
    final Map<String, int> categoryTotals = {};
    int totalPengeluaran = 0;

    for (var p in pengeluaranList) {
      categoryTotals.update(
        p.jenis,
        (value) => value + p.nominal,
        ifAbsent: () => p.nominal,
      );
      totalPengeluaran += p.nominal;
    }

    // Convert map to list and sort by amount descending
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Take top 5 categories
    final topCategories = sortedCategories.take(5).toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                spreadRadius: 0,
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Kategori Pengeluaran',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (topCategories.isEmpty)
                  const Text(
                    'Belum ada data pengeluaran',
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  ...topCategories.map((entry) {
                    final percentage = totalPengeluaran > 0
                        ? entry.value / totalPengeluaran
                        : 0.0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildCategoryItem(
                        entry.key,
                        formatter.format(entry.value),
                        _getIconForCategory(entry.key),
                        percentage,
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'infrastruktur':
        return Icons.construction_rounded;
      case 'operasional':
        return Icons.settings_rounded;
      case 'sosial & acara':
        return Icons.celebration_rounded;
      case 'kebersihan':
        return Icons.cleaning_services_rounded;
      case 'keamanan':
        return Icons.security_rounded;
      case 'listrik':
        return Icons.electric_bolt_rounded;
      case 'air':
        return Icons.water_drop_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  Widget _buildCategoryItem(
    String category,
    String amount,
    IconData icon,
    double percentage,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.backgroundGray,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentage.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
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
  Widget _buildTransactionHistory(
    List<Pemasukan> pemasukanList,
    List<Pengeluaran> pengeluaranList,
  ) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // Merge lists
    List<dynamic> allTransactions = [
      ...pemasukanList.map(
        (e) => {'data': e, 'type': 'pemasukan', 'date': e.tanggal},
      ),
      ...pengeluaranList.map(
        (e) => {'data': e, 'type': 'pengeluaran', 'date': e.tanggal},
      ),
    ];

    // Sort by date descending
    allTransactions.sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );

    // Take top 10
    final recentTransactions = allTransactions.take(10).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Riwayat Transaksi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (recentTransactions.isEmpty)
              const Text(
                'Belum ada transaksi',
                style: TextStyle(color: Colors.grey),
              )
            else
              ...recentTransactions.map((item) {
                final isPemasukan = item['type'] == 'pemasukan';
                final data = item['data'];
                // Check if data is Pemasukan to access .judul or Pengeluaran for .nama
                final title = isPemasukan
                    ? (data as Pemasukan).judul
                    : (data as Pengeluaran).nama;
                final amount = isPemasukan
                    ? (data as Pemasukan).jumlah
                    : (data as Pengeluaran).nominal;
                final date = item['date'] as DateTime;

                return _buildTransactionItem(
                  title,
                  formatter.format(amount),
                  DateHelpers.formatDateShort(date),
                  isPemasukan
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  isPemasukan,
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    String title,
    String amount,
    String date,
    IconData icon,
    bool isIncome,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isIncome
                  ? AppColors.primaryLight.withValues(alpha: 0.15)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isIncome
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.divider,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: isIncome ? AppColors.primary : AppColors.textSecondary,
              size: 18,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isIncome ? AppColors.primary : AppColors.textSecondary,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
