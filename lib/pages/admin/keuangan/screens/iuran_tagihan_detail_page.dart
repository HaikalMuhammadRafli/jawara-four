import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:jawara_four/colors/app_colors.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/models/pemasukan_model.dart';
import '../../../../data/models/tagihan_model.dart';
import '../../../../data/repositories/pemasukan_repository.dart';
import '../../../../data/repositories/tagihan_repository.dart';
import '../../../../utils/number_helpers.dart';

class IuranTagihanDetailPage extends StatefulWidget {
  final Tagihan tagihan;

  const IuranTagihanDetailPage({super.key, required this.tagihan});

  @override
  State<IuranTagihanDetailPage> createState() => _IuranTagihanDetailPageState();
}

class _IuranTagihanDetailPageState extends State<IuranTagihanDetailPage> {
  final TagihanRepository _tagihanRepository = TagihanRepository();
  final PemasukanRepository _pemasukanRepository = PemasukanRepository();
  bool _isLoading = false;

  Future<void> _approveTagihan() async {
    setState(() => _isLoading = true);

    try {
      // 1. Update Tagihan Status to Lunas
      final updatedTagihan = widget.tagihan.copyWith(
        status: StatusTagihan.lunas,
        updatedAt: DateTime.now(),
      );
      await _tagihanRepository.updateTagihan(updatedTagihan);

      // 2. Create Pemasukan Record
      final pemasukan = Pemasukan(
        id: const Uuid().v4(),
        judul: 'Iuran ${widget.tagihan.judul}',
        nama: widget.tagihan.namaKeluarga,
        jumlah: widget.tagihan.total,
        kategori: widget.tagihan.kategori,
        tanggal: DateTime.now(),
        keterangan: 'Otomatis dari Iuran ${widget.tagihan.kodeTagihan}',
        jenisPemasukan: 'Iuran',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _pemasukanRepository.addPemasukan(pemasukan);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tagihan disetujui dan dicatat ke Pemasukan'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memproses: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _rejectTagihan(String reason) async {
    // Implement rejection logic here if needed (e.g. just update status)
    setState(() => _isLoading = true);
    try {
      // Example: just popping for now as per previous placeholder
      // In real scenario, update status to 'Pending' or 'Rejected' if enum exists
      context.pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tagihan ditolak')));
    } catch (e) {
      // handle error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: Text(
          'Detail Iuran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 16),
                  _buildInfoCard(),
                  const SizedBox(height: 16),
                  _buildStatusCard(),
                  const SizedBox(height: 16),
                  if (widget.tagihan.status == StatusTagihan.pending)
                    _buildActionButtons(context),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderCard() {
    final statusColor = widget.tagihan.status == StatusTagihan.lunas
        ? AppColors.success
        : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.receipt_long, color: statusColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tagihan.judul,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.tagihan.kategori,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.tagihan.status.value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Tagihan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Kode Iuran', widget.tagihan.kodeTagihan),
          const SizedBox(height: 12),
          _buildInfoRow('Nama Iuran', widget.tagihan.judul),
          const SizedBox(height: 12),
          _buildInfoRow('Kategori', widget.tagihan.kategori),
          const SizedBox(height: 12),
          _buildInfoRow('Periode', widget.tagihan.periode),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Nominal',
            NumberHelpers.formatCurrency(widget.tagihan.total),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Status', widget.tagihan.status.value),
          const SizedBox(height: 12),
          _buildInfoRow('Nama KK', widget.tagihan.namaKeluarga),
          const SizedBox(height: 12),
          _buildInfoRow('Alamat', widget.tagihan.alamat),
          const SizedBox(height: 12),
          _buildInfoRow('Metode Pembayaran', widget.tagihan.metodePembayaran),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Bukti',
            widget.tagihan.bukti.isEmpty ? 'Tidak ada' : widget.tagihan.bukti,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final statusColor = widget.tagihan.status == StatusTagihan.lunas
        ? AppColors.success
        : widget.tagihan.status == StatusTagihan.pending
        ? Colors.orange
        : AppColors.warning;
    final statusIcon = widget.tagihan.status == StatusTagihan.lunas
        ? Icons.check_circle
        : widget.tagihan.status == StatusTagihan.pending
        ? Icons.schedule
        : Icons.schedule;
    final statusMessage = widget.tagihan.status == StatusTagihan.lunas
        ? 'Tagihan ini telah dibayar lunas'
        : widget.tagihan.status == StatusTagihan.pending
        ? 'Tagihan ini belum dibayar'
        : 'Tagihan ini belum dibayar';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Pembayaran',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusMessage,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    // Check if this is a broadcast tagihan
    final isBroadcast = widget.tagihan.statusKeluarga == 'Broadcast';

    if (isBroadcast) {
      return SizedBox(
        width: double.infinity,
        child: _buildActionButton(
          context,
          'Konfirmasi Target Tercapai / Selesai',
          Icons.check_circle_outline,
          AppColors.primary,
          () => _showApprovalDialog(context),
        ),
      );
    }

    final reasonController = TextEditingController();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tulis alasan penolakan...',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: TextField(
                  controller: reasonController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: 'Tulis alasan penolakan...',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'Setujui',
                Icons.check_circle,
                Colors.green,
                () {
                  _showApprovalDialog(context);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                'Tolak',
                Icons.cancel,
                Colors.pink,
                () {
                  _showRejectionDialog(context, reasonController.text);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  void _showApprovalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Setujui Tagihan'),
          content: const Text(
            'Apakah Anda yakin ingin menyetujui tagihan ini?\n\n'
            'Tindakan ini akan:\n'
            '1. Mengubah status menjadi Lunas\n'
            '2. Mencatat otomatis ke Pemasukan',
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                _approveTagihan();
              },
              child: const Text(
                'Setujui',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRejectionDialog(BuildContext context, String reason) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tolak Tagihan'),
          content: const Text('Apakah Anda yakin ingin menolak tagihan ini?'),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                _rejectTagihan(reason);
              },
              child: const Text('Tolak', style: TextStyle(color: Colors.pink)),
            ),
          ],
        );
      },
    );
  }
}
