import 'package:cloud_firestore/cloud_firestore.dart';
import '../../pages/keuangan/models/kategori_iuran_model.dart';

class KategoriIuranRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addKategori(KategoriIuran kategori) async {
    try {
      await _firestore.collection('kategori_iuran').add(kategori.toMap());
    } catch (e) {
      throw Exception('Gagal menambahkan kategori: $e');
    }
  }

  Stream<List<KategoriIuran>> getKategoriStream() {
    return _firestore.collection('kategori_iuran').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return KategoriIuran.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> updateKategori(KategoriIuran kategori) async {
    try {
      if (kategori.id.isEmpty) {
        throw Exception('ID tidak ditemukan');
      }
      await _firestore
          .collection('kategori_iuran')
          .doc(kategori.id)
          .update(kategori.toMap());
    } catch (e) {
      throw Exception('Gagal memperbarui kategori: $e');
    }
  }

  Future<void> deleteKategori(String id) async {
    try {
      await _firestore.collection('kategori_iuran').doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus kategori: $e');
    }
  }
}
