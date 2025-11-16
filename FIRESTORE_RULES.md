# Firestore Security Rules - Quick Setup

## ⚠️ Error Permission Denied

Jika Anda mendapat error:
```
PERMISSION_DENIED: Missing or insufficient permissions
```

Berarti Firestore Security Rules belum dikonfigurasi dengan benar.

---

## 🚀 Quick Fix (Development Mode)

### Langkah 1: Buka Firebase Console

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project **jawara4-eb4fe**
3. Klik **"Firestore Database"** di sidebar kiri
4. Klik tab **"Rules"**

### Langkah 2: Copy-Paste Rules Berikut

**Untuk Development (Permisif - Hanya untuk Testing):**

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

---

## 🔒 Production Rules (Recommended)

**Untuk Production (Lebih Aman):**

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

---

## 🔄 Alternatif: Test Mode (30 hari)

Jika rules masih sulit, Anda bisa menggunakan **Test Mode** yang otomatis expire setelah 30 hari:

1. Di Firebase Console → Firestore Database
2. Klik tab **"Rules"**
3. Copy rules berikut (Test Mode):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(2025, 12, 31);
    }
  }
}
```

**⚠️ PENTING:** Ini hanya untuk testing! Ganti tanggal sesuai kebutuhan dan jangan gunakan di production.

---

## ✅ Verifikasi Setup

Setelah update rules:

1. **Refresh aplikasi** atau restart app
2. **Coba registrasi lagi**
3. Check di Firebase Console → Firestore Database
4. Collection `users` harus ada dengan data user baru

---

## 🐛 Troubleshooting

### Rules tidak tersimpan?

- Pastikan format JSON valid
- Pastikan klik **"Publish"** bukan hanya **"Validate"**
- Tunggu beberapa detik untuk rules ter-propagate

### Masih error setelah update rules?

- Restart aplikasi Flutter
- Clear app data (uninstall & reinstall)
- Check di Firebase Console bahwa rules sudah ter-publish

### Error saat test rules di Firebase Console?

- Gunakan simulator di tab Rules untuk test
- Pastikan user sudah login (request.auth != null)

---

## 📚 Referensi

- [Firestore Security Rules Documentation](https://firebase.google.com/docs/firestore/security/get-started)
- [Firestore Security Rules Reference](https://firebase.google.com/docs/reference/rules/rules)

