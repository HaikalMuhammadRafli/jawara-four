import 'package:flutter/material.dart';
import '../../../../data/repositories/log_repository.dart';
import '../../../../data/models/log_model.dart';
import '../../../../utils/date_helpers.dart';

class LogAktifitasPage extends StatefulWidget {
  const LogAktifitasPage({super.key});

  @override
  State<LogAktifitasPage> createState() => _LogAktifitasPageState();
}

class _LogAktifitasPageState extends State<LogAktifitasPage> {
  final LogRepository _logRepository = LogRepository();

  @override
  void initState() {
    super.initState();
    _cleanupOldLogs();
  }

  Future<void> _cleanupOldLogs() async {
    // Provide a simple cleanup mechanism
    // Note: In a production app, this should be a Cloud Function.
    try {
      final logsStream = _logRepository.logsStream();
      final logs = await logsStream.first; // Get current state
      final now = DateTime.now();

      for (var log in logs) {
        if (now.difference(log.createdAt).inHours >= 24) {
          await _logRepository.deleteLog(log.id);
        }
      }
    } catch (e) {
      debugPrint('Error cleaning up logs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: StreamBuilder<List<LogEntry>>(
        stream: _logRepository.logsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final logs = snapshot.data ?? [];
          // Filter logs for display just in case cleanup hasn't finished
          final recentLogs = logs.where((log) {
            final now = DateTime.now();
            return now.difference(log.createdAt).inHours < 24;
          }).toList();

          if (recentLogs.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada aktivitas dalam 24 jam terakhir',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentLogs.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final log = recentLogs[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            // No
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF1E88E5,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(
                                    0xFF1E88E5,
                                  ).withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E88E5),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Deskripsi dan Aktor
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    log.deskripsi,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF8F9FA),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFE0E0E0),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          log.aktor,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF757575),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        DateHelpers.formatDate(log.tanggal),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF9E9E9E),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
