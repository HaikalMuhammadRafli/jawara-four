import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../../data/models/kegiatan_model.dart';
import '../../../data/repositories/broadcast_repository.dart';
import '../../../data/repositories/kegiatan_repository.dart';
import '../../../utils/date_helpers.dart';
import '../../../utils/number_helpers.dart';
import '../../../utils/ui_helpers.dart';

class KegiatanMenuPage extends StatefulWidget {
  const KegiatanMenuPage({super.key});

  @override
  State<KegiatanMenuPage> createState() => _KegiatanMenuPageState();
}

class _KegiatanMenuPageState extends State<KegiatanMenuPage> {
  final KegiatanRepository _kegiatanRepository = KegiatanRepository();
  final BroadcastRepository _broadcastRepository = BroadcastRepository();

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
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHorizontalStats(),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildMenuActions(context),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildTimelineSection(),
                    ),
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
              'Kegiatan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Live Event Timeline',
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
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalStats() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _kegiatanRepository.getKegiatanStream(),
      builder: (context, kegiatanSnapshot) {
        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: _broadcastRepository.getBroadcastStream(),
          builder: (context, broadcastSnapshot) {
            final int totalKegiatan = kegiatanSnapshot.data?.length ?? 0;
            final int totalBroadcast = broadcastSnapshot.data?.length ?? 0;

            final activeKegiatan =
                kegiatanSnapshot.data?.where((k) {
                  final String? status = k['status'] as String?;
                  return status != 'Terlaksana';
                }).length ??
                0;

            final finishedKegiatan = totalKegiatan - activeKegiatan;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStatPill(
                    'Total',
                    NumberHelpers.formatNumber(totalKegiatan),
                    Icons.dashboard_rounded,
                    AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  _buildStatPill(
                    'Aktif',
                    NumberHelpers.formatNumber(activeKegiatan),
                    Icons.timer,
                    const Color(0xFFFFA726),
                  ),
                  const SizedBox(width: 12),
                  _buildStatPill(
                    'Selesai',
                    NumberHelpers.formatNumber(finishedKegiatan),
                    Icons.check_circle,
                    const Color(0xFF66BB6A),
                  ),
                  const SizedBox(width: 12),
                  _buildStatPill(
                    'Broadcast',
                    NumberHelpers.formatNumber(totalBroadcast),
                    Icons.campaign,
                    const Color(0xFFEF5350),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatPill(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
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

  Widget _buildMenuActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            'Manage\nKegiatan',
            Icons.edit_calendar_rounded,
            const Color(0xFF5C6BC0),
            'admin-kegiatan',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            context,
            'Broadcast\nMessage',
            Icons.send_rounded,
            const Color(0xFFAB47BC),
            'admin-broadcast',
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String routeName,
  ) {
    return GestureDetector(
      onTap: () => context.pushNamed(routeName),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                icon,
                size: 60,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final isDone = status == 'Terlaksana';
    final color = isDone ? AppColors.success : const Color(0xFF1976D2);
    final label = isDone ? 'Selesai' : 'On Going';
    final icon = isDone ? Icons.check_circle_rounded : Icons.timelapse_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _kegiatanRepository.getKegiatanStream(),
      builder: (context, snapshot) {
        final List<Kegiatan> kegiatanList = (snapshot.data ?? []).map((data) {
          return Kegiatan.fromMap(data);
        }).toList();

        kegiatanList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final recentItems = kegiatanList.take(6).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 16),
              child: Text(
                'Timeline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (recentItems.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No activities yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentItems.length,
                itemBuilder: (context, index) {
                  final item = recentItems[index];
                  final isLast = index == recentItems.length - 1;
                  return _buildTimelineItem(item, isLast);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildTimelineItem(Kegiatan item, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Line
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: UIHelpers.getKegiatanColor(item.kategori),
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: isLast
                      ? const SizedBox()
                      : Container(
                          width: 2,
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                ),
              ],
            ),
          ),
          // Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: UIHelpers.getKegiatanColor(
                              item.kategori,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.kategori,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: UIHelpers.getKegiatanColor(item.kategori),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            _buildStatusChip(item.status),
                            const SizedBox(width: 8),
                            Text(
                              DateHelpers.formatDateShort(item.tanggal),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.nama,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1, // Prevent overflow
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.penanggungJawab,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
