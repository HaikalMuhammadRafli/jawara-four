import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// Service untuk menginisialisasi struktur Firestore
/// Collections akan dibuat otomatis saat pertama kali digunakan,
/// tapi service ini bisa digunakan untuk membuat collections dengan struktur awal
class FirestoreInitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initialize collections dengan struktur default
  /// Bisa dipanggil saat pertama kali app dijalankan
  Future<void> initializeCollections() async {
    try {
      // Collection 'users' sudah dibuat otomatis saat registrasi
      // Tapi kita bisa menambahkan index atau dokumentasi di sini

      // Collection untuk data master (jika diperlukan)
      await _initializeMasterCollections();

      if (kDebugMode) {
        print('Firestore collections initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Firestore collections: $e');
      }
    }
  }

  /// Initialize master collections dengan struktur default
  /// Tambahkan collection baru di sini jika diperlukan
  Future<void> _initializeMasterCollections() async {
    // Contoh: Buat collection dengan document template
    // Firestore akan membuat collection otomatis saat kita write data
    // Tapi inisialisasi di sini membantu memastikan collection siap dari awal
    
    // Collection 'roles' - untuk role pengguna
    await _ensureCollectionExists('roles');
    
    // Collection 'settings' - untuk pengaturan aplikasi
    await _ensureCollectionExists('settings');
    
    // Collection 'logs' - untuk log aktivitas (jika diperlukan)
    await _ensureCollectionExists('logs');
    
    // ========================================
    // TAMBAHKAN COLLECTION BARU DI SINI
    // ========================================
    // Contoh:
    // await _ensureCollectionExists('kegiatan');
    // await _ensureCollectionExists('pengeluaran');
    // await _ensureCollectionExists('pemasukan');
    // await _ensureCollectionExists('tagihan');
    // dll...
  }

  /// Memastikan collection ada dengan membuat document dummy jika kosong
  Future<void> _ensureCollectionExists(String collectionName) async {
    try {
      final snapshot = await _firestore.collection(collectionName).limit(1).get();
      
      // Jika collection kosong, buat document dummy untuk init
      if (snapshot.docs.isEmpty) {
        await _firestore.collection(collectionName).doc('_init').set({
          'createdAt': FieldValue.serverTimestamp(),
          'initialized': true,
        });
        
        if (kDebugMode) {
          print('Collection "$collectionName" initialized');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error ensuring collection $collectionName exists: $e');
      }
    }
  }

  /// Get atau create collection reference
  CollectionReference getCollection(String collectionName) {
    return _firestore.collection(collectionName);
  }

  /// Get atau create document reference
  DocumentReference getDocument(String collectionName, String documentId) {
    return _firestore.collection(collectionName).doc(documentId);
  }
}

