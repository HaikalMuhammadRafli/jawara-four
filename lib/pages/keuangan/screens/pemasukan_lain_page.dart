import 'package:flutter/material.dart';
import '../mocks/pemasukan_mocks.dart';
import '../models/pemasukan_model.dart';
import 'pemasukan_lain_detail_page.dart';

class PemasukanLainPage extends StatelessWidget {
  const PemasukanLainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: _buildPemasukanList(),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.blue,
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
      itemBuilder: (context, index) =>
          _buildPemasukanCard(pemasukanMock[index]),
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
              Text(
                pemasukan.kategori,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Masuk',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPemasukanInfo(Pemasukan pemasukan) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoItem('Jumlah', pemasukan.jumlah),
        _buildInfoItem('Tanggal', pemasukan.tanggal),
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
            pemasukan,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSimpleActionButton(
            Icons.edit_outlined,
            'Edit',
            Colors.blue,
            pemasukan,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildSimpleActionButton(
            Icons.delete_outline,
            'Hapus',
            Colors.red,
            pemasukan,
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleActionButton(
    IconData icon,
    String label,
    Color color,
    Pemasukan pemasukan,
  ) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          if (label == 'Lihat') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PemasukanLainDetailPage(pemasukan: pemasukan),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
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

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
