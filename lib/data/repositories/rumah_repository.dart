import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_four/data/models/rumah_model.dart';

class RumahRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRumah(Rumah rumah) async {
    try {
      await _firestore.collection('rumah').add(rumah.toMap());
    } catch (e) {
      throw Exception('Gagal menambahkan rumah: $e');
    }
  }

  Stream<List<Rumah>> getRumahStream() {
    return _firestore.collection('rumah').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return Rumah.fromMap(data);
      }).toList();
    });
  }

  Future<void> updateRumah(Rumah rumah) async {
    try {
      if (rumah.id.isEmpty) {
        throw Exception('ID tidak ditemukan');
      }
      await _firestore.collection('rumah').doc(rumah.id).update(rumah.toMap());
    } catch (e) {
      throw Exception('Gagal memperbarui rumah: $e');
    }
  }

  Future<void> deleteRumah(String id) async {
    try {
      await _firestore.collection('rumah').doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus rumah: $e');
    }
  }
}
