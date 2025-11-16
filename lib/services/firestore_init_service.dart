import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class FirestoreInitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initializeCollections() async {
    try {
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

  Future<void> _initializeMasterCollections() async {
    await _ensureCollectionExists('roles');
    await _ensureCollectionExists('settings');
    await _ensureCollectionExists('logs');
    
    // Tambahkan collection baru di sini:
    // await _ensureCollectionExists('kegiatan');
    // await _ensureCollectionExists('pengeluaran');
  }

  Future<void> _ensureCollectionExists(String collectionName) async {
    try {
      final snapshot = await _firestore.collection(collectionName).limit(1).get();
      
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

  CollectionReference getCollection(String collectionName) {
    return _firestore.collection(collectionName);
  }

  DocumentReference getDocument(String collectionName, String documentId) {
    return _firestore.collection(collectionName).doc(documentId);
  }
}

