import 'package:flutter/material.dart';

import '../../mocks/informasi_aspirasi_mocks.dart';
import '../../models/informasi_aspirasi_model.dart';

// ==================== DEFINISI WARNA ====================
const Color primaryBlue = Color(0xFF1E88E5);
const Color softPurple = Color(0xFF7E57C2);
const Color backgroundWhite = Color(0xFFFFFFFF);
const Color textPrimary = Color(0xFF212121);
const Color textSecondary = Color(0xFF757575);
const Color dividerGray = Color(0xFFE0E0E0);

class InformasiAspirasiPage extends StatefulWidget {
  const InformasiAspirasiPage({super.key});

  @override
  State<InformasiAspirasiPage> createState() => _InformasiAspirasiPageState();
}

class _InformasiAspirasiPageState extends State<InformasiAspirasiPage> {
  String _searchQuery = '';
  String _selectedStatus = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundWhite,
      child: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundWhite,
        border: Border(bottom: BorderSide(color: dividerGray.withOpacity(0.6), width: 1.5)),
      ),
      child: Column(
        children: [
          TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Cari pengirim atau judul...',
              hintStyle: TextStyle(color: textSecondary, fontSize: 15),
              prefixIcon: Icon(Icons.search_rounded, color: textSecondary, size: 22),
              filled: true,
              fillColor: dividerGray.withOpacity(0.15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: primaryBlue, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Semua'),
                const SizedBox(width: 10),
                _buildFilterChip('Diterima'),
                const SizedBox(width: 10),
                _buildFilterChip('Diproses'),
                const SizedBox(width: 10),
                _buildFilterChip('Ditolak'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedStatus == label;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? primaryBlue : backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? primaryBlue : dividerGray.withOpacity(0.6),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedStatus = label),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? backgroundWhite : textSecondary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    final List<InformasiAspirasi> data = informasiAspirasiMock.where((i) {
      final matchesQuery =
          _searchQuery.isEmpty ||
          i.pengirim.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          i.judul.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatus == 'Semua' || i.status == _selectedStatus;
      return matchesQuery && matchesStatus;
    }).toList();

    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded, size: 80, color: textSecondary.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              'Tidak ada data aspirasi',
              style: TextStyle(fontSize: 16, color: textSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: data.length,
      itemBuilder: (context, index) => _buildCard(data[index]),
    );
  }

  Widget _buildCard(InformasiAspirasi item) {
    Color statusColor;
    switch (item.status.toLowerCase()) {
      case 'diterima':
        statusColor = const Color(0xFF43A047);
        break;
      case 'diproses':
        statusColor = const Color(0xFFFB8C00);
        break;
      case 'ditolak':
        statusColor = const Color(0xFFE53935);
        break;
      default:
        statusColor = textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dividerGray.withOpacity(0.6), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [softPurple.withOpacity(0.2), softPurple.withOpacity(0.1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: softPurple.withOpacity(0.25), width: 1.5),
                ),
                child: Icon(Icons.mail_outline_rounded, color: softPurple, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.judul,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        letterSpacing: -0.3,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.person_outline_rounded, size: 16, color: textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.pengirim,
                            style: TextStyle(
                              fontSize: 13,
                              color: textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withOpacity(0.2), width: 1),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: dividerGray.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 14, color: textSecondary),
                const SizedBox(width: 6),
                Text(
                  item.tanggalDibuat,
                  style: TextStyle(fontSize: 12, color: textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildActionButton('Detail', Icons.visibility_outlined, primaryBlue),
              const SizedBox(width: 8),
              _buildActionButton('Proses', Icons.edit_outlined, const Color(0xFFFB8C00)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Handle action
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
