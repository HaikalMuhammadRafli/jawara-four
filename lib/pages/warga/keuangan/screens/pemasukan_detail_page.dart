import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jawara_four/colors/app_colors.dart';
import 'package:jawara_four/data/models/pemasukan_model.dart';
import 'package:jawara_four/data/repositories/pemasukan_repository.dart';

class WargaPemasukanDetailPage extends StatefulWidget {
  final String pemasukanId;

  const WargaPemasukanDetailPage({super.key, required this.pemasukanId});

  @override
  State<WargaPemasukanDetailPage> createState() =>
      _WargaPemasukanDetailPageState();
}

class _WargaPemasukanDetailPageState extends State<WargaPemasukanDetailPage> {
  final PemasukanRepository _repository = PemasukanRepository();
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
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        title: const Text(
          'Detail Pemasukan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: StreamBuilder<List<Pemasukan>>(
        stream: _repository.getPemasukanStream(),
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

          final pemasukanList = snapshot.data ?? [];
          final pemasukan = pemasukanList.firstWhere(
            (p) => p.id == widget.pemasukanId,
            orElse: () => Pemasukan(
              id: '',
              judul: 'Tidak Ditemukan',
              kategori: '',
              jumlah: 0,
              tanggal: DateTime.now(),
              keterangan: '',
              nama: '',
              jenisPemasukan: '',
              createdAt: DateTime.now(),
            ),
          );

          if (pemasukan.id.isEmpty) {
            return const Center(
              child: Text(
                'Data pemasukan tidak ditemukan',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(pemasukan),
                const SizedBox(height: 24),
                _buildInfoCard(pemasukan),
                const SizedBox(height: 20),
                _buildKeteranganCard(pemasukan),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(Pemasukan pemasukan) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withValues(alpha: 0.1),
            AppColors.success.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
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
                  AppColors.success,
                  AppColors.success.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add_circle, color: Colors.white, size: 48),
          ),
          const SizedBox(height: 16),
          Text(
            pemasukan.judul,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currencyFormat.format(pemasukan.jumlah),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.success,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              pemasukan.kategori,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Pemasukan pemasukan) {
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
            Icons.person,
            'Nama',
            pemasukan.nama,
            AppColors.primary,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.category,
            'Jenis Pemasukan',
            pemasukan.jenisPemasukan,
            AppColors.warning,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.calendar_today,
            'Tanggal',
            DateFormat('dd MMMM yyyy', 'id_ID').format(pemasukan.tanggal),
            AppColors.success,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.access_time,
            'Dibuat',
            DateFormat(
              'dd MMM yyyy HH:mm',
              'id_ID',
            ).format(pemasukan.createdAt),
            AppColors.textSecondary,
          ),
          if (pemasukan.updatedAt != null) ...[
            const Divider(height: 24),
            _buildInfoRow(
              Icons.update,
              'Diperbarui',
              DateFormat(
                'dd MMM yyyy HH:mm',
                'id_ID',
              ).format(pemasukan.updatedAt!),
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

  Widget _buildKeteranganCard(Pemasukan pemasukan) {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.softOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.description,
                  color: AppColors.softOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Keterangan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Text(
              pemasukan.keterangan.isNotEmpty
                  ? pemasukan.keterangan
                  : 'Tidak ada keterangan',
              style: TextStyle(
                fontSize: 14,
                color: pemasukan.keterangan.isNotEmpty
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
