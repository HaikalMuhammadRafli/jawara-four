import 'package:flutter/material.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../../../data/repositories/tagihan_repository.dart';
import '../../../../data/models/tagihan_model.dart';
import '../../../../utils/date_helpers.dart';
import '../../../../utils/number_helpers.dart';
import 'iuran_tagihan_detail_page.dart';
import 'iuran_tagihan_form_page.dart';

class IuranTagihanPage extends StatefulWidget {
  const IuranTagihanPage({super.key});

  @override
  State<IuranTagihanPage> createState() => _IuranTagihanPageState();
}

class _IuranTagihanPageState extends State<IuranTagihanPage> {
  final TagihanRepository _repository = TagihanRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFFFF),
      child: StreamBuilder<List<Tagihan>>(
        stream: _repository.getTagihanStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tagihanList = snapshot.data ?? [];

          if (tagihanList.isEmpty) {
            return const Center(child: Text('Belum ada data tagihan'));
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            itemCount: tagihanList.length,
            itemBuilder: (context, index) =>
                _buildTagihanCard(tagihanList[index]),
          );
        },
      ),
    );
  }

  Widget _buildTagihanCard(Tagihan tagihan) {
    final statusColor = tagihan.status == StatusTagihan.lunas
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
            tagihan.status.value,
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
        _buildSimpleInfoItem(
          'Total',
          NumberHelpers.formatCurrency(tagihan.total),
        ),
        _buildSimpleInfoItem(
          'Tanggal',
          DateHelpers.formatDate(tagihan.tanggal),
        ),
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
          } else if (label == 'Edit') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IuranTagihanDetailPage(tagihan: tagihan),
              ),
            );
          } else if (label == 'Edit') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IuranTagihanFormPage(tagihan: tagihan),
              ),
            );
          } else if (label == 'Hapus') {
            _showDeleteConfirmation(context, tagihan);
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

  void _showDeleteConfirmation(BuildContext context, Tagihan tagihan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tagihan'),
        content: Text(
          'Apakah Anda yakin ingin menghapus tagihan "${tagihan.judul}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              try {
                await _repository.deleteTagihan(tagihan.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tagihan berhasil dihapus')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus: $e')),
                  );
                }
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
