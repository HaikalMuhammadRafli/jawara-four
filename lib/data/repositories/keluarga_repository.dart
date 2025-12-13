import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/keluarga_model.dart';
import '../models/rumah_model.dart';
import '../models/warga_model.dart';

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

  // Get keluarga with detailed information (kepala keluarga, anggota, rumah)
  Future<Map<String, dynamic>?> getKeluargaWithDetails(String id) async {
    try {
      final keluarga = await getKeluargaById(id);
      if (keluarga == null) return null;

      // Fetch kepala keluarga
      final kepalaKeluargaDoc = await _firestore
          .collection('warga')
          .doc(keluarga.kepalaKeluargaId)
          .get();
      final kepalaKeluarga = kepalaKeluargaDoc.exists
          ? Warga.fromMap({
              ...kepalaKeluargaDoc.data()!,
              'id': kepalaKeluargaDoc.id,
            })
          : null;

      // Fetch anggota
      final List<Warga> anggota = [];
      for (final anggotaId in keluarga.anggotaIds) {
        final anggotaDoc = await _firestore
            .collection('warga')
            .doc(anggotaId)
            .get();
        if (anggotaDoc.exists) {
          anggota.add(
            Warga.fromMap({...anggotaDoc.data()!, 'id': anggotaDoc.id}),
          );
        }
      }

      // Fetch rumah
      final rumahDoc = await _firestore
          .collection('rumah')
          .doc(keluarga.rumahId)
          .get();
      final rumah = rumahDoc.exists
          ? Rumah.fromMap({...rumahDoc.data()!, 'id': rumahDoc.id})
          : null;

      return {
        'keluarga': keluarga,
        'kepalaKeluarga': kepalaKeluarga,
        'anggota': anggota,
        'rumah': rumah,
      };
    } catch (e) {
      throw Exception('Gagal mengambil detail keluarga: $e');
    }
  }

  // Add new keluarga with validation
  Future<void> addKeluarga(Keluarga keluarga) async {
    try {
      // Validation: kepala keluarga harus ada di list anggota
      if (!keluarga.anggotaIds.contains(keluarga.kepalaKeluargaId)) {
        throw Exception(
          'Kepala keluarga harus termasuk dalam anggota keluarga',
        );
      }

      // Validation: nomorKK harus 16 digit
      if (keluarga.nomorKK.length != 16) {
        throw Exception('Nomor KK harus 16 digit');
      }

      // Check if nomorKK sudah ada
      final existingKK = await _firestore
          .collection(_collection)
          .where('nomorKK', isEqualTo: keluarga.nomorKK)
          .limit(1)
          .get();

      if (existingKK.docs.isNotEmpty) {
        throw Exception('Nomor KK sudah terdaftar');
      }

      final docRef = _firestore.collection(_collection).doc();
      final newKeluarga = keluarga.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await docRef.set(newKeluarga.toMap());

      // Update status rumah menjadi ditempati dan set pemilik
      if (keluarga.rumahId.isNotEmpty) {
        await _firestore.collection('rumah').doc(keluarga.rumahId).update({
          'status': StatusRumah.ditempati.value,
          'pemilikId': keluarga.kepalaKeluargaId, // Auto-assign pemilik
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      throw Exception('Gagal menambah keluarga: $e');
    }
  }

  // Update existing keluarga with validation
  Future<void> updateKeluarga(Keluarga keluarga) async {
    try {
      // Validation: kepala keluarga harus ada di list anggota
      if (!keluarga.anggotaIds.contains(keluarga.kepalaKeluargaId)) {
        throw Exception(
          'Kepala keluarga harus termasuk dalam anggota keluarga',
        );
      }

      // Validation: nomorKK harus 16 digit
      if (keluarga.nomorKK.length != 16) {
        throw Exception('Nomor KK harus 16 digit');
      }

      // Check if nomorKK sudah ada (exclude current keluarga)
      final existingKK = await _firestore
          .collection(_collection)
          .where('nomorKK', isEqualTo: keluarga.nomorKK)
          .limit(2)
          .get();

      final otherKK = existingKK.docs
          .where((doc) => doc.id != keluarga.id)
          .toList();
      if (otherKK.isNotEmpty) {
        throw Exception('Nomor KK sudah terdaftar');
      }

      final updatedKeluarga = keluarga.copyWith(updatedAt: DateTime.now());
      await _firestore
          .collection(_collection)
          .doc(keluarga.id)
          .update(updatedKeluarga.toMap());

      // Update rumah pemilikId if rumahId is set
      if (keluarga.rumahId.isNotEmpty) {
        await _firestore.collection('rumah').doc(keluarga.rumahId).update({
          'status': StatusRumah.ditempati.value,
          'pemilikId': keluarga.kepalaKeluargaId, // Auto-assign/update pemilik
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      throw Exception('Gagal mengupdate keluarga: $e');
    }
  }

  // Delete keluarga
  Future<void> deleteKeluarga(String id) async {
    try {
      // Get keluarga data first to update rumah status
      final keluarga = await getKeluargaById(id);
      if (keluarga != null && keluarga.rumahId.isNotEmpty) {
        // Update rumah status to kosong
        await _firestore.collection('rumah').doc(keluarga.rumahId).update({
          'status': StatusRumah.kosong.value,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }

      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus keluarga: $e');
    }
  }

  // Search keluarga by nomorKK or kepala keluarga
  Stream<List<Keluarga>> searchKeluarga(String query) {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return Keluarga.fromMap(data);
          })
          .where((keluarga) {
            return keluarga.nomorKK.contains(query);
          })
          .toList();
    });
  }

  // Get keluarga by nomorKK
  Future<Keluarga?> getKeluargaByNomorKK(String nomorKK) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('nomorKK', isEqualTo: nomorKK)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        data['id'] = snapshot.docs.first.id;
        return Keluarga.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil keluarga: $e');
    }
  }
}
