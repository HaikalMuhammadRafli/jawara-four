# Dokumentasi Setup Firebase dan Firestore

Panduan lengkap untuk setup Firebase Authentication dan Cloud Firestore untuk aplikasi Jawara Four.

## 📋 Daftar Isi

1. [Persiapan Firebase Console](#persiapan-firebase-console)
2. [Setup Firebase Authentication](#setup-firebase-authentication)
3. [Setup Cloud Firestore](#setup-cloud-firestore)
4. [Konfigurasi Android](#konfigurasi-android)
5. [Konfigurasi iOS](#konfigurasi-ios)
6. [Struktur Database Firestore](#struktur-database-firestore)
7. [Cara Menggunakan di Kode](#cara-menggunakan-di-kode)

---

## 1. Persiapan Firebase Console

### Langkah 1: Buat Project Firebase

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik **"Add project"** atau **"Create a project"**
3. Masukkan nama project: **jawara4-eb4fe** (atau sesuai keinginan)
4. Ikuti wizard setup project
5. Pilih apakah ingin enable Google Analytics (opsional)

### Langkah 2: Akses Project Settings

1. Setelah project dibuat, klik ikon **⚙️ Settings** di sidebar kiri
2. Pilih **"Project settings"**
3. Scroll ke bawah ke bagian **"Your apps"**

---

## 2. Setup Firebase Authentication

### Langkah 1: Enable Authentication

1. Di Firebase Console, klik **"Authentication"** di sidebar kiri
2. Klik **"Get started"** jika pertama kali
3. Pilih tab **"Sign-in method"**
4. Klik **"Email/Password"**
5. Enable toggle **"Email/Password"**
6. Klik **"Save"**

### Langkah 2: Tambahkan User Admin (Opsional)

1. Di halaman Authentication, klik tab **"Users"**
2. Klik **"Add user"**
3. Masukkan email dan password untuk admin
4. Klik **"Add user"**

**Catatan:** User yang dibuat di sini akan langsung bisa login tanpa perlu registrasi.

---

## 3. Setup Cloud Firestore

### Langkah 1: Buat Database Firestore

1. Di Firebase Console, klik **"Firestore Database"** di sidebar kiri
2. Klik **"Create database"**
3. Pilih mode:
   - **Production mode** (recommended untuk production)
   - **Test mode** (hanya untuk development, akan expired setelah 30 hari)
4. Pilih lokasi database (pilih yang terdekat, misalnya: **asia-southeast1** untuk Indonesia)
5. Klik **"Enable"**

### Langkah 2: Setup Security Rules

1. Di Firestore Database, klik tab **"Rules"**
2. Ganti rules dengan salah satu berikut:

#### ⚠️ IMPORTANT: Quick Fix untuk Development (Gunakan ini dulu!)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow all reads and writes if user is authenticated
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**Klik "Publish"** untuk menyimpan rules.

**Catatan:** 
- Rules di atas **HANYA untuk development/testing**
- Semua user yang login bisa read/write semua data
- Untuk production, gunakan rules yang lebih ketat (lihat di bawah)

#### 🔒 Production Rules (Lebih Aman)

Setelah testing selesai, ganti dengan rules berikut:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function untuk cek apakah user adalah admin
    function isAdmin() {
      return request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'Admin';
    }
    
    // Helper function untuk cek apakah user adalah owner dokumen
    function isOwner(userId) {
      return request.auth != null && request.auth.uid == userId;
    }
    
    // Users collection
    match /users/{userId} {
      // User bisa create profil sendiri saat registrasi
      allow create: if request.auth != null && request.auth.uid == userId;
      
      // User bisa read dan update data sendiri
      allow read, update: if isOwner(userId);
      
      // Admin bisa read semua user
      allow read: if isAdmin();
      
      // Admin bisa update semua user
      allow update: if isAdmin();
    }
    
    // Roles collection - read only untuk authenticated users
    match /roles/{roleId} {
      allow read: if request.auth != null;
      allow write: if isAdmin();
    }
    
    // Settings collection
    match /settings/{settingId} {
      allow read: if request.auth != null;
      allow write: if isAdmin();
    }
    
    // Logs collection
    match /logs/{logId} {
      // User bisa create log sendiri
      allow create: if request.auth != null && 
        request.resource.data.userId == request.auth.uid;
      
      // User bisa read log sendiri
      allow read: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      
      // Admin bisa read semua log
      allow read: if isAdmin();
    }
    
    // Default: deny all
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

3. Klik **"Publish"** untuk menyimpan rules

**⚠️ PENTING:** 
- Gunakan rules **development** dulu untuk testing
- Setelah semua fitur bekerja, ganti ke **production rules**
- Rules yang lebih permisif akan menyebabkan error jika user belum ada di database (untuk isAdmin() check)

---

## 4. Konfigurasi Android

### Langkah 1: Tambahkan Android App

1. Di Project Settings → **"Your apps"**, klik icon **Android** (🟢)
2. Masukkan package name: **com.example.jawara_four**
3. (Opsional) Masukkan App nickname dan Debug signing certificate
4. Klik **"Register app"**

### Langkah 2: Download google-services.json

1. Download file **google-services.json**
2. Copy file tersebut ke folder: **android/app/google-services.json**
3. Pastikan file sudah ada di lokasi tersebut

### Langkah 3: Konfigurasi Gradle

File sudah dikonfigurasi, pastikan:

**android/build.gradle.kts:**
```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0") // atau versi terbaru
    }
}
```

**android/app/build.gradle.kts:**
```kotlin
plugins {
    id("com.google.gms.google-services")
}
```

### Langkah 4: Verifikasi Setup

File `lib/firebase_options.dart` sudah dikonfigurasi untuk Android:
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyBNtnf40MKdUPGFJGr4j73lPg2ZaD_zmYY',
  appId: '1:276529435482:android:121953a2e36e05b433d963',
  messagingSenderId: '276529435482',
  projectId: 'jawara4-eb4fe',
  storageBucket: 'jawara4-eb4fe.firebasestorage.app',
);
```

---

## 5. Konfigurasi iOS

### Langkah 1: Tambahkan iOS App

1. Di Project Settings → **"Your apps"**, klik icon **iOS** (🍎)
2. Masukkan bundle ID: **com.example.jawaraFour**
3. (Opsional) Masukkan App nickname
4. Klik **"Register app"**

### Langkah 2: Download GoogleService-Info.plist

1. Download file **GoogleService-Info.plist**
2. Copy file tersebut ke folder: **ios/Runner/GoogleService-Info.plist**
3. Pastikan file sudah ada di lokasi tersebut

### Langkah 3: Update Firebase Options

1. Buka `lib/firebase_options.dart`
2. Update iOS configuration:

```dart
static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'YOUR_IOS_API_KEY',
  appId: 'YOUR_IOS_APP_ID', // Format: 1:276529435482:ios:xxxxx
  messagingSenderId: '276529435482',
  projectId: 'jawara4-eb4fe',
  storageBucket: 'jawara4-eb4fe.firebasestorage.app',
  iosBundleId: 'com.example.jawaraFour',
);
```

3. Uncomment di method `currentPlatform`:

```dart
case TargetPlatform.iOS:
  return ios; // Uncomment ini
```

### Langkah 4: Install Pods (jika diperlukan)

```bash
cd ios
pod install
cd ..
```

**Catatan:** Untuk sekarang, iOS configuration di-comment dulu di `firebase_options.dart` sampai siap dikonfigurasi.

---

## 6. Struktur Database Firestore

### Collection: `users`

Penyimpanan data pengguna yang terdaftar.

**Structure:**
```
users/
  {userId}/
    uid: string
    nama: string
    email: string
    nik: string
    noTelepon: string
    jenisKelamin: string
    createdAt: timestamp
    updatedAt: timestamp (optional)
    role: string (default: "Warga")
```

**Example Document:**
```json
{
  "uid": "abc123xyz",
  "nama": "John Doe",
  "email": "john@example.com",
  "nik": "1234567890123456",
  "noTelepon": "081234567890",
  "jenisKelamin": "Laki-laki",
  "createdAt": "2024-01-01T00:00:00.000Z",
  "updatedAt": null,
  "role": "Admin"
}
```

### Collection: `roles` (Opsional)

Daftar role yang tersedia.

**Structure:**
```
roles/
  {roleId}/
    name: string
    permissions: array
    createdAt: timestamp
```

### Collection: `settings` (Opsional)

Pengaturan aplikasi.

**Structure:**
```
settings/
  {settingId}/
    key: string
    value: any
    updatedAt: timestamp
```

### Collection: `logs` (Opsional)

Log aktivitas pengguna.

**Structure:**
```
logs/
  {logId}/
    userId: string
    action: string
    description: string
    timestamp: timestamp
```

---

## 7. Cara Menggunakan di Kode

### 7.1 Authentication

**Login:**
```dart
import 'package:jawara_four/services/auth_service.dart';

final authService = AuthService();

try {
  await authService.signInWithEmailAndPassword(
    email: 'user@example.com',
    password: 'password123',
  );
  // Redirect ke dashboard
} catch (e) {
  // Handle error
  print('Login error: $e');
}
```

**Register:**
```dart
final authService = AuthService();

try {
  final credential = await authService.registerWithEmailAndPassword(
    email: 'newuser@example.com',
    password: 'password123',
  );
  // User berhasil dibuat
} catch (e) {
  // Handle error
  print('Register error: $e');
}
```

**Logout:**
```dart
await authService.signOut();
```

**Get Current User:**
```dart
final currentUser = authService.currentUser;
if (currentUser != null) {
  print('User ID: ${currentUser.uid}');
  print('Email: ${currentUser.email}');
}
```

### 7.2 Firestore - Users Collection

**Create User Profile:**
```dart
import 'package:jawara_four/services/user_service.dart';
import 'package:jawara_four/models/user_profile_model.dart';

final userService = UserService();

final userProfile = UserProfile(
  uid: 'user123',
  nama: 'John Doe',
  email: 'john@example.com',
  nik: '1234567890123456',
  noTelepon: '081234567890',
  jenisKelamin: 'Laki-laki',
  createdAt: DateTime.now(),
  role: 'Admin',
);

await userService.createUserProfile(userProfile);
```

**Get User Profile:**
```dart
final userProfile = await userService.getUserProfile('user123');
if (userProfile != null) {
  print('Nama: ${userProfile.nama}');
  print('Role: ${userProfile.role}');
}
```

**Update User Profile:**
```dart
final updatedProfile = userProfile.copyWith(
  nama: 'John Updated',
  noTelepon: '081999999999',
);
await userService.updateUserProfile(updatedProfile);
```

**Stream User Profile (Real-time):**
```dart
userService.getUserProfileStream('user123').listen((profile) {
  if (profile != null) {
    print('Profile updated: ${profile.nama}');
  }
});
```

### 7.3 Firestore - Custom Collections

**Write Data:**
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

// Add document
await firestore.collection('logs').add({
  'userId': 'user123',
  'action': 'login',
  'description': 'User logged in',
  'timestamp': FieldValue.serverTimestamp(),
});

// Set document dengan ID tertentu
await firestore.collection('settings').doc('app_name').set({
  'key': 'app_name',
  'value': 'Jawara Four',
  'updatedAt': FieldValue.serverTimestamp(),
});
```

**Read Data:**
```dart
// Get single document
final doc = await firestore.collection('settings').doc('app_name').get();
if (doc.exists) {
  print('Value: ${doc.data()?['value']}');
}

// Get multiple documents
final snapshot = await firestore.collection('logs')
  .where('userId', isEqualTo: 'user123')
  .orderBy('timestamp', descending: true)
  .limit(10)
  .get();

for (var doc in snapshot.docs) {
  print('Action: ${doc.data()['action']}');
}
```

**Stream Data (Real-time):**
```dart
firestore.collection('logs')
  .where('userId', isEqualTo: 'user123')
  .snapshots()
  .listen((snapshot) {
    for (var change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.added) {
        print('New log: ${change.doc.data()['action']}');
      }
    }
  });
```

**Update Data:**
```dart
await firestore.collection('settings').doc('app_name').update({
  'value': 'New App Name',
  'updatedAt': FieldValue.serverTimestamp(),
});
```

**Delete Data:**
```dart
await firestore.collection('logs').doc('log123').delete();
```

---

## 8. Testing

### Test Authentication

1. Buka aplikasi
2. Pergi ke halaman Register
3. Isi form dan submit
4. Check di Firebase Console → Authentication → Users, user baru harus muncul
5. Login dengan email/password yang baru dibuat
6. Harus bisa login dan redirect ke dashboard

### Test Firestore

1. Setelah registrasi, check di Firebase Console → Firestore Database
2. Collection `users` harus ada
3. Document dengan ID = UID user harus ada
4. Data harus lengkap (nama, email, NIK, dll)

---

## 9. Troubleshooting

### Error: "Firebase not initialized"

**Solusi:**
- Pastikan `Firebase.initializeApp()` dipanggil di `main.dart`
- Pastikan `firebase_options.dart` sudah dikonfigurasi dengan benar

### Error: "Permission denied"

**Solusi:**
- Check Firestore Security Rules di Firebase Console
- Pastikan user sudah login (request.auth != null)
- Pastikan rules sesuai dengan yang dijelaskan di atas

### Error: "Network request failed"

**Solusi:**
- Check koneksi internet
- Pastikan Firebase project sudah aktif
- Pastikan lokasi Firestore database sudah dipilih

### Android: "google-services.json not found"

**Solusi:**
- Pastikan file ada di `android/app/google-services.json`
- Jalankan `flutter clean` dan `flutter pub get`
- Rebuild aplikasi

### iOS: "GoogleService-Info.plist not found"

**Solusi:**
- Pastikan file ada di `ios/Runner/GoogleService-Info.plist`
- Jalankan `cd ios && pod install && cd ..`
- Rebuild aplikasi

---

## 10. Next Steps

1. ✅ Setup Authentication dengan Email/Password
2. ✅ Setup Firestore Database
3. ✅ Implementasi Register & Login
4. ✅ Simpan data user ke Firestore
5. 🔄 Implementasi fitur lainnya (CRUD data)

---

## 📚 Referensi

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Cloud Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase Authentication Documentation](https://firebase.google.com/docs/auth)

---

## 📖 Dokumentasi Tambahan

### Menambah Collection Baru

Jika Anda perlu menambah collection baru untuk form/form lainnya, lihat dokumentasi lengkap:

- **Panduan Lengkap:** `docs/FIRESTORE_ADD_COLLECTION.md`
- **Quick Reference:** `docs/QUICK_REFERENCE.md`

**Quick Steps:**
1. Buat Model → `lib/models/[nama]_model.dart`
2. Buat Service → `lib/services/[nama]_service.dart`
3. Gunakan di Form → `lib/pages/[lokasi]/[nama]_form_page.dart`
4. Update Security Rules → Firebase Console
5. Update Init Service → `lib/services/firestore_init_service.dart`

---

**Terakhir diupdate:** 2024

