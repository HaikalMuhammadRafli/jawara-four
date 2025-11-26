# Quick Reference - Menambah Collection Baru

Panduan cepat untuk menambah collection baru di Firestore.

## 🚀 Quick Steps

### 1. Buat Model (`lib/models/[nama]_model.dart`)
```dart
class [Nama] {
  final String? id;
  final String field1;
  final DateTime createdAt;
  
  [Nama]({this.id, required this.field1, required this.createdAt});
  
  Map<String, dynamic> toMap() => {...};
  factory [Nama].fromMap(Map map, String id) => {...};
  [Nama] copyWith({...}) => {...};
}
```

### 2. Buat Service (`lib/services/[nama]_service.dart`)
```dart
class [Nama]Service {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = '[nama]';
  
  Future<String> create[Nama]([Nama] item) async {...}
  Future<[Nama]?> get[Nama]ById(String id) async {...}
  Future<List<[Nama]>> getAll[Nama]() async {...}
  Future<void> update[Nama]([Nama] item) async {...}
  Future<void> delete[Nama](String id) async {...}
  Stream<List<[Nama]>> get[Nama]Stream() {...}
}
```

### 3. Gunakan di Form
```dart
final service = [Nama]Service();
await service.create[Nama](item);
```

### 4. Update Security Rules (Firebase Console)
```javascript
match /[nama]/{id} {
  allow create, read, update, delete: if request.auth != null;
}
```

### 5. Update Init Service (Opsional)
```dart
// lib/services/firestore_init_service.dart
await _ensureCollectionExists('[nama]');
```

---

**Lihat `docs/FIRESTORE_ADD_COLLECTION.md` untuk panduan lengkap!**

