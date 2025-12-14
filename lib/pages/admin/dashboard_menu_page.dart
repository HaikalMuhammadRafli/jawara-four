import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../data/models/pemasukan_model.dart';
import '../../data/models/pengeluaran_model.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/models/warga_model.dart';
import '../../data/repositories/kegiatan_repository.dart';
import '../../data/repositories/pemasukan_repository.dart';
import '../../data/repositories/pengeluaran_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/warga_repository.dart';
import '../../services/auth_service.dart';
import '../../utils/date_helpers.dart';
import '../../utils/number_helpers.dart';

class DashboardMenuPage extends StatefulWidget {
  const DashboardMenuPage({super.key});

  @override
  State<DashboardMenuPage> createState() => _DashboardMenuPageState();
}

class _DashboardMenuPageState extends State<DashboardMenuPage> {
  final UserRepository _userRepository = UserRepository();
  final WargaRepository _wargaRepository = WargaRepository();
  final PemasukanRepository _pemasukanRepository = PemasukanRepository();
  final PengeluaranRepository _pengeluaranRepository = PengeluaranRepository();
  final KegiatanRepository _kegiatanRepository = KegiatanRepository();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Pemasukan>>(
      stream: _pemasukanRepository.getPemasukanStream(),
      builder: (context, pemasukanSnapshot) {
        return StreamBuilder<List<Pengeluaran>>(
          stream: _pengeluaranRepository.getPengeluaranStream(),
          builder: (context, pengeluaranSnapshot) {
            return StreamBuilder<List<Warga>>(
              stream: _wargaRepository.getWargaStream(),
              builder: (context, wargaSnapshot) {
                return StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _kegiatanRepository.getKegiatanStream(),
                  builder: (context, kegiatanSnapshot) {
                    final pemasukanList = pemasukanSnapshot.data ?? [];
                    final pengeluaranList = pengeluaranSnapshot.data ?? [];
                    final wargaList = wargaSnapshot.data ?? [];
                    final kegiatanList = kegiatanSnapshot.data ?? [];

                    return Scaffold(
                      backgroundColor: const Color(0xFF1E88E5),
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            SafeArea(
                              bottom: false,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                child: _buildWelcomeSection(),
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
                                minHeight:
                                    MediaQuery.of(context).size.height * 0.8,
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  _buildBentoGrid(
                                    pemasukanList,
                                    pengeluaranList,
                                    wargaList,
                                    kegiatanList,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildRecentActivities(),
                                  const SizedBox(height: 80), // Padding bottom
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildWelcomeSection() {
    return StreamBuilder<UserProfile?>(
      stream: _userRepository.getUserProfileStream(
        _authService.currentUser?.uid ?? '',
      ),
      builder: (context, snapshot) {
        final userProfile = snapshot.data;
        final displayName =
            userProfile?.nama ??
            _authService.currentUser?.email?.split('@')[0] ??
            'User';
        final role = userProfile?.role.value ?? '';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, $displayName 👋',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Ringkasan Dashboard',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
            if (role.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  role,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildBentoGrid(
    List<Pemasukan> pemasukanList,
    List<Pengeluaran> pengeluaranList,
    List<Warga> wargaList,
    List<dynamic> kegiatanList,
  ) {
    // Calculators
    final double totalPemasukan = pemasukanList.fold(
      0.0,
      (sum, item) => sum + item.jumlah,
    );
    final double totalPengeluaran = pengeluaranList.fold(
      0.0,
      (sum, item) => sum + item.nominal,
    );
    final double saldo = totalPemasukan - totalPengeluaran;
    final int wargaCount = wargaList.length;
    final int kegiatanCount = kegiatanList.length;

    // Growth Calculation
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;
    final previousMonth = currentMonth == 1 ? 12 : currentMonth - 1;
    final previousYear = currentMonth == 1 ? currentYear - 1 : currentYear;

    double currentMonthIncome = 0;
    double previousMonthIncome = 0;

    for (var item in pemasukanList) {
      if (item.tanggal.year == currentYear &&
          item.tanggal.month == currentMonth) {
        currentMonthIncome += item.jumlah;
      }
      if (item.tanggal.year == previousYear &&
          item.tanggal.month == previousMonth) {
        previousMonthIncome += item.jumlah;
      }
    }

    double growth = 0;
    if (previousMonthIncome > 0) {
      growth =
          ((currentMonthIncome - previousMonthIncome) / previousMonthIncome) *
          100;
    } else if (currentMonthIncome > 0) {
      growth = 100;
    }

    final isPositive = growth >= 0;
    final growthStr =
        '${isPositive ? '+' : ''}${growth.abs().toStringAsFixed(1)}%';

    return Column(
      children: [
        // 1. TOP ROW: Saldo (Left) + Stats (Right)
        // Keep fixed height to align nicely
        SizedBox(
          height: 220,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // BIG CARD: Saldo
              Expanded(flex: 3, child: _buildSaldoCard(saldo)),
              const SizedBox(width: 12),
              // RIGHT STACK: Warga & Kegiatan
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: _buildSimpleStatCard(
                        'Total Warga',
                        wargaCount.toString(),
                        Icons.people_alt_rounded,
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _buildSimpleStatCard(
                        'Total Kegiatan',
                        kegiatanCount.toString(),
                        Icons.event_note_rounded,
                        AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 2. MIDDLE: Growth Card
        _buildGrowthCard(growthStr, isPositive),
        const SizedBox(height: 12),

        // 3. BOTTOM: Chart Card
        _buildMiniChartCard(pemasukanList),
      ],
    );
  }

  Widget _buildBentoCard({
    required Widget child,
    Color? color,
    Gradient? gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 1),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: child),
    );
  }

  Widget _buildSaldoCard(double saldo) {
    return _buildBentoCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Saldo',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        Text(
                          'Keuangan',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
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
                        size: 18,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      NumberHelpers.formatCurrency(saldo.toInt()),
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '+2.4% vs bulan lalu',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return _buildBentoCard(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 18, color: color),
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthCard(String growthStr, bool isPositive) {
    return _buildBentoCard(
      color: isPositive
          ? AppColors.success.withValues(alpha: 0.1)
          : AppColors.error.withValues(alpha: 0.1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pertumbuhan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      growthStr,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -1,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        color: isPositive ? AppColors.success : AppColors.error,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.incomplete_circle,
                color: isPositive ? Colors.amber[700] : Colors.amber[900],
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniChartCard(List<Pemasukan> pemasukanList) {
    final now = DateTime.now();
    final currentYear = now.year;
    final List<double> monthlyIncome = List.filled(12, 0.0);

    for (var item in pemasukanList) {
      if (item.tanggal.year == currentYear) {
        monthlyIncome[item.tanggal.month - 1] += item.jumlah;
      }
    }

    double maxY = 0;
    for (var val in monthlyIncome) {
      if (val > maxY) maxY = val;
    }
    if (maxY == 0) maxY = 100;

    List<FlSpot> spots = [];
    for (int i = 0; i < 12; i++) {
      spots.add(FlSpot(i.toDouble(), monthlyIncome[i]));
    }

    double totalIncome = monthlyIncome.fold(0, (sum, item) => sum + item);
    double avgIncome = totalIncome / 12;

    return _buildBentoCard(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Analisis Pemasukan',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Tahun $currentYear',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 2,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          );
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text('${value.toInt() + 1}', style: style),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 11,
                  minY: 0,
                  maxY: maxY * 1.2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => AppColors.primary,
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final flSpot = barSpot;
                          return LineTooltipItem(
                            NumberHelpers.formatCurrency(flSpot.y.toInt()),
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildChartStat(
                    'Total',
                    NumberHelpers.formatCurrency(totalIncome.truncate()),
                    AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _buildChartStat(
                    'Rata-rata',
                    NumberHelpers.formatCurrency(avgIncome.truncate()),
                    AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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

                allActivities.sort(
                  (a, b) =>
                      (b['date'] as DateTime).compareTo(a['date'] as DateTime),
                );

                final recentActivities = allActivities.take(5).toList();

                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aktivitas Terbaru',
                        style: TextStyle(
                          fontSize: 18,
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
                            icon = Icons.arrow_upward_rounded;
                            color = AppColors.success;
                          } else if (activity['type'] == 'pengeluaran') {
                            icon = Icons.arrow_downward_rounded;
                            color = AppColors.error;
                          } else {
                            icon = Icons.event_note_rounded;
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
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
                  maxLines: 1,
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
