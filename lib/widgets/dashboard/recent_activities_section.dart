import 'package:flutter/material.dart';

class RecentActivitiesSection extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;

  const RecentActivitiesSection({
    super.key,
    required this.isTablet,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aktivitas Terbaru',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 24),
        _buildResponsiveLayout(),
      ],
    );
  }

  Widget _buildResponsiveLayout() {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TransactionCard(),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: RecentActivitiesCard(),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: DemographicsChangesCard(),
          ),
        ],
      );
    } else if (isTablet) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: TransactionCard()),
              const SizedBox(width: 16),
              Expanded(child: RecentActivitiesCard()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: DemographicsChangesCard()),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          TransactionCard(),
          const SizedBox(height: 16),
          RecentActivitiesCard(),
          const SizedBox(height: 16),
          DemographicsChangesCard(),
        ],
      );
    }
  }
}

class TransactionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Transaksi Terbaru',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(5, (index) {
            final transactions = [
              {'name': 'Iuran Bulanan - Pak Budi', 'amount': 'Rp 150.000', 'date': '15 Jan 2024'},
              {'name': 'Perbaikan Jalan', 'amount': 'Rp 2.500.000', 'date': '14 Jan 2024'},
              {'name': 'Iuran Bulanan - Ibu Sari', 'amount': 'Rp 150.000', 'date': '14 Jan 2024'},
              {'name': 'Pembelian Alat Kebersihan', 'amount': 'Rp 750.000', 'date': '13 Jan 2024'},
              {'name': 'Iuran Bulanan - Pak Ahmad', 'amount': 'Rp 150.000', 'date': '13 Jan 2024'},
            ];
            final transaction = transactions[index];
            return TransactionItem(
              name: transaction['name']!,
              amount: transaction['amount']!,
              date: transaction['date']!,
            );
          }),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String name;
  final String amount;
  final String date;

  const TransactionItem({
    super.key,
    required this.name,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final isNegative = amount.contains('-');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isNegative ? const Color(0xFFEF4444) : const Color(0xFF10B981),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class RecentActivitiesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.event_note_rounded,
                  color: Color(0xFFF59E0B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Kegiatan Terbaru',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(5, (index) {
            final activities = [
              {'name': 'Kerja Bakti Lingkungan', 'person': 'Pak Budi', 'date': '20 Jan 2024'},
              {'name': 'Rapat RW', 'person': 'Ibu Sari', 'date': '18 Jan 2024'},
              {'name': 'Lomba 17 Agustus', 'person': 'Pak Ahmad', 'date': '17 Jan 2024'},
              {'name': 'Pembagian Sembako', 'person': 'Ibu Dewi', 'date': '15 Jan 2024'},
              {'name': 'Senam Pagi', 'person': 'Pak Joko', 'date': '12 Jan 2024'},
            ];
            final activity = activities[index];
            return ActivityItem(
              name: activity['name']!,
              person: activity['person']!,
              date: activity['date']!,
            );
          }),
        ],
      ),
    );
  }
}

class ActivityItem extends StatelessWidget {
  final String name;
  final String person;
  final String date;

  const ActivityItem({
    super.key,
    required this.name,
    required this.person,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Penanggung Jawab: $person',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DemographicsChangesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.people_alt_rounded,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Perubahan Data',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(5, (index) {
            final changes = [
              {'change': 'Warga Baru - Keluarga Pak Rudi', 'type': 'Pendaftaran', 'date': '16 Jan 2024'},
              {'change': 'Mutasi Keluar - Keluarga Pak Andi', 'type': 'Pindah', 'date': '14 Jan 2024'},
              {'change': 'Update KK - Keluarga Pak Surya', 'type': 'Perubahan', 'date': '12 Jan 2024'},
              {'change': 'Warga Baru - Keluarga Pak Dedi', 'type': 'Pendaftaran', 'date': '10 Jan 2024'},
              {'change': 'Update Data - Keluarga Ibu Rina', 'type': 'Perubahan', 'date': '8 Jan 2024'},
            ];
            final change = changes[index];
            return DemographicsChangeItem(
              change: change['change']!,
              type: change['type']!,
              date: change['date']!,
            );
          }),
        ],
      ),
    );
  }
}

class DemographicsChangeItem extends StatelessWidget {
  final String change;
  final String type;
  final String date;

  const DemographicsChangeItem({
    super.key,
    required this.change,
    required this.type,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    Color typeColor;
    IconData typeIcon;
    
    switch (type) {
      case 'Pendaftaran':
        typeColor = const Color(0xFF10B981);
        typeIcon = Icons.person_add_rounded;
        break;
      case 'Pindah':
        typeColor = const Color(0xFFEF4444);
        typeIcon = Icons.person_remove_rounded;
        break;
      default:
        typeColor = const Color(0xFF3B82F6);
        typeIcon = Icons.edit_rounded;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(typeIcon, color: typeColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  change,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    fontSize: 10,
                    color: typeColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
