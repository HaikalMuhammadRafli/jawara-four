import 'package:flutter/material.dart';
import 'package:jawara_four/data/repositories/kategori_iuran_repository.dart';
import 'package:jawara_four/data/models/kategori_iuran_model.dart';
import '../screens/kategori_iuran_form_page.dart';

class KategoriIuranPage extends StatefulWidget {
  const KategoriIuranPage({super.key});

  @override
  State<KategoriIuranPage> createState() => _KategoriIuranPageState();
}

class _KategoriIuranPageState extends State<KategoriIuranPage> {
  final KategoriIuranRepository _repository = KategoriIuranRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFFFF),
      child: StreamBuilder<List<KategoriIuran>>(
        stream: _repository.getKategoriStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final kategoriList = snapshot.data ?? [];

          if (kategoriList.isEmpty) {
            return const Center(child: Text('Belum ada kategori iuran'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            child: _buildKategoriList(kategoriList),
          );
        },
      ),
    );
  }

  Widget _buildKategoriList(List<KategoriIuran> kategoriList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kategoriList.length,
      itemBuilder: (context, index) => _buildKategoriCard(kategoriList[index]),
    );
  }

  Widget _buildKategoriCard(KategoriIuran kategori) {
    final statusColor = kategori.status == 'Aktif'
        ? Colors.green
        : Colors.orange;
    final categoryColor = _getCategoryColor(kategori.warna);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildKategoriHeader(kategori, statusColor, categoryColor),
                const SizedBox(height: 8),
                _buildKategoriInfo(kategori),
                const SizedBox(height: 8),
                _buildKategoriActions(kategori),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKategoriHeader(
    KategoriIuran kategori,
    Color statusColor,
    Color categoryColor,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: categoryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: categoryColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Icon(Icons.category_rounded, color: categoryColor, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kategori.nama,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                kategori.deskripsi,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            kategori.status.value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKategoriInfo(KategoriIuran kategori) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.schedule, color: Colors.blue[600], size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Periode Pembayaran',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                kategori.periode,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriActions(KategoriIuran kategori) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KategoriIuranFormPage(kategori: kategori),
              ),
            );
          },
          icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.orange),
          tooltip: 'Edit',
        ),
        IconButton(
          onPressed: () => _showDeleteConfirmation(kategori),
          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
          tooltip: 'Hapus',
        ),
      ],
    );
  }

  void _showDeleteConfirmation(KategoriIuran kategori) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kategori'),
        content: Text(
          'Apakah Anda yakin ingin menghapus kategori "${kategori.nama}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _repository.deleteKategori(kategori.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kategori berhasil dihapus')),
                  );
                }
              } catch (e) {
                if (mounted) {
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

  Color _getCategoryColor(String colorName) {
    switch (colorName) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'red':
        return Colors.red;
      case 'teal':
        return Colors.teal;
      case 'brown':
        return Colors.brown;
      case 'pink':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}
