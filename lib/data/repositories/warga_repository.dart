import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile_model.dart' as userProfile;
import '../models/warga_model.dart';

class WargaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  // Get warga by ID - helper for foreign key relationships
  Future<Warga?> getWargaById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      data['id'] = doc.id;
      return Warga.fromMap(data);
    } catch (e) {
      return null;
    }
  }

  // Create warga with account (Firebase Auth + UserProfile + Warga)
  Future<void> createWargaWithAccount(Warga warga, String password) async {
    try {
      // 1. Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: warga.email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // 2. Create in transaction untuk konsistensi
      await _firestore.runTransaction((transaction) async {
        // Create UserProfile
        final userProfileRef = _firestore.collection('users').doc(uid);
        final userProfileData = userProfile.UserProfile(
          uid: uid,
          nama: warga.nama,
          email: warga.email,
          nik: warga.nik,
          noTelepon: warga.noTelepon,
          jenisKelamin: warga.jenisKelamin == JenisKelamin.lakiLaki
              ? userProfile.JenisKelamin.lakiLaki
              : userProfile.JenisKelamin.perempuan,
          role: userProfile.UserRole.warga,
          createdAt: DateTime.now(),
        );
        transaction.set(userProfileRef, userProfileData.toMap());

        // Create Warga
        final wargaRef = _firestore.collection(_collection).doc();
        final newWarga = warga.copyWith(
          id: wargaRef.id,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        transaction.set(wargaRef, newWarga.toMap());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Email sudah digunakan');
      } else if (e.code == 'weak-password') {
        throw Exception('Password terlalu lemah');
      }
      throw Exception('Gagal membuat akun: ${e.message}');
    } catch (e) {
      throw Exception('Gagal menambah warga: $e');
    }
  }

  // Add new warga (without account creation)
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

  // Update existing warga and optionally update user profile
  Future<void> updateWargaWithAccount(
    Warga warga, {
    bool updateUserProfile = true,
  }) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // Update Warga
        final wargaRef = _firestore.collection(_collection).doc(warga.id);
        final updatedWarga = warga.copyWith(updatedAt: DateTime.now());
        transaction.update(wargaRef, updatedWarga.toMap());

        // Update UserProfile if requested
        if (updateUserProfile) {
          // Find user by NIK
          final userQuery = await _firestore
              .collection('users')
              .where('nik', isEqualTo: warga.nik)
              .limit(1)
              .get();

          if (userQuery.docs.isNotEmpty) {
            final userDoc = userQuery.docs.first;
            final userProfileRef = _firestore
                .collection('users')
                .doc(userDoc.id);

            final existingUserProfile = userProfile.UserProfile.fromMap(
              userDoc.data(),
            );
            final updatedUserProfile = existingUserProfile.copyWith(
              nama: warga.nama,
              email: warga.email,
              noTelepon: warga.noTelepon,
              jenisKelamin: warga.jenisKelamin == JenisKelamin.lakiLaki
                  ? userProfile.JenisKelamin.lakiLaki
                  : userProfile.JenisKelamin.perempuan,
              updatedAt: DateTime.now(),
            );
            transaction.update(userProfileRef, updatedUserProfile.toMap());
          }
        }
      });
    } catch (e) {
      throw Exception('Gagal mengupdate warga: $e');
    }
  }

  // Update existing warga (without user profile update)
  Future<void> updateWarga(Warga warga) async {
    try {
      final updatedWarga = warga.copyWith(updatedAt: DateTime.now());
      await _firestore
          .collection(_collection)
          .doc(warga.id)
          .update(updatedWarga.toMap());
    } catch (e) {
      throw Exception('Gagal mengupdate warga: $e');
    }
  }

  // Delete warga along with associated auth account and user profile
  Future<void> deleteWarga(String id) async {
    try {
      // 1. Get warga data first to find associated user
      final wargaDoc = await _firestore.collection(_collection).doc(id).get();
      if (!wargaDoc.exists) {
        throw Exception('Warga tidak ditemukan');
      }

      final wargaData = wargaDoc.data()!;
      final nik = wargaData['nik'] as String;

      // 2. Find and delete associated UserProfile by NIK
      final userQuery = await _firestore
          .collection('users')
          .where('nik', isEqualTo: nik)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        final uid = userDoc.id;

        // 3. Delete in transaction for consistency
        await _firestore.runTransaction((transaction) async {
          // Delete UserProfile
          transaction.delete(_firestore.collection('users').doc(uid));

          // Delete Warga
          transaction.delete(_firestore.collection(_collection).doc(id));
        });

        // 4. Delete Firebase Auth user
        // Note: This requires admin privileges. In production, this should be done
        // via Cloud Function or Admin SDK on the backend
        // For now, we'll attempt to delete but catch any permission errors
        try {
          final user = _auth.currentUser;
          if (user != null && user.uid == uid) {
            // If trying to delete current user, sign out first
            await user.delete();
            await _auth.signOut();
          } else {
            // Cannot delete other users from client-side
            // This should be handled by Cloud Function in production
            print(
              'Warning: Cannot delete auth user $uid from client. Use Cloud Function.',
            );
          }
        } catch (authError) {
          // Auth deletion failed, but Firestore data is already deleted
          print('Warning: Failed to delete auth account: $authError');
          // Don't throw - Firestore cleanup was successful
        }
      } else {
        // No associated user found, just delete warga
        await _firestore.collection(_collection).doc(id).delete();
      }
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
