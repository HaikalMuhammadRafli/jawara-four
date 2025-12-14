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
                child: _buildHeader(),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildMosaicSection(),
                    const SizedBox(height: 20),
                    _buildStatsRow(),
                    const SizedBox(height: 24),
                    _buildMenuGrid(context),
                    const SizedBox(height: 24),
                    _buildRecentActivitySection(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
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
              'Kependudukan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Statistik Kependudukan',
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
            Icons.people_alt_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildMosaicSection() {
    return StreamBuilder<List<Warga>>(
      stream: _wargaRepository.getWargaStream(),
      builder: (context, snapshot) {
        final int totalWarga = snapshot.data?.length ?? 0;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Card (Flex 7)
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.all(24),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.groups_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            NumberHelpers.formatNumber(totalWarga),
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1,
                              letterSpacing: -2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total Warga',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Quick Actions (Flex 3)
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        Icons.person_add_rounded,
                        const Color(0xFFFFA726),
                        'admin-warga-form',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        Icons.transfer_within_a_station_rounded,
                        const Color(0xFFEF5350),
                        'admin-mutasi-keluarga-tambah',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    IconData icon,
    Color color,
    String routeName,
  ) {
    return GestureDetector(
      onTap: () {
        try {
          context.pushNamed(routeName);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Route not found: $routeName')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Center(child: Icon(icon, color: color, size: 28)),
      ),
    );
  }

  Widget _buildStatsRow() {
    return StreamBuilder<List<Keluarga>>(
      stream: _keluargaRepository.getKeluargaStream(),
      builder: (context, keluargaSnapshot) {
        return StreamBuilder<List<Rumah>>(
          stream: _rumahRepository.getRumahStream(),
          builder: (context, rumahSnapshot) {
            final totalFamily = keluargaSnapshot.data?.length ?? 0;
            final totalHouse = rumahSnapshot.data?.length ?? 0;

            return Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Keluarga',
                    '$totalFamily',
                    Icons.house_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    'Rumah',
                    '$totalHouse',
                    Icons.home_work_rounded,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
          'Menu Manajemen',
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
              'Data Warga',
              Icons.people_outline,
              'admin-kependudukan-warga',
            ),
            _buildMenuCard(
              context,
              'Data Keluarga',
              Icons.family_restroom,
              'admin-kependudukan-keluarga',
            ),
            _buildMenuCard(
              context,
              'Data Rumah',
              Icons.home_rounded,
              'admin-kependudukan-rumah',
            ),
            _buildMenuCard(
              context,
              'Mutasi Keluarga',
              Icons.swap_horiz_rounded,
              'admin-mutasi-keluarga',
            ),
            _buildMenuCard(
              context,
              'Penerimaan Warga',
              Icons.person_add_alt_1_rounded,
              'admin-penerimaan-warga',
            ),
            _buildMenuCard(
              context,
              'Aspirasi',
              Icons.chat_bubble_outline_rounded,
              'admin-informasi-aspirasi',
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

  Widget _buildRecentActivitySection() {
    return StreamBuilder<List<Warga>>(
      stream: _wargaRepository.getWargaStream(),
      builder: (context, wargaSnapshot) {
        // Just showing Warga for now as "New Arrivals"
        final recentWarga = (wargaSnapshot.data ?? []).take(10).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Warga Baru Ditambahkan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (recentWarga.isEmpty)
              const Text('Belum ada data warga.')
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: recentWarga
                      .map((warga) => _buildAvatarItem(warga))
                      .toList(),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAvatarItem(Warga warga) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 70,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2), // White border
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                warga.nama.isNotEmpty ? warga.nama[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            warga.nama,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            DateHelpers.formatDateShort(warga.createdAt),
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
