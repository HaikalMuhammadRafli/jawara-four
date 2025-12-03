import 'package:cloud_firestore/cloud_firestore.dart';

class KegiatanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addKegiatan(Map<String, dynamic> kegiatan) async {
    try {
      await _firestore.collection('kegiatan').add(kegiatan);
    } catch (e) {
      throw Exception('Gagal menambahkan kegiatan: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getKegiatanStream() {
    return _firestore.collection('kegiatan').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> updateKegiatan(String id, Map<String, dynamic> kegiatan) async {
    try {
      if (id.isEmpty) {
        throw Exception('ID tidak ditemukan');
      }
      await _firestore
          .collection('kegiatan')
          .doc(id)
          .update(kegiatan);
    } catch (e) {
      throw Exception('Gagal memperbarui kegiatan: $e');
    }
  }

  Future<void> deleteKegiatan(String id) async {
    try {
      await _firestore.collection('kegiatan').doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus kegiatan: $e');
    }
  }
}