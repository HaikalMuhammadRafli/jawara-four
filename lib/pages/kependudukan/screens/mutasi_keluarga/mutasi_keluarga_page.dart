import 'package:flutter/material.dart';

import '../../../../data/mocks/mutasi_keluarga_mocks.dart';
import '../../../../data/models/mutasi_keluarga_model.dart';
import '../../../../utils/date_helpers.dart';
import '../../../../utils/ui_helpers.dart';

class MutasiKeluargaPage extends StatefulWidget {
  const MutasiKeluargaPage({super.key});

  @override
  State<MutasiKeluargaPage> createState() => _MutasiKeluargaPageState();
}

class _MutasiKeluargaPageState extends State<MutasiKeluargaPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _buildSearchAndFilter(),
            Expanded(child: _buildMutasiKeluargaList()),
          ],
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withAlpha((0.3 * 255).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    title: const Text('Tambah Mutasi Keluarga'),
                    content: const Text('Fitur ini belum bisa digunakan saat ini.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
                    ],
                  ),
                );
              },
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari keluarga...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Semua', true),
                const SizedBox(width: 8),
                _buildFilterChip('Pindah Rumah', false),
                const SizedBox(width: 8),
                _buildFilterChip('Pindah Domisili', false),
                const SizedBox(width: 8),
                _buildFilterChip('Lainnya', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {},
      selectedColor: Colors.green[100],
      checkmarkColor: Colors.green,
      labelStyle: TextStyle(
        color: isSelected ? Colors.green : Colors.grey[600],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildMutasiKeluargaList() {
    final List<MutasiKeluarga> mutasiKeluargaData = mutasiKeluargaMock;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: mutasiKeluargaData.length,
      itemBuilder: (context, index) {
        final mutasiKeluarga = mutasiKeluargaData[index];
        return _buildMutasiKeluargaCard(mutasiKeluarga);
      },
    );
  }

  void _showDetailDialog(BuildContext context, MutasiKeluarga keluarga) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                UIHelpers.getMutasiIcon(keluarga.jenisMutasi),
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(keluarga.keluarga, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Keluarga: ${keluarga.keluarga}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text(
              'Tanggal: ${DateHelpers.formatDate(keluarga.tanggal)}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text('Jenis Mutasi: ${keluarga.jenisMutasi}', style: const TextStyle(fontSize: 14)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))],
      ),
    );
  }

  Widget _buildMutasiKeluargaCard(MutasiKeluarga keluarga) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.1 * 255).round()),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!, width: 1),
                ),
                child: Icon(
                  UIHelpers.getMutasiIcon(keluarga.jenisMutasi),
                  color: Colors.green,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  keluarga.keluarga,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  keluarga.jenisMutasi.value,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_month, size: 16, color: Colors.grey[400]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  DateHelpers.formatDate(keluarga.tanggal),
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
              IconButton(
                onPressed: () => _showDetailDialog(context, keluarga),
                icon: const Icon(Icons.visibility, size: 18, color: Colors.grey),
                tooltip: 'Lihat Detail',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
