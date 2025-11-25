import 'package:flutter/material.dart';
import 'package:jawara_four/colors/app_colors.dart';
import '../mocks/tagihan_mocks.dart';
import '../models/tagihan_model.dart';
import 'iuran_tagihan_detail_page.dart';

class IuranTagihanPage extends StatelessWidget {
  const IuranTagihanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFFFF),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: _buildTagihanList(),
      ),
    );
  }

  Widget _buildTagihanList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tagihanMock.length,
      itemBuilder: (context, index) => _buildTagihanCard(tagihanMock[index]),
    );
  }

  Widget _buildTagihanCard(Tagihan tagihan) {
    final statusColor = tagihan.status == 'Lunas'
        ? AppColors.success
        : AppColors.warning;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(tagihan, statusColor),
            const SizedBox(height: 12),
            _buildInfoRow(tagihan),
            const SizedBox(height: 12),
            _buildActionButtons(tagihan),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Tagihan tagihan, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tagihan.judul,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tagihan.kategori,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            tagihan.status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(Tagihan tagihan) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSimpleInfoItem('Total', tagihan.total),
        _buildSimpleInfoItem('Tanggal', tagihan.tanggal),
      ],
    );
  }

  Widget _buildActionButtons(Tagihan tagihan) {
    return Row(
      children: [
        Expanded(
          child: _buildSimpleActionButton(
            Icons.visibility_outlined,
            'Lihat',
            AppColors.textSecondary,
            tagihan,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSimpleActionButton(
            Icons.edit_outlined,
            'Edit',
            AppColors.primary,
            tagihan,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSimpleActionButton(
            Icons.delete_outline,
            'Hapus',
            AppColors.error,
            tagihan,
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleActionButton(
    IconData icon,
    String label,
    Color color,
    Tagihan tagihan,
  ) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          if (label == 'Lihat') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IuranTagihanDetailPage(tagihan: tagihan),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

