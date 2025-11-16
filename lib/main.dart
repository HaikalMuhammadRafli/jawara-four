import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'firebase_options.dart';
import 'routes/app_router.dart';
import 'services/firestore_init_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (kDebugMode) {
      print('Firebase initialized successfully');
    }
    
    final firestoreInit = FirestoreInitService();
    await firestoreInit.initializeCollections();
  } catch (e) {
    if (kDebugMode) {
      print('Firebase initialization error: $e');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title: 'Jawara Four',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
    );
  }
}

