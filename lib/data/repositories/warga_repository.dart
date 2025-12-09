import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/warga_model.dart';

class WargaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'warga';

  // Get stream of all warga
  Stream<List<Warga>> getWargaStream() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Warga.fromMap(data);
      }).toList();
    });
  }

  // Get single warga by id
  Future<Warga?> getWargaById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return Warga.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil data warga: $e');
    }
  }

  // Add new warga
  Future<void> addWarga(Warga warga) async {
    try {
      final docRef = _firestore.collection(_collection).doc();
      final newWarga = warga.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await docRef.set(newWarga.toMap());
    } catch (e) {
      throw Exception('Gagal menambah warga: $e');
    }
  }

  // Update existing warga
  Future<void> updateWarga(Warga warga) async {
    try {
      final updatedWarga = warga.copyWith(updatedAt: DateTime.now());
      await _firestore.collection(_collection).doc(warga.id).update(updatedWarga.toMap());
    } catch (e) {
      throw Exception('Gagal mengupdate warga: $e');
    }
  }

  // Delete warga
  Future<void> deleteWarga(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus warga: $e');
    }
  }

  // Search warga by name or NIK
  Stream<List<Warga>> searchWarga(String query) {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return Warga.fromMap(data);
          })
          .where((warga) {
            return warga.nama.toLowerCase().contains(query.toLowerCase()) ||
                warga.nik.contains(query);
          })
          .toList();
    });
  }
}
