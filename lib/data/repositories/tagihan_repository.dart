import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tagihan_model.dart';

class TagihanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Tagihan>> getTagihanStream() {
    return _firestore.collection('tagihan').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Tagihan.fromMap(data);
      }).toList();
    });
  }

  Future<void> addTagihan(Tagihan tagihan) async {
    try {
      await _firestore.collection('tagihan').add(tagihan.toMap());
    } catch (e) {
      throw Exception('Gagal menambahkan tagihan: $e');
    }
  }

  Future<void> updateTagihan(Tagihan tagihan) async {
    try {
      if (tagihan.id.isEmpty) {
        throw Exception('ID tagihan tidak ditemukan');
      }
      await _firestore
          .collection('tagihan')
          .doc(tagihan.id)
          .update(tagihan.toMap());
    } catch (e) {
      throw Exception('Gagal mengupdate tagihan: $e');
    }
  }

  Future<void> deleteTagihan(String id) async {
    try {
      await _firestore.collection('tagihan').doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus tagihan: $e');
    }
  }
}
