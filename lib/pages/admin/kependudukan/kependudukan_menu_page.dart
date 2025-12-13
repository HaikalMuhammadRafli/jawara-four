import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../../data/models/keluarga_model.dart';
import '../../../data/models/rumah_model.dart';
import '../../../data/models/warga_model.dart';
import '../../../data/repositories/keluarga_repository.dart';
import '../../../data/repositories/rumah_repository.dart';
import '../../../data/repositories/warga_repository.dart';
import '../../../utils/date_helpers.dart';
import '../../../utils/number_helpers.dart';

class KependudukanMenuPage extends StatefulWidget {
  const KependudukanMenuPage({super.key});

  @override
  State<KependudukanMenuPage> createState() => _KependudukanMenuPageState();
}

class _KependudukanMenuPageState extends State<KependudukanMenuPage> {
  final WargaRepository _wargaRepository = WargaRepository();
  final KeluargaRepository _keluargaRepository = KeluargaRepository();
  final RumahRepository _rumahRepository = RumahRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 40),
        child: Column(
          children: [
            _buildStatsSection(context),
            const SizedBox(height: 20),
            _buildMenuSection(context),
            const SizedBox(height: 20),
            _buildRecentActivitySection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return StreamBuilder<List<Warga>>(
      stream: _wargaRepository.getWargaStream(),
      builder: (context, wargaSnapshot) {
        return StreamBuilder<List<Keluarga>>(
          stream: _keluargaRepository.getKeluargaStream(),
          builder: (context, keluargaSnapshot) {
            return StreamBuilder<List<Rumah>>(
              stream: _rumahRepository.getRumahStream(),
              builder: (context, rumahSnapshot) {
                final int totalWarga = wargaSnapshot.data?.length ?? 0;
                final int totalKeluarga = keluargaSnapshot.data?.length ?? 0;
                final int totalRumah = rumahSnapshot.data?.length ?? 0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Kependudukan',
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
                            AppColors.primary.withValues(alpha: 0.1),
                            AppColors.primary.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
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
                                  AppColors.primary,
                                  AppColors.primary.withValues(alpha: 0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.groups_2_rounded,
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
                                  'Total Warga',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  NumberHelpers.formatNumber(totalWarga),
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Warga Terdaftar',
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Keluarga',
                            NumberHelpers.formatNumber(totalKeluarga),
                            Icons.family_restroom_rounded,
                            AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Rumah',
                            NumberHelpers.formatNumber(totalRumah),
                            Icons.home_rounded,
                            AppColors.softOrange,
                          ),
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
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: -0.8,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu Kependudukan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        // Row 1
        Row(
          children: [
            Expanded(
              child: _buildMenuCard(
                context,
                'Data Warga',
                Icons.person_rounded,
                AppColors.primary,
                'admin-kependudukan-warga',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMenuCard(
                context,
                'Keluarga',
                Icons.family_restroom_rounded,
                AppColors.success,
                'admin-kependudukan-keluarga',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMenuCard(
                context,
                'Rumah',
                Icons.home_rounded,
                AppColors.softOrange,
                'admin-kependudukan-rumah',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2
        Row(
          children: [
            Expanded(
              child: _buildMenuCard(
                context,
                'Mutasi',
                Icons.swap_horiz_rounded,
                const Color(0xFF7E57C2),
                'admin-mutasi-keluarga',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMenuCard(
                context,
                'Penerimaan',
                Icons.person_add_alt_1_rounded,
                const Color(0xFF26A69A),
                'admin-penerimaan-warga',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMenuCard(
                context,
                'Aspirasi',
                Icons.mail_outline_rounded,
                AppColors.warning,
                'admin-informasi-aspirasi',
              ),
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

  Widget _buildRecentActivitySection(BuildContext context) {
    return StreamBuilder<List<Warga>>(
      stream: _wargaRepository.getWargaStream(),
      builder: (context, wargaSnapshot) {
        return StreamBuilder<List<Keluarga>>(
          stream: _keluargaRepository.getKeluargaStream(),
          builder: (context, keluargaSnapshot) {
            return StreamBuilder<List<Rumah>>(
              stream: _rumahRepository.getRumahStream(),
              builder: (context, rumahSnapshot) {
                // Combine and sort activities
                final List<dynamic> allActivities = [
                  ...(wargaSnapshot.data ?? []),
                  ...(keluargaSnapshot.data ?? []),
                  ...(rumahSnapshot.data ?? []),
                ];

                allActivities.sort((a, b) {
                  DateTime dateA = a.createdAt;
                  DateTime dateB = b.createdAt;
                  return dateB.compareTo(dateA);
                });

                final recentActivities = allActivities.take(5).toList();

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
                            'Aktivitas Terbaru',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (recentActivities.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Belum ada aktivitas'),
                        )
                      else
                        ...recentActivities.map((item) {
                          if (item is Warga) {
                            return _buildActivityItem(
                              item.nama,
                              'Warga Baru',
                              DateHelpers.formatDateShort(item.createdAt),
                              AppColors.primary,
                            );
                          } else if (item is Keluarga) {
                            return _buildActivityItem(
                              'KK: ${item.nomorKK}',
                              'Keluarga Baru',
                              DateHelpers.formatDateShort(item.createdAt),
                              AppColors.success,
                            );
                          } else if (item is Rumah) {
                            return _buildActivityItem(
                              item.alamat,
                              'Rumah Baru',
                              DateHelpers.formatDateShort(item.createdAt),
                              AppColors.softOrange,
                            );
                          }
                          return const SizedBox();
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
    String title,
    String subtitle,
    String date,
    Color color,
  ) {
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
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
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
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
