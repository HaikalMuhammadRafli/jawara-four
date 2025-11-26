import 'package:flutter/material.dart';

import '../../../data/mocks/user_profile_mocks.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../utils/ui_helpers.dart';

class PenggunaPage extends StatelessWidget {
  const PenggunaPage({super.key});

  void _showEditDialog(BuildContext context, UserProfile item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Pengguna'),
        content: Text(
          'Edit data untuk "${item.nama}" (dummy)\nFungsionalitas belum diaktifkan.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, UserProfile item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Pengguna'),
        content: Text(
          'Konfirmasi hapus "${item.nama}" (dummy)\nFungsionalitas belum diaktifkan.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final penggunaList = userProfileMock; // hanya data dummy

    return penggunaList.isEmpty
        ? _buildEmptyState()
        : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: penggunaList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = penggunaList[index];
                    return _buildPenggunaCard(context, item);
                  },
                ),
              ],
            ),
          );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
            child: Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum Ada Pengguna',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap tombol + untuk menambah pengguna baru',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildPenggunaCard(BuildContext context, UserProfile item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              // No background color for the header; keep rounded corners only
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: UIHelpers.getUserColor(item.role),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: UIHelpers.getUserColor(item.role).withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(UIHelpers.getUserIcon(item.role), color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xFF212121),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: UIHelpers.getUserColor(item.role).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: UIHelpers.getUserColor(item.role).withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    item.role.value,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: UIHelpers.getUserColor(item.role),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.email_outlined, size: 16, color: const Color(0xFF757575)),
                    const SizedBox(width: 4),
                    Text(
                      item.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showEditDialog(context, item),
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1E88E5),
                          side: const BorderSide(color: Color(0xFF1E88E5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showDeleteDialog(context, item),
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text('Hapus'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFE53E3E),
                          side: const BorderSide(color: Color(0xFFE53E3E)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
