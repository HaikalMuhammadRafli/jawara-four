import 'package:flutter/material.dart';
import 'package:jawara_four/colors/app_colors.dart';
import 'package:jawara_four/data/models/kegiatan_model.dart';
import 'package:jawara_four/data/repositories/broadcast_repository.dart';
import 'package:jawara_four/data/repositories/kegiatan_repository.dart';
import 'package:jawara_four/utils/date_helpers.dart';
import 'package:jawara_four/utils/number_helpers.dart';

class WargaKegiatanMenuPage extends StatefulWidget {
  const WargaKegiatanMenuPage({super.key});

  @override
  State<WargaKegiatanMenuPage> createState() => _WargaKegiatanMenuPageState();
}

class _WargaKegiatanMenuPageState extends State<WargaKegiatanMenuPage> {
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
                child: _buildHeader(context),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHorizontalStats(),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildTimelineSection(),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kegiatan Warga',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          'Jadwal & Agenda Terbaru',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
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

  Widget _buildTimelineSection() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _kegiatanRepository.getKegiatanStream(),
      builder: (context, snapshot) {
        final List<Kegiatan> kegiatanList = (snapshot.data ?? []).map((data) {
          return Kegiatan.fromMap(data);
        }).toList();

        kegiatanList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final recentItems = kegiatanList.take(10).toList();

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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: const Center(
                  child: Text(
                    'Belum ada kegiatan terbaru',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
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
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getCategoryColor(item.kategori),
                      width: 3,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(
                              item.kategori,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.kategori,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getCategoryColor(item.kategori),
                            ),
                          ),
                        ),
                        Text(
                          DateHelpers.formatDateShort(item.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.nama,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.penanggungJawab,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
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

  Color _getCategoryColor(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'kerja bakti':
        return AppColors.primary;
      case 'rapat':
        return AppColors.secondary;
      case 'lomba':
        return AppColors.error;
      case 'sosialisasi':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }
}
