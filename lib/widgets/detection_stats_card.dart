import 'package:flutter/material.dart';
import 'package:jawara_four/colors/app_colors.dart';

class DetectionStatsCard extends StatelessWidget {
  final int frameCount;
  final int successCount;
  final int captureTime;
  final int apiCallTime;
  final int totalTime;

  const DetectionStatsCard({
    super.key,
    required this.frameCount,
    required this.successCount,
    this.captureTime = 0,
    this.apiCallTime = 0,
    this.totalTime = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Frame count
          _buildStatItem(
            icon: Icons.image_outlined,
            label: 'Frame',
            value: frameCount.toString(),
            color: AppColors.primary,
          ),
          _buildDivider(),

          // Success count (angka, bukan %)
          _buildStatItem(
            icon: Icons.check_circle_outline,
            label: 'Sukses',
            value: successCount.toString(),
            color: AppColors.success,
          ),
          _buildDivider(),

          // Capture time
          _buildStatItem(
            icon: Icons.camera_alt_outlined,
            label: 'Capture',
            value: '${captureTime}ms',
            color: const Color(0xFFFB8C00),
          ),
          _buildDivider(),

          // API/Processing time
          _buildStatItem(
            icon: Icons.cloud_upload_outlined,
            label: 'API',
            value: '${apiCallTime}ms',
            color: const Color(0xFF7B1FA2),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 8,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: color,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 24,
      width: 1,
      color: Colors.grey.withValues(alpha: 0.2),
      margin: const EdgeInsets.symmetric(horizontal: 2),
    );
  }
}
