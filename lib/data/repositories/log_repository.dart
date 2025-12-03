import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/log_model.dart';

/// Repository untuk operasi CRUD pada koleksi `logs` di Firestore.
/// Menggunakan `LogEntry` sebagai model data.
class LogRepository {
  final FirebaseFirestore _firestore;

  LogRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  String get _collection => 'logs';

  /// Tambah log dan kembalikan instance LogEntry dengan id dokumen yang dibuat.
  Future<LogEntry> createLog(LogEntry entry) async {
    try {
      final map = _normalizeDates(entry.toMap());
      final docRef = await _firestore.collection(_collection).add(map);
      return entry.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Gagal menambahkan log: $e');
    }
  }

  /// Mengembalikan stream daftar log (urut berdasarkan createdAt menurun).
  Stream<List<LogEntry>> logsStream() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data() as Map);
        data['id'] = doc.id;
        return LogEntry.fromMap(data);
      }).toList();
    });
  }

  /// Ambil satu log berdasarkan id.
  Future<LogEntry?> getLogById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;
      final data = Map<String, dynamic>.from(doc.data() as Map);
      data['id'] = doc.id;
      return LogEntry.fromMap(data);
    } catch (e) {
      throw Exception('Gagal mengambil log: $e');
    }
  }

  /// Update dokumen log. Jika nilai berisi DateTime, akan dikonversi ke ISO string.
  Future<void> updateLog(String id, Map<String, dynamic> updates) async {
    try {
      if (id.isEmpty) throw Exception('ID tidak boleh kosong');
      final normalized = _normalizeDates(updates);
      await _firestore.collection(_collection).doc(id).update(normalized);
    } catch (e) {
      throw Exception('Gagal memperbarui log: $e');
    }
  }

  /// Hapus dokumen log.
  Future<void> deleteLog(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus log: $e');
    }
  }

  /// Helper: ubah nilai DateTime di map menjadi ISO8601 string agar konsisten
  /// dengan `LogEntry.fromMap`/`toMap`.
  Map<String, dynamic> _normalizeDates(Map<String, dynamic> m) {
    final result = <String, dynamic>{};
    m.forEach((key, value) {
      if (value is DateTime) {
        result[key] = value.toIso8601String();
      } else {
        result[key] = value;
      }
    });
    return result;
  }
}