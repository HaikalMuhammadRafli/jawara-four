import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
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
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: '276529435482',
    projectId: 'jawara4-eb4fe',
    storageBucket: 'jawara4-eb4fe.firebasestorage.app',
    iosBundleId: 'com.example.jawaraFour',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBNtnf40MKdUPGFJGr4j73lPg2ZaD_zmYY',
    appId: '1:276529435482:web:33c6e3390b269d9333d963',
    messagingSenderId: '276529435482',
    projectId: 'jawara4-eb4fe',
    authDomain: 'jawara4-eb4fe.firebaseapp.com',
    storageBucket: 'jawara4-eb4fe.firebasestorage.app',
  );
}
