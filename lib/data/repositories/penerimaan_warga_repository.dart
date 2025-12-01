import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_four/data/models/penerimaan_warga_model.dart';

class PenerimaanWargaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPenerimaanWarga(PenerimaanWarga penerimaanWarga) async {
    try {
      await _firestore.collection('penerimaan_warga').add(penerimaanWarga.toMap());
    } catch (e) {
      throw Exception('Gagal menambahkan penerimaan warga: $e');
    }
  }

  Stream<List<PenerimaanWarga>> getPenerimaanWargaStream() {
    return _firestore.collection('penerimaan_warga').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return PenerimaanWarga.fromMap(data);
      }).toList();
    });
  }

  Future<void> updatePenerimaanWarga(String id, Map<String, dynamic> data) async {
    try {
      if (id.isEmpty) {
        throw Exception('ID tidak ditemukan');
      }
      data['updatedAt'] = DateTime.now().toIso8601String();
      await _firestore.collection('penerimaan_warga').doc(id).update(data);
    } catch (e) {
      throw Exception('Gagal memperbarui penerimaan warga: $e');
    }
  }

  Future<void> updateStatusPenerimaanWarga(String id, String status) async {
    try {
      if (id.isEmpty) {
        throw Exception('ID tidak ditemukan');
      }
      await _firestore.collection('penerimaan_warga').doc(id).update({
        'statusRegistrasi': status,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Gagal memperbarui status: $e');
    }
  }

  Future<void> deletePenerimaanWarga(String id) async {
    try {
      await _firestore.collection('penerimaan_warga').doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus penerimaan warga: $e');
    }
  }
}
