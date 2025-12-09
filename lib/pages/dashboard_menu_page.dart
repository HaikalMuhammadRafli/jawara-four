import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../data/models/user_profile_model.dart';
import '../data/models/pemasukan_model.dart';
import '../data/models/pengeluaran_model.dart';
import '../data/repositories/user_repository.dart';
import '../services/auth_service.dart';
import '../data/repositories/pemasukan_repository.dart';
import '../data/repositories/pengeluaran_repository.dart';
import '../data/repositories/kegiatan_repository.dart';
import '../utils/number_helpers.dart';
import '../utils/date_helpers.dart';

class DashboardMenuPage extends StatefulWidget {
  const DashboardMenuPage({super.key});

  @override
  State<DashboardMenuPage> createState() => _DashboardMenuPageState();
}

class _DashboardMenuPageState extends State<DashboardMenuPage> {
  final UserRepository _userRepository = UserRepository();
  final PemasukanRepository _pemasukanRepository = PemasukanRepository();
  final PengeluaranRepository _pengeluaranRepository = PengeluaranRepository();
  final KegiatanRepository _kegiatanRepository = KegiatanRepository();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 40),
        child: Column(
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 20),
            _buildQuickSummary(),
            const SizedBox(height: 20),
            _buildFinanceChart(),
            const SizedBox(height: 20),
            _buildRecentActivities(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    final currentUser = _authService.currentUser;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: currentUser != null
          ? StreamBuilder<UserProfile?>(
              stream: _userRepository.getUserProfileStream(currentUser.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final userProfile = snapshot.data;
                final displayName =
                    currentUser.displayName ??
                    currentUser.email?.split('@')[0] ??
                    'User';
                final role = userProfile?.role.value ?? '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang, $displayName',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (role.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          role,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      'Pantau perkembangan warga dan aktivitas RW secara real-time',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                );
              },
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Pantau perkembangan warga dan aktivitas RW secara real-time',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildQuickSummary() {
    return StreamBuilder<List<Pemasukan>>(
      stream: _pemasukanRepository.getPemasukanStream(),
      builder: (context, pemasukanSnapshot) {
        return StreamBuilder<List<Pengeluaran>>(
          stream: _pengeluaranRepository.getPengeluaranStream(),
          builder: (context, pengeluaranSnapshot) {
            return StreamBuilder<List<UserProfile>>(
              stream: _userRepository.getUsersStream(),
              builder: (context, userSnapshot) {
                return StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _kegiatanRepository.getKegiatanStream(),
                  builder: (context, kegiatanSnapshot) {
                    final double totalPemasukan = (pemasukanSnapshot.data ?? [])
                        .fold(0.0, (sum, item) => sum + item.jumlah);
                    final double totalPengeluaran =
                        (pengeluaranSnapshot.data ?? []).fold(
                          0.0,
                          (sum, item) => sum + item.nominal,
                        );
                    final double saldo = totalPemasukan - totalPengeluaran;

                    final int wargaCount = userSnapshot.data?.length ?? 0;
                    final int kegiatanCount =
                        kegiatanSnapshot.data?.length ?? 0;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ringkasan Cepat',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                          children: [
                            _buildSummaryCard(
                              'Keuangan',
                              NumberHelpers.formatCurrency(saldo.toInt()),
                              'Saldo Akhir',
                              Icons.account_balance_wallet,
                              AppColors.success,
                            ),
                            _buildSummaryCard(
                              'Warga',
                              '$wargaCount',
                              'Warga Terdaftar',
                              Icons.people,
                              AppColors.primary,
                            ),
                            _buildSummaryCard(
                              'Kegiatan',
                              '$kegiatanCount',
                              'Berjalan',
                              Icons.event,
                              AppColors.warning,
                            ),
                            _buildSummaryCard(
                              'Statistik',
                              '+12%',
                              'Pertumbuhan',
                              Icons.trending_up,
                              AppColors.primaryDark,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
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
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceChart() {
    return StreamBuilder<List<Pemasukan>>(
      stream: _pemasukanRepository.getPemasukanStream(),
      builder: (context, pemasukanSnapshot) {
        return StreamBuilder<List<Pengeluaran>>(
          stream: _pengeluaranRepository.getPengeluaranStream(),
          builder: (context, pengeluaranSnapshot) {
            final pemasukanList = pemasukanSnapshot.data ?? [];
            final pengeluaranList = pengeluaranSnapshot.data ?? [];

            // Aggregate by month for current year
            final now = DateTime.now();
            final currentYear = now.year;
            final List<double> monthlyIncome = List.filled(12, 0.0);
            final List<double> monthlyExpense = List.filled(12, 0.0);

            for (var item in pemasukanList) {
              if (item.tanggal.year == currentYear) {
                monthlyIncome[item.tanggal.month - 1] += item.jumlah;
              }
            }

            for (var item in pengeluaranList) {
              if (item.tanggal.year == currentYear) {
                monthlyExpense[item.tanggal.month - 1] += item.nominal;
              }
            }

            // Find max value for scaling
            double maxY = 0;
            for (var val in monthlyIncome) {
              if (val > maxY) maxY = val;
            }
            for (var val in monthlyExpense) {
              if (val > maxY) maxY = val;
            }
            if (maxY == 0) maxY = 100; // Default if no data

            // Prepare bar groups (showing last 6 months or all 12? Design showed ~6 bars)
            // Let's show first 6 months or relevant months.
            // The design had 6 bars. Let's show Jan-Jun or current 6 months window.
            // For simplicity, let's show Jan-Jun as in original code, or better, dynamic.
            // Let's show Jan-Jun for now to match the UI labels.

            List<BarChartGroupData> barGroups = [];
            for (int i = 0; i < 6; i++) {
              // Normalize to percentage of maxY for visualization if needed, or just raw values?
              // The original code used percentages (maxY=100).
              // Let's use raw values but scale maxY.

              // We will show Income (Green) bar.
              // Wait, the design had single bars. Maybe it was "Net Income" or just "Income"?
              // The original code had single bars with success color. Let's assume it visualizes Income.
              // Or maybe Balance?
              // Let's visualize Income for now.

              barGroups.add(
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: monthlyIncome[i],
                      gradient: LinearGradient(
                        colors: [
                          AppColors.success,
                          AppColors.success.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      width: 28,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Stats
            double totalIncome = monthlyIncome.fold(0, (sum, val) => sum + val);
            double avgIncome =
                totalIncome / 12; // Or divide by current month index?
            double maxIncome = monthlyIncome.reduce(
              (curr, next) => curr > next ? curr : next,
            );

            return Container(
              padding: const EdgeInsets.all(24),
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
                        'Grafik Pemasukan Bulanan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$currentYear',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 280,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxY * 1.2, // Add some buffer
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipRoundedRadius: 8,
                            tooltipPadding: const EdgeInsets.all(12),
                            tooltipMargin: 8,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                NumberHelpers.formatCurrency(rod.toY.toInt()),
                                TextStyle(
                                  color: AppColors.background,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                );
                                Widget text;
                                switch (value.toInt()) {
                                  case 0:
                                    text = const Text('Jan', style: style);
                                    break;
                                  case 1:
                                    text = const Text('Feb', style: style);
                                    break;
                                  case 2:
                                    text = const Text('Mar', style: style);
                                    break;
                                  case 3:
                                    text = const Text('Apr', style: style);
                                    break;
                                  case 4:
                                    text = const Text('Mei', style: style);
                                    break;
                                  case 5:
                                    text = const Text('Jun', style: style);
                                    break;
                                  default:
                                    text = const Text('', style: style);
                                    break;
                                }
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 16,
                                  child: text,
                                );
                              },
                              reservedSize: 30,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: maxY / 5,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return const SizedBox(); // Hide left labels to avoid clutter or format them short
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: barGroups,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: maxY / 5,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: AppColors.divider,
                              strokeWidth: 1,
                              dashArray: [5, 5],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildChartStat(
                        'Total',
                        NumberHelpers.formatCurrency(totalIncome.toInt()),
                        AppColors.textPrimary,
                      ),
                      _buildChartStat(
                        'Rata-rata',
                        NumberHelpers.formatCurrency(avgIncome.toInt()),
                        AppColors.success,
                      ),
                      _buildChartStat(
                        'Tertinggi',
                        NumberHelpers.formatCurrency(maxIncome.toInt()),
                        AppColors.warning,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChartStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivities() {
    return StreamBuilder<List<Pemasukan>>(
      stream: _pemasukanRepository.getPemasukanStream(),
      builder: (context, pemasukanSnapshot) {
        return StreamBuilder<List<Pengeluaran>>(
          stream: _pengeluaranRepository.getPengeluaranStream(),
          builder: (context, pengeluaranSnapshot) {
            return StreamBuilder<List<Map<String, dynamic>>>(
              stream: _kegiatanRepository.getKegiatanStream(),
              builder: (context, kegiatanSnapshot) {
                final List<dynamic> allActivities = [];

                // Add Pemasukan
                if (pemasukanSnapshot.hasData) {
                  allActivities.addAll(
                    pemasukanSnapshot.data!.map(
                      (e) => {
                        'type': 'pemasukan',
                        'title': e.nama,
                        'date': e.tanggal,
                        'amount': e.jumlah,
                      },
                    ),
                  );
                }

                // Add Pengeluaran
                if (pengeluaranSnapshot.hasData) {
                  allActivities.addAll(
                    pengeluaranSnapshot.data!.map(
                      (e) => {
                        'type': 'pengeluaran',
                        'title': e.nama,
                        'date': e.tanggal,
                        'amount': e.nominal,
                      },
                    ),
                  );
                }

                // Add Kegiatan
                if (kegiatanSnapshot.hasData) {
                  allActivities.addAll(
                    kegiatanSnapshot.data!.map(
                      (e) => {
                        'type': 'kegiatan',
                        'title': e['nama'] ?? 'Kegiatan',
                        'date': e['tanggal'] != null
                            ? DateTime.parse(e['tanggal'])
                            : DateTime.now(),
                        'amount': 0,
                      },
                    ),
                  );
                }

                // Sort by date descending
                allActivities.sort(
                  (a, b) =>
                      (b['date'] as DateTime).compareTo(a['date'] as DateTime),
                );

                // Take top 5
                final recentActivities = allActivities.take(5).toList();

                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aktivitas Terbaru',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (recentActivities.isEmpty)
                        const Text('Belum ada aktivitas')
                      else
                        ...recentActivities.map((activity) {
                          IconData icon;
                          Color color;
                          String dateStr = DateHelpers.formatDateShort(
                            activity['date'],
                          );

                          if (activity['type'] == 'pemasukan') {
                            icon = Icons.trending_up;
                            color = AppColors.success;
                          } else if (activity['type'] == 'pengeluaran') {
                            icon = Icons.trending_down;
                            color = AppColors.error;
                          } else {
                            icon = Icons.event;
                            color = AppColors.primary;
                          }

                          return _buildActivityItem(
                            activity['title'],
                            dateStr,
                            icon,
                            color,
                          );
                        }),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildActivityItem(
    String name,
    String date,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
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
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
