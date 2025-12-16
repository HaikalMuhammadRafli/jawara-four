import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:jawara_four/colors/app_colors.dart';
import 'package:jawara_four/data/models/broadcast_model.dart';
import 'package:jawara_four/data/models/kegiatan_model.dart';
import 'package:jawara_four/data/models/user_profile_model.dart';
import 'package:jawara_four/data/repositories/broadcast_repository.dart';
import 'package:jawara_four/data/repositories/kegiatan_repository.dart';
import 'package:jawara_four/data/repositories/user_repository.dart';
import 'package:jawara_four/services/auth_service.dart';

class WargaDashboardMenuPage extends StatelessWidget {
  const WargaDashboardMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E88E5), // Admin Blue Theme
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildBentoGrid(context),
                  const SizedBox(height: 24),
                  _buildActivitySection(context),
                  const SizedBox(height: 80), // Bottom padding
                ],
              ),
            ),
          ],
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
        final displayName =
            currentUser?.displayName ??
            currentUser?.email?.split('@')[0] ??
            'Warga';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Halo, $displayName',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.waving_hand_rounded,
                  color: Colors.amber,
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Selamat Datang di Dashboard Warga',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBentoGrid(BuildContext context) {
    return Column(
      children: [
        // Highlight Card (Full Width)
        SizedBox(height: 180, child: _buildHighlightCard(context)),
        const SizedBox(height: 16),
        // Quick Actions Grid (2x2)
        SizedBox(
          height: 240,
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
      ],
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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
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
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
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
    // Shows the nearest upcoming activity in a Calendar Style
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

        // Default if no event
        final date = nearest?.tanggal ?? DateTime.now();

        // Use DateFormat for safe parsing
        final monthName = DateFormat(
          'MMMM',
          'id_ID',
        ).format(date); // "Desember"
        final dayName = DateFormat('EEEE', 'id_ID').format(date); // "Senin"
        final dayNumber = date.day.toString();

        final eventName = nearest?.nama ?? 'Tidak Ada Jadwal';
        final eventTime = nearest != null
            ? '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}'
            : '--:--';
        final eventCategory = nearest?.kategori ?? 'Umum';

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            // Removed Shadow
          ),
          child: Column(
            children: [
              // Blue "Binder" Strip Top
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFF1976D2), // Calendar Blue
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.event_available_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$dayName, $monthName'.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // Body
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  children: [
                    // Big Date with faint background
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD), // Light Blue
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        dayNumber,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Event Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: nearest != null
                                      ? const Color(
                                          0xFF1565C0,
                                        ).withValues(alpha: 0.1)
                                      : Colors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  eventCategory,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: nearest != null
                                        ? const Color(0xFF1565C0)
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (nearest != null)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_rounded,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      eventTime,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            eventName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Location or placeholder
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  nearest?.lokasi ?? 'Lokasi tidak tersedia',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
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
