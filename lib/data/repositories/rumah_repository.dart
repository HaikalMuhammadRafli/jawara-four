import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara_four/data/models/rumah_model.dart';
import 'package:jawara_four/data/models/warga_model.dart';

class RumahRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'rumah';

  // Add rumah
  Future<void> addRumah(Rumah rumah) async {
    try {
      final docRef = _firestore.collection(_collection).doc();
      final newRumah = rumah.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await docRef.set(newRumah.toMap());
    } catch (e) {
      throw Exception('Gagal menambahkan rumah: $e');
    }
  }

  // Get stream of all rumah
  Stream<List<Rumah>> getRumahStream() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return Rumah.fromMap(data);
      }).toList();
    });
  }

  // Get single rumah by id
  Future<Rumah?> getRumahById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        final data = Map<String, dynamic>.from(doc.data()!);
        data['id'] = doc.id;
        return Rumah.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil rumah: $e');
    }
  }

  // Get rumah with pemilik data
  Future<Map<String, dynamic>?> getRumahWithPemilik(String id) async {
    try {
      final rumah = await getRumahById(id);
      if (rumah == null) return null;

      // Fetch pemilik
      final pemilikDoc = await _firestore
          .collection('warga')
          .doc(rumah.pemilikId)
          .get();
      final pemilik = pemilikDoc.exists
          ? Warga.fromMap({...pemilikDoc.data()!, 'id': pemilikDoc.id})
          : null;

      return {'rumah': rumah, 'pemilik': pemilik};
    } catch (e) {
      throw Exception('Gagal mengambil detail rumah: $e');
    }
  }

  // Get list of rumah kosong (available houses)
  Stream<List<Rumah>> getRumahKosong() {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: StatusRumah.kosong.value)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = Map<String, dynamic>.from(doc.data());
            data['id'] = doc.id;
            return Rumah.fromMap(data);
          }).toList();
        });
  }

  // Update rumah
  Future<void> updateRumah(Rumah rumah) async {
    try {
      if (rumah.id.isEmpty) {
        throw Exception('ID tidak ditemukan');
      }
      final updatedRumah = rumah.copyWith(updatedAt: DateTime.now());
      await _firestore
          .collection(_collection)
          .doc(rumah.id)
          .update(updatedRumah.toMap());
    } catch (e) {
      throw Exception('Gagal memperbarui rumah: $e');
    }
  }

  // Delete rumah
  Future<void> deleteRumah(String id) async {
    try {
      // Check if rumah is being used by any keluarga
      final keluargaSnapshot = await _firestore
          .collection('keluarga')
          .where('rumahId', isEqualTo: id)
          .limit(1)
          .get();

      if (keluargaSnapshot.docs.isNotEmpty) {
        throw Exception(
          'Rumah tidak dapat dihapus karena masih ditempati oleh keluarga',
        );
      }

      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus rumah: $e');
    }
  }

  // Search rumah by alamat, RT, or RW
  Stream<List<Rumah>> searchRumah(String query) {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = Map<String, dynamic>.from(doc.data());
            data['id'] = doc.id;
            return Rumah.fromMap(data);
          })
          .where((rumah) {
            return rumah.alamat.toLowerCase().contains(query.toLowerCase()) ||
                rumah.rt.contains(query) ||
                rumah.rw.contains(query);
          })
          .toList();
    });
  }
}
