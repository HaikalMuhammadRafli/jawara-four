import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_four/data/models/pengeluaran_model.dart';

class PengeluaranRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPengeluaran(Pengeluaran pengeluaran) async {
    try {
      await _firestore.collection('pengeluaran').add(pengeluaran.toMap());
    } catch (e) {
      throw Exception('Gagal menambahkan pengeluaran: $e');
    }
  }

  Stream<List<Pengeluaran>> getPengeluaranStream() {
    return _firestore.collection('pengeluaran').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return Pengeluaran.fromMap(data);
      }).toList();
    });
  }

  Future<void> updatePengeluaran(Pengeluaran pengeluaran) async {
    try {
      if (pengeluaran.id.isEmpty) {
        throw Exception('ID tidak ditemukan');
      }
      await _firestore
          .collection('pengeluaran')
          .doc(pengeluaran.id)
          .update(pengeluaran.toMap());
    } catch (e) {
      throw Exception('Gagal memperbarui pengeluaran: $e');
    }
  }

  Future<void> deletePengeluaran(String id) async {
    try {
      await _firestore.collection('pengeluaran').doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus pengeluaran: $e');
    }
  }
}