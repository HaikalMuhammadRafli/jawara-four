import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_four/colors/app_colors.dart';
import 'package:jawara_four/data/models/broadcast_model.dart';
import 'package:jawara_four/data/repositories/broadcast_repository.dart';
import 'package:jawara_four/utils/date_helpers.dart';

class WargaBroadcastPage extends StatefulWidget {
  const WargaBroadcastPage({super.key});

  @override
  State<WargaBroadcastPage> createState() => _WargaBroadcastPageState();
}

class _WargaBroadcastPageState extends State<WargaBroadcastPage> {
  final BroadcastRepository _broadcastRepository = BroadcastRepository();
  String _searchQuery = '';
  String _selectedKategori = 'Semua';

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.softPurple.withValues(alpha: 0.1),
                  AppColors.softPurple.withValues(alpha: 0.05),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.softPurple.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.campaign_rounded,
              size: 64,
              color: AppColors.softPurple.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum Ada Broadcast',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Broadcast yang tersedia akan muncul di sini',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Search and Filter
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Cari broadcast...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundGray.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Kategori Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildKategoriChip('Semua'),
                      _buildKategoriChip('Informasi'),
                      _buildKategoriChip('Pengumuman'),
                      _buildKategoriChip('Peringatan'),
                      _buildKategoriChip('Undangan'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Broadcast List
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _broadcastRepository.getBroadcastStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final broadcastMaps = snapshot.data ?? [];
                final broadcastList = broadcastMaps
                    .map((map) => Broadcast.fromMap(map))
                    .toList();

                if (broadcastList.isEmpty) {
                  return _buildEmptyState();
                }

                // Filter by search and kategori
                final filteredList = broadcastList.where((broadcast) {
                  final matchesSearch = broadcast.judul.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  );
                  final matchesKategori =
                      _selectedKategori == 'Semua' ||
                      broadcast.kategori == _selectedKategori;
                  return matchesSearch && matchesKategori;
                }).toList();

                if (filteredList.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada broadcast yang sesuai',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    return _buildBroadcastCard(filteredList[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriChip(String kategori) {
    final isSelected = _selectedKategori == kategori;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(kategori),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedKategori = kategori);
        },
        backgroundColor: Colors.white,
        selectedColor: AppColors.softPurple.withValues(alpha: 0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.softPurple : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected
              ? AppColors.softPurple.withValues(alpha: 0.5)
              : AppColors.divider,
        ),
      ),
    );
  }

  Widget _buildBroadcastCard(Broadcast broadcast) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.pushNamed('warga-broadcast-detail', extra: broadcast);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getKategoriColor(
                          broadcast.kategori,
                        ).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getKategoriColor(
                            broadcast.kategori,
                          ).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        broadcast.kategori,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _getKategoriColor(broadcast.kategori),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (broadcast.prioritas.toLowerCase() == 'tinggi')
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.priority_high,
                              size: 12,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Penting',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  broadcast.judul,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  broadcast.isi,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      broadcast.pengirim,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateHelpers.formatDateShort(broadcast.tanggal),
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getKategoriColor(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'informasi':
        return Colors.blue;
      case 'pengumuman':
        return Colors.orange;
      case 'peringatan':
        return Colors.red;
      case 'undangan':
        return Colors.purple;
      default:
        return AppColors.softPurple;
    }
  }
}
