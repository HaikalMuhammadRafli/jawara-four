// File generated using flutterfire configure
// Untuk iOS, pastikan Anda sudah menambahkan app iOS di Firebase Console
// dan download GoogleService-Info.plist ke folder ios/Runner/

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        // TODO: Uncomment setelah iOS configuration selesai
        // return ios;
        throw UnsupportedError(
          'iOS configuration belum diatur. Silakan konfigurasi iOS terlebih dahulu.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNtnf40MKdUPGFJGr4j73lPg2ZaD_zmYY',
    appId: '1:276529435482:android:121953a2e36e05b433d963',
    messagingSenderId: '276529435482',
    projectId: 'jawara4-eb4fe',
    storageBucket: 'jawara4-eb4fe.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBNtnf40MKdUPGFJGr4j73lPg2ZaD_zmYY',
    appId: 'YOUR_IOS_APP_ID', // Ganti dengan iOS App ID dari Firebase Console (format: 1:276529435482:ios:xxxxx)
    messagingSenderId: '276529435482',
    projectId: 'jawara4-eb4fe',
    storageBucket: 'jawara4-eb4fe.firebasestorage.app',
    iosBundleId: 'com.example.jawaraFour',
  );
}

