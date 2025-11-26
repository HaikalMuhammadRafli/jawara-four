# Cara Menambah Collection Baru di Firestore

Panduan lengkap untuk menambah collection baru di Firestore ketika ada form baru yang perlu menyimpan data.

## 📁 Struktur File yang Perlu Dibuat

Ketika menambah form baru, ikuti struktur berikut:

```
lib/
├── models/               # Model data
│   └── [nama]_model.dart
├── services/             # Service untuk CRUD
│   └── [nama]_service.dart
└── pages/                # Halaman form
    └── [nama]_form_page.dart
```

---

## 📝 Langkah-langkah Menambah Collection Baru

### 1. Buat Model Data

**File:** `lib/models/[nama]_model.dart`

Contoh: `lib/models/kegiatan_model.dart`

```dart
class Kegiatan {
  final String? id; // ID dari Firestore (nullable untuk create baru)
  final String nama;
  final String deskripsi;
  final DateTime tanggal;
  final String lokasi;
  final String userId; // ID user yang membuat
  final DateTime createdAt;
  final DateTime? updatedAt;

  Kegiatan({
    this.id,
    required this.nama,
    required this.deskripsi,
    required this.tanggal,
    required this.lokasi,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert ke Map untuk Firestore
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'deskripsi': deskripsi,
      'tanggal': tanggal.toIso8601String(),
      'lokasi': lokasi,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Convert dari Map Firestore
  factory Kegiatan.fromMap(Map<String, dynamic> map, String id) {
    return Kegiatan(
      id: id,
      nama: map['nama'] as String,
      deskripsi: map['deskripsi'] as String,
      tanggal: DateTime.parse(map['tanggal'] as String),
      lokasi: map['lokasi'] as String,
      userId: map['userId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  // Copy dengan method untuk update
  Kegiatan copyWith({
    String? id,
    String? nama,
    String? deskripsi,
    DateTime? tanggal,
    String? lokasi,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Kegiatan(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      deskripsi: deskripsi ?? this.deskripsi,
      tanggal: tanggal ?? this.tanggal,
      lokasi: lokasi ?? this.lokasi,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

---

### 2. Buat Service untuk CRUD

**File:** `lib/services/[nama]_service.dart`

Contoh: `lib/services/kegiatan_service.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kegiatan_model.dart';

class KegiatanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'kegiatan'; // Nama collection di Firestore

  // CREATE - Tambah data baru
  Future<String> createKegiatan(Kegiatan kegiatan) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(kegiatan.toMap());
      
      return docRef.id; // Return ID dari document yang dibuat
    } catch (e) {
      throw 'Gagal menambahkan kegiatan: ${e.toString()}';
    }
  }

  // READ - Ambil data berdasarkan ID
  Future<Kegiatan?> getKegiatanById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      
      if (doc.exists) {
        return Kegiatan.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw 'Gagal mengambil kegiatan: ${e.toString()}';
    }
  }

  // READ ALL - Ambil semua data (dengan optional filter)
  Future<List<Kegiatan>> getAllKegiatan({
    String? userId, // Filter berdasarkan user
    int? limit, // Limit jumlah data
  }) async {
    try {
      Query query = _firestore.collection(_collection);

      // Filter berdasarkan user jika ada
      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      // Order by tanggal (terbaru dulu)
      query = query.orderBy('tanggal', descending: true);

      // Limit jika ada
      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      
      return snapshot.docs
          .map((doc) => Kegiatan.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw 'Gagal mengambil daftar kegiatan: ${e.toString()}';
    }
  }

  // UPDATE - Update data
  Future<void> updateKegiatan(Kegiatan kegiatan) async {
    try {
      if (kegiatan.id == null) {
        throw 'ID kegiatan tidak boleh null untuk update';
      }

      await _firestore
          .collection(_collection)
          .doc(kegiatan.id)
          .update(kegiatan.copyWith(updatedAt: DateTime.now()).toMap());
    } catch (e) {
      throw 'Gagal memperbarui kegiatan: ${e.toString()}';
    }
  }

  // DELETE - Hapus data
  Future<void> deleteKegiatan(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw 'Gagal menghapus kegiatan: ${e.toString()}';
    }
  }

  // STREAM - Real-time updates
  Stream<List<Kegiatan>> getKegiatanStream({String? userId}) {
    Query query = _firestore.collection(_collection);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    query = query.orderBy('tanggal', descending: true);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Kegiatan.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // COUNT - Hitung jumlah data
  Future<int> getKegiatanCount({String? userId}) async {
    try {
      Query query = _firestore.collection(_collection);

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      final snapshot = await query.count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
```

---

### 3. Update Firestore Init Service (Opsional)

**File:** `lib/services/firestore_init_service.dart`

Tambahkan collection baru ke method `_initializeMasterCollections()`:

```dart
Future<void> _initializeMasterCollections() async {
  // ... existing collections ...
  
  // Collection baru
  await _ensureCollectionExists('kegiatan');
  await _ensureCollectionExists('pengeluaran');
  await _ensureCollectionExists('pemasukan');
  // ... collections lainnya
}
```

---

### 4. Gunakan Service di Form Page

**File:** `lib/pages/[nama]_form_page.dart`

Contoh implementasi di form:

```dart
import 'package:flutter/material.dart';
import '../services/kegiatan_service.dart';
import '../services/auth_service.dart';
import '../models/kegiatan_model.dart';

class KegiatanFormPage extends StatefulWidget {
  final Kegiatan? kegiatan; // null untuk create, ada untuk edit

  const KegiatanFormPage({super.key, this.kegiatan});

  @override
  State<KegiatanFormPage> createState() => _KegiatanFormPageState();
}

class _KegiatanFormPageState extends State<KegiatanFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _kegiatanService = KegiatanService();
  final _authService = AuthService();
  
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  DateTime? _tanggal;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    
    // Jika edit mode, isi form dengan data existing
    if (widget.kegiatan != null) {
      _namaController.text = widget.kegiatan!.nama;
      _deskripsiController.text = widget.kegiatan!.deskripsi;
      _lokasiController.text = widget.kegiatan!.lokasi;
      _tanggal = widget.kegiatan!.tanggal;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_tanggal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal terlebih dahulu')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        throw 'User tidak terautentikasi';
      }

      final kegiatan = Kegiatan(
        id: widget.kegiatan?.id, // null untuk create, ada ID untuk update
        nama: _namaController.text,
        deskripsi: _deskripsiController.text,
        lokasi: _lokasiController.text,
        tanggal: _tanggal!,
        userId: currentUser.uid,
        createdAt: widget.kegiatan?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.kegiatan == null) {
        // CREATE
        await _kegiatanService.createKegiatan(kegiatan);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kegiatan berhasil ditambahkan'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Return true untuk refresh list
        }
      } else {
        // UPDATE
        await _kegiatanService.updateKegiatan(kegiatan);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kegiatan berhasil diperbarui'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kegiatan == null 
          ? 'Tambah Kegiatan' 
          : 'Edit Kegiatan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Form fields...
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Kegiatan'),
              validator: (v) => v?.isEmpty ?? true 
                ? 'Nama wajib diisi' 
                : null,
            ),
            // ... fields lainnya
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _loading ? null : _submitForm,
              child: _loading
                ? const CircularProgressIndicator()
                : Text(widget.kegiatan == null 
                  ? 'Tambah' 
                  : 'Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }
}
```

---

### 5. Update Firestore Security Rules

**File:** Firebase Console → Firestore Database → Rules

Tambahkan rules untuk collection baru:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // ... existing rules (users, roles, etc) ...
    
    // Kegiatan collection
    match /kegiatan/{kegiatanId} {
      // User bisa create kegiatan sendiri
      allow create: if request.auth != null && 
        request.resource.data.userId == request.auth.uid;
      
      // User bisa read semua kegiatan
      allow read: if request.auth != null;
      
      // User hanya bisa update/delete kegiatan sendiri
      allow update, delete: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      
      // Admin bisa update/delete semua
      allow update, delete: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'Admin';
    }
    
    // Collection lain (pengeluaran, pemasukan, dll)
    match /pengeluaran/{pengeluaranId} {
      allow create: if request.auth != null && 
        request.resource.data.userId == request.auth.uid;
      allow read: if request.auth != null;
      allow update, delete: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // ... rules untuk collections lainnya ...
  }
}
```

**Atau untuk Development (lebih mudah):**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

---

## 📍 Lokasi File yang Perlu Dibuat/Edit

### Untuk Form Baru:

1. **Model** → `lib/models/[nama]_model.dart`
   - Struktur data
   - `toMap()` dan `fromMap()`
   - `copyWith()` untuk update

2. **Service** → `lib/services/[nama]_service.dart`
   - CRUD operations
   - Query methods
   - Stream untuk real-time

3. **Form Page** → `lib/pages/[lokasi]/[nama]_form_page.dart`
   - UI form
   - Validasi
   - Submit ke service

4. **List Page** → `lib/pages/[lokasi]/[nama]_page.dart`
   - Tampilkan list data
   - Stream untuk real-time updates

5. **Firestore Rules** → Firebase Console
   - Security rules untuk collection baru

---

## 🔄 Contoh Workflow Lengkap

### Contoh: Menambah Form "Pengeluaran"

1. **Buat Model:**
   ```bash
   lib/models/pengeluaran_model.dart
   ```

2. **Buat Service:**
   ```bash
   lib/services/pengeluaran_service.dart
   ```

3. **Buat Form Page:**
   ```bash
   lib/pages/keuangan/screens/pengeluaran_form_page.dart
   ```

4. **Update Init Service:**
   ```dart
   // lib/services/firestore_init_service.dart
   await _ensureCollectionExists('pengeluaran');
   ```

5. **Update Firestore Rules:**
   ```javascript
   // Di Firebase Console
   match /pengeluaran/{pengeluaranId} {
     allow create, read, update, delete: if request.auth != null;
   }
   ```

6. **Gunakan di Form:**
   ```dart
   final pengeluaranService = PengeluaranService();
   await pengeluaranService.createPengeluaran(pengeluaran);
   ```

---

## 📚 Template Service yang Bisa Dikopi

Lihat file berikut sebagai referensi:
- `lib/services/user_service.dart` - Contoh service lengkap
- `lib/models/user_profile_model.dart` - Contoh model lengkap
- `lib/pages/register_page.dart` - Contoh penggunaan service di form

---

## ⚠️ Tips Penting

1. **Collection Name:**
   - Gunakan lowercase dan underscore: `kegiatan`, `pengeluaran`, `pemasukan`
   - Jangan gunakan spasi atau karakter khusus

2. **Document ID:**
   - Firestore auto-generate ID dengan `.add()`
   - Atau set custom ID dengan `.doc(id).set()`

3. **Timestamps:**
   - Gunakan `FieldValue.serverTimestamp()` untuk waktu server
   - Atau `DateTime.now()` untuk waktu client

4. **Real-time Updates:**
   - Gunakan `.snapshots()` untuk real-time
   - StreamBuilder di UI untuk auto-update

5. **Error Handling:**
   - Selalu wrap dengan try-catch
   - Beri pesan error yang user-friendly

---

## 🎯 Quick Reference

**Create:**
```dart
await service.createItem(item);
```

**Read:**
```dart
final item = await service.getItemById(id);
final items = await service.getAllItems();
```

**Update:**
```dart
await service.updateItem(item);
```

**Delete:**
```dart
await service.deleteItem(id);
```

**Stream (Real-time):**
```dart
service.getItemsStream().listen((items) {
  // Update UI
});
```

---

**Panduan ini sudah mencakup semua yang perlu diketahui untuk menambah collection baru di Firestore!**

