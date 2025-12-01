import 'package:cloud_firestore/cloud_firestore.dart';

class AspirasiRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAspirasi(Map<String, dynamic> aspirasi) async {
    try {
      await _firestore.collection('aspirasi').add(aspirasi);
    } catch (e) {
      throw Exception('Gagal menambahkan aspirasi: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getAspirasiStream() {
    return _firestore.collection('aspirasi').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> updateAspirasi(String id, Map<String, dynamic> aspirasi) async {
    try {
      if (id.isEmpty) {
        throw Exception('ID tidak ditemukan');
      }
      await _firestore.collection('aspirasi').doc(id).update(aspirasi);
    } catch (e) {
      throw Exception('Gagal memperbarui aspirasi: $e');
    }
  }

  Future<void> updateStatusAspirasi(String id, String status) async {
    try {
      if (id.isEmpty) {
        throw Exception('ID tidak ditemukan');
      }
      await _firestore.collection('aspirasi').doc(id).update({
        'status': status,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Gagal memperbarui status: $e');
    }
  }

  Future<void> deleteAspirasi(String id) async {
    try {
      await _firestore.collection('aspirasi').doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus aspirasi: $e');
    }
  }
}
