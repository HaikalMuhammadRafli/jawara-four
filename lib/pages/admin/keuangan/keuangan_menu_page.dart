import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../../data/models/pemasukan_model.dart';
import '../../../data/models/pengeluaran_model.dart';
import '../../../data/models/tagihan_model.dart';
import '../../../data/repositories/pemasukan_repository.dart';
import '../../../data/repositories/pengeluaran_repository.dart';
import '../../../data/repositories/tagihan_repository.dart';
import '../../../utils/date_helpers.dart';
import '../../../utils/number_helpers.dart';

class KeuanganMenuPage extends StatefulWidget {
  const KeuanganMenuPage({super.key});

  @override
  State<KeuanganMenuPage> createState() => _KeuanganMenuPageState();
}

class _KeuanganMenuPageState extends State<KeuanganMenuPage> {
  final PemasukanRepository _pemasukanRepository = PemasukanRepository();
  final PengeluaranRepository _pengeluaranRepository = PengeluaranRepository();
  final TagihanRepository _tagihanRepository = TagihanRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 40),
        child: Column(
          children: [
            _buildQuickStats(context),
            const SizedBox(height: 20),
            _buildMenuGrid(context),
            const SizedBox(height: 20),
            _buildTransactionLists(context),
            const SizedBox(height: 20),
            _buildFinanceChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return StreamBuilder<List<Pemasukan>>(
      stream: _pemasukanRepository.getPemasukanStream(),
      builder: (context, pemasukanSnapshot) {
        return StreamBuilder<List<Tagihan>>(
          stream: _tagihanRepository.getTagihanStream(),
          builder: (context, tagihanSnapshot) {
            return StreamBuilder<List<Pengeluaran>>(
              stream: _pengeluaranRepository.getPengeluaranStream(),
              builder: (context, pengeluaranSnapshot) {
                if (pemasukanSnapshot.connectionState == ConnectionState.waiting ||
                    tagihanSnapshot.connectionState == ConnectionState.waiting ||
                    pengeluaranSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final pemasukanList = pemasukanSnapshot.data ?? [];
                final pengeluaranList = pengeluaranSnapshot.data ?? [];

                double totalPemasukan = pemasukanList.fold(0.0, (sum, item) => sum + item.jumlah);
                double totalPengeluaran = pengeluaranList.fold(
                  0.0,
                  (sum, item) => sum + item.nominal,
                );
                double saldo = totalPemasukan - totalPengeluaran;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Keuangan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.success.withValues(alpha: 0.1),
                            AppColors.success.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.success,
                                  AppColors.success.withValues(alpha: 0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Saldo Tersedia',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.success,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  NumberHelpers.formatCurrency(saldo.toInt()),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Update terakhir: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFinanceChart() {
    return StreamBuilder<List<Pengeluaran>>(
      stream: _pengeluaranRepository.getPengeluaranStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final pengeluaranList = snapshot.data!;
        if (pengeluaranList.isEmpty) return const SizedBox();

        // Group by category (jenis)
        final Map<String, double> categoryTotals = {};
        double totalPengeluaran = 0;

        for (var item in pengeluaranList) {
          categoryTotals[item.jenis] = (categoryTotals[item.jenis] ?? 0.0) + item.nominal;
          totalPengeluaran += item.nominal;
        }

        // Colors for categories
        final List<Color> colors = [
          AppColors.success,
          AppColors.primary,
          AppColors.warning,
          AppColors.error,
          Colors.purple,
          Colors.teal,
        ];

        int colorIndex = 0;
        final List<PieChartSectionData> sections = [];
        final List<Widget> legendItems = [];

        categoryTotals.forEach((category, amount) {
          final percentage = (amount / totalPengeluaran) * 100;
          final color = colors[colorIndex % colors.length];

          sections.add(
            PieChartSectionData(
              color: color,
              value: percentage,
              title: '${percentage.toInt()}%',
              radius: 70,
              titleStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black.withValues(alpha: 0.2))],
              ),
            ),
          );

          legendItems.add(
            _buildEnhancedLegendItem(
              category,
              color,
              '${percentage.toStringAsFixed(1)}%',
              NumberHelpers.formatCurrency(amount.toInt()),
            ),
          );

          colorIndex++;
        });

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distribusi Pengeluaran',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Berdasarkan kategori',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Center(
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                        enabled: true,
                      ),
                      sectionsSpace: 3,
                      centerSpaceRadius: 60,
                      sections: sections,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider.withValues(alpha: 0.5), width: 1),
                ),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: legendItems,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEnhancedLegendItem(String label, Color color, String percentage, String amount) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '$percentage • $amount',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary.withValues(alpha: 0.6),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return StreamBuilder<List<Pemasukan>>(
      stream: _pemasukanRepository.getPemasukanStream(),
      builder: (context, pemasukanSnapshot) {
        return StreamBuilder<List<Pengeluaran>>(
          stream: _pengeluaranRepository.getPengeluaranStream(),
          builder: (context, pengeluaranSnapshot) {
            final double totalPemasukan = (pemasukanSnapshot.data ?? []).fold(
              0.0,
              (sum, item) => sum + item.jumlah,
            );
            final double totalPengeluaran = (pengeluaranSnapshot.data ?? []).fold(
              0.0,
              (sum, item) => sum + item.nominal,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu Keuangan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildMenuCard(
                        context,
                        'Iuran',
                        Icons.receipt_long,
                        AppColors.success,
                        'keuangan-iuran-tagihan',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMenuCard(
                        context,
                        'Kategori Iuran',
                        Icons.category,
                        AppColors.warning,
                        'keuangan-kategori-iuran',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMenuCard(
                        context,
                        'Laporan',
                        Icons.analytics,
                        AppColors.primary,
                        'keuangan-laporan',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildMenuCardWithValue(
                  context,
                  'Pemasukan',
                  NumberHelpers.formatCurrency(totalPemasukan.toInt()),
                  Icons.trending_up,
                  AppColors.primary,
                  'keuangan-pemasukan-lain',
                ),
                const SizedBox(height: 12),
                _buildMenuCardWithValue(
                  context,
                  'Pengeluaran',
                  NumberHelpers.formatCurrency(totalPengeluaran.toInt()),
                  Icons.trending_down,
                  AppColors.error,
                  'keuangan-pengeluaran',
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTransactionLists(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<List<Pemasukan>>(
          stream: _pemasukanRepository.getPemasukanStream(),
          builder: (context, snapshot) {
            final list = snapshot.data ?? [];
            // Sort by date descending
            list.sort((a, b) => b.tanggal.compareTo(a.tanggal));
            final recentList = list.take(3).toList();

            return _buildTransactionSection(
              context,
              'Pemasukan Terbaru',
              recentList
                  .map(
                    (item) => _buildTransactionItem(
                      item.nama,
                      NumberHelpers.formatCurrency(item.jumlah),
                      DateHelpers.formatDateShort(item.tanggal),
                      AppColors.success,
                    ),
                  )
                  .toList(),
              'keuangan-pemasukan-lain',
            );
          },
        ),
        const SizedBox(height: 20),
        StreamBuilder<List<Pengeluaran>>(
          stream: _pengeluaranRepository.getPengeluaranStream(),
          builder: (context, snapshot) {
            final list = snapshot.data ?? [];
            // Sort by date descending
            list.sort((a, b) => b.tanggal.compareTo(a.tanggal));
            final recentList = list.take(3).toList();

            return _buildTransactionSection(
              context,
              'Pengeluaran Terbaru',
              recentList
                  .map(
                    (item) => _buildTransactionItem(
                      item.nama,
                      NumberHelpers.formatCurrency(item.nominal),
                      DateHelpers.formatDateShort(item.tanggal),
                      AppColors.error,
                    ),
                  )
                  .toList(),
              'keuangan-pengeluaran',
            );
          },
        ),
      ],
    );
  }

  Widget _buildTransactionSection(
    BuildContext context,
    String title,
    List<Widget> items,
    String routeName,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () => context.pushNamed(routeName),
                child: Text(
                  'Selengkapnya',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            const Padding(padding: EdgeInsets.all(8.0), child: Text('Belum ada data'))
          else
            ...items,
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String title, String amount, String date, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(date, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String routeName,
  ) {
    return GestureDetector(
      onTap: () => context.pushNamed(routeName),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCardWithValue(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String routeName,
  ) {
    return GestureDetector(
      onTap: () => context.pushNamed(routeName),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
