import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';
import 'package:jawara_four/data/models/broadcast_model.dart';
import 'package:jawara_four/data/models/kegiatan_model.dart';
import 'package:jawara_four/data/models/user_profile_model.dart';
import 'package:jawara_four/data/repositories/broadcast_repository.dart';
import 'package:jawara_four/data/repositories/kegiatan_repository.dart';
import 'package:jawara_four/data/repositories/user_repository.dart';
import 'package:jawara_four/services/auth_service.dart';
import 'package:jawara_four/utils/date_helpers.dart';

class WargaDashboardMenuPage extends StatelessWidget {
  const WargaDashboardMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Soft gray background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              const SizedBox(height: 24),
              _buildBentoGrid(context),
              const SizedBox(height: 24),
              _buildActivitySection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final authService = AuthService();
    final userRepository = UserRepository();
    final currentUser = authService.currentUser;

    return StreamBuilder<UserProfile?>(
      stream: currentUser != null
          ? userRepository.getUserProfileStream(currentUser.uid)
          : Stream.value(null),
      builder: (context, snapshot) {
        final userProfile = snapshot.data;
        final displayName =
            currentUser?.displayName ??
            currentUser?.email?.split('@')[0] ??
            'Warga';
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
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Selamat datang di Dashboard Warga',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  displayName.isNotEmpty ? displayName[0].toUpperCase() : 'W',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBentoGrid(BuildContext context) {
    return SizedBox(
      height: 340, // Fixed height for consistency
      child: Row(
        children: [
          // Left Column: Quick Actions (2/3 width)
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildBentoActionCard(
                          context,
                          'Aspirasi',
                          Icons.campaign_rounded,
                          const Color(0xFF5C6BC0), // Indigo
                          () => context.pushNamed('warga-aspirasi-form'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildBentoActionCard(
                          context,
                          'Kegiatan',
                          Icons.event_note_rounded,
                          const Color(0xFF26A69A), // Teal
                          () => context.pushNamed('warga-kegiatan'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildBentoActionCard(
                          context,
                          'Keuangan',
                          Icons.account_balance_wallet_rounded,
                          const Color(0xFF66BB6A), // Green
                          () => context.pushNamed('warga-keuangan'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildBentoActionCard(
                          context,
                          'Broadcast',
                          Icons.notifications_active_rounded,
                          const Color(0xFFFFA726), // Orange
                          () => context.pushNamed('warga-broadcast'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Right Column: Latest Query/Info (1/3 width) - e.g. Next Activity Highlight
          Expanded(flex: 1, child: _buildHighlightCard(context)),
        ],
      ),
    );
  }

  Widget _buildBentoActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightCard(BuildContext context) {
    // Shows the nearest upcoming activity or broadcast count
    final kegiatanRepo = KegiatanRepository();

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: kegiatanRepo.getKegiatanStream(),
      builder: (context, snapshot) {
        final kegiatanList = (snapshot.data ?? [])
            .map((map) => Kegiatan.fromMap(map))
            .toList();
        final upcoming = kegiatanList
            .where((k) => k.tanggal.isAfter(DateTime.now()))
            .toList();

        // Find nearest
        upcoming.sort((a, b) => a.tanggal.compareTo(b.tanggal));
        final nearest = upcoming.isNotEmpty ? upcoming.first : null;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF42A5F5), const Color(0xFF1E88E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E88E5).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(
                nearest != null ? 'Segera Hadir' : 'Tidak Ada',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                nearest?.nama ?? 'Kegiatan',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              if (nearest != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    DateHelpers.formatDateShort(nearest.tanggal),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E88E5),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActivitySection(BuildContext context) {
    final broadcastRepo = BroadcastRepository();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informasi Terbaru',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: broadcastRepo.getBroadcastStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final broadcasts = (snapshot.data ?? [])
                .map((m) => Broadcast.fromMap(m))
                .take(4) // Show 4 most recent
                .toList();

            if (broadcasts.isEmpty) {
              return Center(
                child: Text(
                  'Belum ada informasi.',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: broadcasts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = broadcasts[index];
                return _buildBroadcastCard(item);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBroadcastCard(Broadcast item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.article_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.judul,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.isi,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${item.tanggal.day}/${item.tanggal.month}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
