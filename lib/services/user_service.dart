import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  // Create user profile
  Future<void> createUserProfile(UserProfile userProfile) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(userProfile.uid)
          .set(userProfile.toMap());
    } catch (e) {
      throw 'Gagal menyimpan data pengguna: ${e.toString()}';
    }
  }

  // Get user profile by UID
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection(_collection).doc(uid).get();
      if (doc.exists) {
        return UserProfile.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Gagal mengambil data pengguna: ${e.toString()}';
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserProfile userProfile) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(userProfile.uid)
          .update(userProfile.copyWith(updatedAt: DateTime.now()).toMap());
    } catch (e) {
      throw 'Gagal memperbarui data pengguna: ${e.toString()}';
    }
  }

  // Check if NIK already exists
  Future<bool> isNikExists(String nik) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('nik', isEqualTo: nik)
          .limit(1)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Check if email already exists (besides current user)
  Future<bool> isEmailExists(String email, {String? excludeUid}) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .where('email', isEqualTo: email);
      
      final querySnapshot = await query.limit(1).get();
      
      if (excludeUid != null && querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id != excludeUid;
      }
      
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Stream user profile
  Stream<UserProfile?> getUserProfileStream(String uid) {
    return _firestore
        .collection(_collection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserProfile.fromMap(doc.data()!);
      }
      return null;
    });
  }
}

