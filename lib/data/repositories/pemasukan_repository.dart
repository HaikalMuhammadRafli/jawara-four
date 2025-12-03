import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pemasukan_model.dart';

class PemasukanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPemasukan(Pemasukan pemasukan) async {
    try {
      await _firestore.collection('pemasukan').add(pemasukan.toMap());
    } catch (e) {
      throw Exception('Gagal menambahkan pemasukan: $e');
    }
  }

  Stream<List<Pemasukan>> getPemasukanStream() {
    return _firestore.collection('pemasukan').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Pemasukan.fromMap(data);
      }).toList();
    });
  }

  Future<void> updatePemasukan(Pemasukan pemasukan) async {
    try {
      if (pemasukan.id.isEmpty) {
        throw Exception('ID tidak ditemukan');
      }
      await _firestore
          .collection('pemasukan')
          .doc(pemasukan.id)
          .update(pemasukan.toMap());
    } catch (e) {
      throw Exception('Gagal memperbarui pemasukan: $e');
    }
  }

  Future<void> deletePemasukan(String id) async {
    try {
      await _firestore.collection('pemasukan').doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus pemasukan: $e');
    }
  }
}
