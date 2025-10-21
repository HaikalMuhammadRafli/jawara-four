import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../colors/app_colors.dart';

class DashboardMenuPage extends StatelessWidget {
  const DashboardMenuPage({super.key});

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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
            'Selamat Datang',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
          const SizedBox(height: 12),
          Text(
            'Pantau perkembangan warga dan aktivitas RW secara real-time',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.descriptionText,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildQuickSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
                Text(
          'Ringkasan Cepat',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
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
            // Card Keuangan
            _buildSummaryCard(
              'Keuangan',
              'Rp 15.000.000',
              'Saldo Akhir',
              Icons.account_balance_wallet,
              AppColors.success,
            ),
            // Card Warga
            _buildSummaryCard(
              'Warga',
              '1,250',
              'Warga Terdaftar',
              Icons.people,
              AppColors.primaryBlue,
            ),
            // Card Kegiatan
            _buildSummaryCard(
              'Kegiatan',
              '8',
              'Berjalan',
              Icons.event,
              AppColors.prompt,
            ),
            // Card Statistik
            _buildSummaryCard(
              'Statistik',
              '+12%',
              'Pertumbuhan',
              Icons.trending_up,
              AppColors.hoverBlue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon, 
                  color: color, 
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
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
            style: TextStyle(
              fontSize: 12,
              color: AppColors.descriptionText,
            ),
            overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
    );
  }


  Widget _buildFinanceChart() {
    return Container(
          padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grafik Keuangan Bulanan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '2024',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Professional FL Chart Bar Chart
          SizedBox(
            height: 280,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(12),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()}%',
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
                          color: AppColors.descriptionText,
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
                      interval: 20,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: AppColors.descriptionText,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        );
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text('${value.toInt()}%', style: style),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 60,
                        gradient: LinearGradient(
                          colors: [AppColors.success, AppColors.success.withOpacity(0.7)],
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
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: 80,
                        gradient: LinearGradient(
                          colors: [AppColors.success, AppColors.success.withOpacity(0.7)],
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
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: 50,
                        gradient: LinearGradient(
                          colors: [AppColors.success, AppColors.success.withOpacity(0.7)],
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
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        toY: 90,
                        gradient: LinearGradient(
                          colors: [AppColors.success, AppColors.success.withOpacity(0.7)],
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
                  BarChartGroupData(
                    x: 4,
                    barRods: [
                      BarChartRodData(
                        toY: 70,
                        gradient: LinearGradient(
                          colors: [AppColors.success, AppColors.success.withOpacity(0.7)],
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
                  BarChartGroupData(
                    x: 5,
                    barRods: [
                      BarChartRodData(
                        toY: 85,
                        gradient: LinearGradient(
                          colors: [AppColors.success, AppColors.success.withOpacity(0.7)],
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
                ],
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.cardBorder,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Chart Legend/Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
              _buildChartStat('Total', 'Rp 4.350.000', AppColors.primaryText),
              _buildChartStat('Rata-rata', 'Rp 725.000', AppColors.success),
              _buildChartStat('Tertinggi', 'Rp 900.000', AppColors.prompt),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.descriptionText,
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aktivitas Terbaru',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 20),
          _buildActivityItem(
            'Iuran Bulanan - Pak Budi',
            '10 Oktober 2025',
            Icons.trending_up,
            AppColors.success,
          ),
          _buildActivityItem(
            'Perbaikan Jalan',
            '10 Oktober 2025',
            Icons.trending_down,
            AppColors.error,
          ),
          _buildActivityItem(
            'Kerja Bakti Lingkungan',
            '10 Oktober 2025',
            Icons.event,
            AppColors.primaryBlue,
          ),
          _buildActivityItem(
            'Rapat RW',
            '10 Oktober 2025',
            Icons.event,
            AppColors.primaryBlue,
          ),
          _buildActivityItem(
            'Pembagian Sembako',
            '10 Oktober 2025',
            Icons.event,
            AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String name, String date, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
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
                    color: AppColors.primaryText,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.descriptionText,
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
