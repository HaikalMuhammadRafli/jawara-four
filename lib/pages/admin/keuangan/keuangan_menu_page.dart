import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jawara_four/colors/app_colors.dart';
import 'package:jawara_four/utils/number_helpers.dart';
import '../../../data/models/pemasukan_model.dart';
import '../../../data/models/pengeluaran_model.dart';
import '../../../data/repositories/pemasukan_repository.dart';
import '../../../data/repositories/pengeluaran_repository.dart';

class KeuanganMenuPage extends StatefulWidget {
  const KeuanganMenuPage({super.key});

  @override
  State<KeuanganMenuPage> createState() => _KeuanganMenuPageState();
}

class _KeuanganMenuPageState extends State<KeuanganMenuPage> {
  final PemasukanRepository _pemasukanRepository = PemasukanRepository();
  final PengeluaranRepository _pengeluaranRepository = PengeluaranRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E88E5), // Blue background
      body: StreamBuilder<List<Pemasukan>>(
        stream: _pemasukanRepository.getPemasukanStream(),
        builder: (context, pemasukanSnapshot) {
          return StreamBuilder<List<Pengeluaran>>(
            stream: _pengeluaranRepository.getPengeluaranStream(),
            builder: (context, pengeluaranSnapshot) {
              final pemasukanList = pemasukanSnapshot.data ?? [];
              final pengeluaranList = pengeluaranSnapshot.data ?? [];

              double totalPemasukan = 0;
              for (var item in pemasukanList) {
                totalPemasukan += item.jumlah;
              }

              double totalPengeluaran = 0;
              for (var item in pengeluaranList) {
                totalPengeluaran += item.nominal;
              }

              final double balance = totalPemasukan - totalPengeluaran;

              // Combine for recent transactions
              final List<dynamic> allTransactions = [
                ...pemasukanList.map((e) => {'type': 'income', 'data': e}),
                ...pengeluaranList.map((e) => {'type': 'expense', 'data': e}),
              ];

              // Sort by date descending
              allTransactions.sort((a, b) {
                DateTime dateA;
                DateTime dateB;
                if (a['type'] == 'income') {
                  dateA = (a['data'] as Pemasukan).tanggal;
                } else {
                  dateA = (a['data'] as Pengeluaran).tanggal;
                }

                if (b['type'] == 'income') {
                  dateB = (b['data'] as Pemasukan).tanggal;
                } else {
                  dateB = (b['data'] as Pengeluaran).tanggal;
                }

                return dateB.compareTo(dateA);
              });

              final recentTransactions = allTransactions.take(10).toList();

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: _buildHeader(),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            _buildVirtualCard(balance),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildFinanceCard(
                                    'Pemasukan',
                                    totalPemasukan,
                                    Icons.arrow_downward_rounded,
                                    const Color(0xFF4CAF50),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildFinanceCard(
                                    'Pengeluaran',
                                    totalPengeluaran,
                                    Icons.arrow_upward_rounded,
                                    const Color(0xFFF44336),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildMenuGrid(context),
                            const SizedBox(height: 24),
                            _buildRecentTransactions(recentTransactions),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Keuangan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Info Keuangan',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildVirtualCard(double balance) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -40,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -40,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Saldo',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(
                      Icons.contactless_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),
                Text(
                  NumberHelpers.formatCurrency(balance.toInt()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Keuangan Jawara',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceCard(
    String title,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Icon(
                Icons.more_horiz,
                color: Colors.grey.withValues(alpha: 0.5),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            NumberHelpers.formatCurrency(amount.toInt()).replaceAll('Rp', ''),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu Keuangan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.2,
          children: [
            _buildMenuCard(
              context,
              'Iuran & Tagihan',
              Icons.receipt_long_rounded,
              'admin-keuangan-iuran-tagihan',
            ),
            _buildMenuCard(
              context,
              'Pemasukan Lain',
              Icons.account_balance_wallet_rounded,
              'admin-keuangan-pemasukan-lain',
            ),
            _buildMenuCard(
              context,
              'Pengeluaran',
              Icons.monetization_on_rounded,
              'admin-keuangan-pengeluaran',
            ),
            _buildMenuCard(
              context,
              'Kategori Iuran',
              Icons.category_rounded,
              'admin-keuangan-kategori-iuran',
            ),
            _buildMenuCard(
              context,
              'Laporan',
              Icons.summarize_rounded,
              'admin-keuangan-laporan',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    String routeName,
  ) {
    return GestureDetector(
      onTap: () => context.pushNamed(routeName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(List<dynamic> transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaksi Terakhir',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        if (transactions.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Belum ada transaksi.'),
            ),
          )
        else
          ...transactions.map((t) {
            final isIncome = t['type'] == 'income';
            final data = t['data'];
            final String title = isIncome
                ? (data as Pemasukan).judul
                : (data as Pengeluaran).nama;
            final num rawAmount = isIncome
                ? (data as Pemasukan).jumlah
                : (data as Pengeluaran).nominal;
            final double amount = rawAmount.toDouble();
            final DateTime date = isIncome
                ? (data as Pemasukan).tanggal
                : (data as Pengeluaran).tanggal;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isIncome
                          ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
                          : const Color(0xFFF44336).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isIncome
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      color: isIncome
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF44336),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMMM yyyy').format(date),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    (isIncome ? '+ ' : '- ') +
                        NumberHelpers.formatCurrency(amount.toInt()),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isIncome
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF44336),
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
