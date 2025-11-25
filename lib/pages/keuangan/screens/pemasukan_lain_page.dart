import 'package:flutter/material.dart';
import 'package:jawara_four/colors/app_colors.dart';

import '../../../data/../../data/repositories/pemasukan_repository.dart';
import '../../../data/models/pemasukan_model.dart';
import '../../../utils/date_helpers.dart';
import '../../../utils/number_helpers.dart';
import 'pemasukan_lain_detail_page.dart';
import 'pemasukan_lain_form_page.dart';

class PemasukanLainPage extends StatefulWidget {
  const PemasukanLainPage({super.key});

  @override
  State<PemasukanLainPage> createState() => _PemasukanLainPageState();
}

class _PemasukanLainPageState extends State<PemasukanLainPage> {
  final PemasukanRepository _repository = PemasukanRepository();

  void _navigateToForm({Pemasukan? pemasukan}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PemasukanLainFormPage(pemasukan: pemasukan),
      ),
    );
  }

  Future<void> _deletePemasukan(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pemasukan'),
        content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _repository.deletePemasukan(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pemasukan berhasil dihapus'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menghapus: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          StreamBuilder<List<Pemasukan>>(
            stream: _repository.getPemasukanStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Terjadi kesalahan: ${snapshot.error}'),
                );
              }

              final pemasukanList = snapshot.data ?? [];

              if (pemasukanList.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada data pemasukan',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: pemasukanList.length,
                itemBuilder: (context, index) =>
                    _buildPemasukanCard(pemasukanList[index]),
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () => _navigateToForm(),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPemasukanList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pemasukanMock.length,
      itemBuilder: (context, index) => _buildPemasukanCard(pemasukanMock[index]),
    );
  }

  Widget _buildPemasukanCard(Pemasukan pemasukan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPemasukanHeader(pemasukan),
            const SizedBox(height: 12),
            _buildPemasukanInfo(pemasukan),
            const SizedBox(height: 12),
            _buildPemasukanActions(pemasukan),
          ],
        ),
      ),
    );
  }

  Widget _buildPemasukanHeader(Pemasukan pemasukan) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pemasukan.judul,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(pemasukan.kategori, style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Masuk',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildPemasukanInfo(Pemasukan pemasukan) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoItem('Jumlah', NumberHelpers.formatCurrency(pemasukan.jumlah)),
        _buildInfoItem('Tanggal', DateHelpers.formatDateShort(pemasukan.tanggal)),
      ],
    );
  }

  Widget _buildPemasukanActions(Pemasukan pemasukan) {
    return Row(
      children: [
        Expanded(
          child: _buildSimpleActionButton(
            Icons.visibility_outlined,
            'Lihat',
            Colors.grey,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PemasukanLainDetailPage(pemasukan: pemasukan),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSimpleActionButton(Icons.edit_outlined, 'Edit', Colors.blue, () => _navigateToForm(pemasukan: pemasukan)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSimpleActionButton(Icons.delete_outline, 'Hapus', Colors.red, () => _deletePemasukan(pemasukan.id)),
        ),
      ],
    );
  }

  Widget _buildSimpleActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
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
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
