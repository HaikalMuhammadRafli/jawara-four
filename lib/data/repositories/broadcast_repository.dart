

import 'package:cloud_firestore/cloud_firestore.dart';

class BroadcastRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addBroadcast(Map<String, dynamic> broadcast) async {
    try {
      await _firestore.collection('broadcast').add(broadcast);
    } catch (e) {
      throw Exception('Gagal menambahkan broadcast: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getBroadcastStream() {
    return _firestore.collection('broadcast').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> updateBroadcast(String id, Map<String, dynamic> broadcast) async {
    try {
      if (id.isEmpty) {
        throw Exception('ID tidak ditemukan');
      }
      await _firestore
          .collection('broadcast')
          .doc(id)
          .update(broadcast);
    } catch (e) {
      throw Exception('Gagal memperbarui broadcast: $e');
    }
  }

  Future<void> deleteBroadcast(String id) async {
    try {
      await _firestore.collection('broadcast').doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus broadcast: $e');
    }
  }
}