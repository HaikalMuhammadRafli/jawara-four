import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/keluarga_model.dart';
import '../models/mutasi_keluarga_model.dart';

/// Repository untuk operasi CRUD pada koleksi `mutasi_keluarga` di Firestore.
class MutasiKeluargaRepository {
  final FirebaseFirestore _firestore;

  MutasiKeluargaRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  String get _collection => 'mutasi_keluarga';

  /// Tambah data mutasi keluarga dan kembalikan instance dengan id dokumen.
  Future<MutasiKeluarga> create(MutasiKeluarga entry) async {
    try {
      final map = _normalize(entry.toMap());
      final docRef = await _firestore.collection(_collection).add(map);
      return entry.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Gagal menambahkan mutasi keluarga: $e');
    }
  }

  /// Stream daftar mutasi keluarga, diurutkan berdasarkan createdAt menurun.
  Stream<List<MutasiKeluarga>> streamAll() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
          return snap.docs.map((doc) {
            final data = Map<String, dynamic>.from(doc.data() as Map);
            data['id'] = doc.id;
            return MutasiKeluarga.fromMap(data);
          }).toList();
        });
  }

  /// Ambil satu entri mutasi berdasarkan id.
  Future<MutasiKeluarga?> getById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;
      final data = Map<String, dynamic>.from(doc.data() as Map);
      data['id'] = doc.id;
      return MutasiKeluarga.fromMap(data);
    } catch (e) {
      throw Exception('Gagal mengambil mutasi keluarga: $e');
    }
  }

  /// Get mutasi with keluarga details
  Future<Map<String, dynamic>?> getMutasiWithKeluarga(String id) async {
    try {
      final mutasi = await getById(id);
      if (mutasi == null) return null;

      // Fetch keluarga
      final keluargaDoc = await _firestore
          .collection('keluarga')
          .doc(mutasi.keluargaId)
          .get();
      final keluarga = keluargaDoc.exists
          ? Keluarga.fromMap({...keluargaDoc.data()!, 'id': keluargaDoc.id})
          : null;

      return {'mutasi': mutasi, 'keluarga': keluarga};
    } catch (e) {
      throw Exception('Gagal mengambil detail mutasi: $e');
    }
  }

  /// Update entri mutasi. Field DateTime dan enum akan dinormalisasi.
  Future<void> update(String id, Map<String, dynamic> updates) async {
    try {
      if (id.isEmpty) throw Exception('ID tidak boleh kosong');
      final normalized = _normalize(updates);
      normalized['updatedAt'] = DateTime.now().toIso8601String();
      await _firestore.collection(_collection).doc(id).update(normalized);
    } catch (e) {
      throw Exception('Gagal memperbarui mutasi keluarga: $e');
    }
  }

  /// Update mutasi keluarga object
  Future<void> updateMutasi(MutasiKeluarga mutasi) async {
    try {
      if (mutasi.id.isEmpty) throw Exception('ID tidak boleh kosong');
      final updatedMutasi = mutasi.copyWith(updatedAt: DateTime.now());
      final normalized = _normalize(updatedMutasi.toMap());
      await _firestore
          .collection(_collection)
          .doc(mutasi.id)
          .update(normalized);
    } catch (e) {
      throw Exception('Gagal memperbarui mutasi keluarga: $e');
    }
  }

  /// Hapus entri mutasi.
  Future<void> delete(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus mutasi keluarga: $e');
    }
  }

  /// Search mutasi by nomor KK or nama
  Stream<List<MutasiKeluarga>> searchMutasi(String query) {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = Map<String, dynamic>.from(doc.data());
            data['id'] = doc.id;
            return MutasiKeluarga.fromMap(data);
          })
          .where((mutasi) {
            return mutasi.nomorKK.contains(query) ||
                mutasi.namaKepalaKeluarga.toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                mutasi.namaWarga.toLowerCase().contains(query.toLowerCase());
          })
          .toList();
    });
  }

  /// Helper: konversi DateTime ke ISO string dan enum JenisMutasi ke string value.
  Map<String, dynamic> _normalize(Map<String, dynamic> m) {
    final result = <String, dynamic>{};
    m.forEach((key, value) {
      if (value is DateTime) {
        result[key] = value.toIso8601String();
      } else if (value is JenisMutasi) {
        result[key] = value.value;
      } else {
        result[key] = value;
      }
    });
    return result;
  }
}
