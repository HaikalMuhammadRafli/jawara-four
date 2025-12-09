import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/keluarga_model.dart';

class KeluargaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'keluarga';

  // Get stream of all keluarga
  Stream<List<Keluarga>> getKeluargaStream() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Keluarga.fromMap(data);
      }).toList();
    });
  }

  // Get single keluarga by id
  Future<Keluarga?> getKeluargaById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return Keluarga.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil data keluarga: $e');
    }
  }

  // Add new keluarga
  Future<void> addKeluarga(Keluarga keluarga) async {
    try {
      final docRef = _firestore.collection(_collection).doc();
      final newKeluarga = keluarga.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await docRef.set(newKeluarga.toMap());
    } catch (e) {
      throw Exception('Gagal menambah keluarga: $e');
    }
  }

  // Update existing keluarga
  Future<void> updateKeluarga(Keluarga keluarga) async {
    try {
      final updatedKeluarga = keluarga.copyWith(updatedAt: DateTime.now());
      await _firestore.collection(_collection).doc(keluarga.id).update(updatedKeluarga.toMap());
    } catch (e) {
      throw Exception('Gagal mengupdate keluarga: $e');
    }
  }

  // Delete keluarga
  Future<void> deleteKeluarga(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus keluarga: $e');
    }
  }

  // Search keluarga by kepala keluarga or alamat
  Stream<List<Keluarga>> searchKeluarga(String query) {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return Keluarga.fromMap(data);
          })
          .where((keluarga) {
            return keluarga.kepalaKeluarga.toLowerCase().contains(query.toLowerCase()) ||
                keluarga.alamat.toLowerCase().contains(query.toLowerCase());
          })
          .toList();
    });
  }
}
