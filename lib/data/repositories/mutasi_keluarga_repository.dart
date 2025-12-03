import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/mutasi_keluarga_model.dart';

/// Repository untuk operasi CRUD pada koleksi `mutasi_keluarga` di Firestore.
class MutasiKeluargaRepository {
  final FirebaseFirestore _firestore;

  MutasiKeluargaRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

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
    return _firestore.collection(_collection).orderBy('createdAt', descending: true).snapshots().map((snap) {
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

  /// Update entri mutasi. Field DateTime dan enum akan dinormalisasi.
  Future<void> update(String id, Map<String, dynamic> updates) async {
    try {
      if (id.isEmpty) throw Exception('ID tidak boleh kosong');
      final normalized = _normalize(updates);
      await _firestore.collection(_collection).doc(id).update(normalized);
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