import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_four/colors/app_colors.dart';
import 'package:jawara_four/data/models/pengeluaran_model.dart';
import 'package:jawara_four/data/repositories/pengeluaran_repository.dart';

class WargaPengeluaranDetailPage extends StatefulWidget {
  final String pengeluaranId;

  const WargaPengeluaranDetailPage({super.key, required this.pengeluaranId});

  @override
  State<WargaPengeluaranDetailPage> createState() =>
      _WargaPengeluaranDetailPageState();
}

class _WargaPengeluaranDetailPageState
    extends State<WargaPengeluaranDetailPage> {
  final PengeluaranRepository _repository = PengeluaranRepository();
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        title: const Text(
          'Detail Pengeluaran',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: StreamBuilder<List<Pengeluaran>>(
        stream: _repository.getPengeluaranStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                style: const TextStyle(color: AppColors.error),
              ),
            );
          }

          final pengeluaranList = snapshot.data ?? [];
          final pengeluaran = pengeluaranList.firstWhere(
            (p) => p.id == widget.pengeluaranId,
            orElse: () => Pengeluaran(
              id: '',
              nama: 'Tidak Ditemukan',
              jenis: '',
              nominal: 0,
              tanggal: DateTime.now(),
              createdAt: DateTime.now(),
            ),
          );

          if (pengeluaran.id.isEmpty) {
            return const Center(
              child: Text(
                'Data pengeluaran tidak ditemukan',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(pengeluaran),
                const SizedBox(height: 24),
                _buildInfoCard(pengeluaran),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(Pengeluaran pengeluaran) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.error.withValues(alpha: 0.1),
            AppColors.error.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.error,
                  AppColors.error.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.remove_circle,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            pengeluaran.nama,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currencyFormat.format(pengeluaran.nominal),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.error,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              pengeluaran.jenis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Pengeluaran pengeluaran) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Detail',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.description,
            'Nama Pengeluaran',
            pengeluaran.nama,
            AppColors.primary,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.category,
            'Jenis',
            pengeluaran.jenis,
            AppColors.warning,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.account_balance_wallet,
            'Nominal',
            _currencyFormat.format(pengeluaran.nominal),
            AppColors.error,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.calendar_today,
            'Tanggal',
            DateFormat('dd MMMM yyyy', 'id_ID').format(pengeluaran.tanggal),
            AppColors.success,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.access_time,
            'Dibuat',
            DateFormat(
              'dd MMM yyyy HH:mm',
              'id_ID',
            ).format(pengeluaran.createdAt),
            AppColors.textSecondary,
          ),
          if (pengeluaran.updatedAt != null) ...[
            const Divider(height: 24),
            _buildInfoRow(
              Icons.update,
              'Diperbarui',
              DateFormat(
                'dd MMM yyyy HH:mm',
                'id_ID',
              ).format(pengeluaran.updatedAt!),
              AppColors.textSecondary,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
