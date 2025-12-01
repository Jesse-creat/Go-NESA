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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBnEtBDApDK-Opa3tmo7WeSx4N9M1tjHTM',
    appId: '1:454619533562:web:8bbcbad786da35e8d2b943',
    messagingSenderId: '454619533562',
    projectId: 'go-nesa-4cac0',
    authDomain: 'go-nesa-4cac0.firebaseapp.com',
    storageBucket: 'go-nesa-4cac0.firebasestorage.app',
    measurementId: 'G-6SZ99ET6WD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBMoef0oRBl8u8RCqS6QWPIQxDQu9_Kgek',
    appId: '1:726784968587:android:422934486604126a07518e', // Assume same as web for now
    messagingSenderId: '726784968587',
    projectId: 'go-nesa',
    storageBucket: 'go-nesa.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBMoef0oRBl8u8RCqS6QWPIQxDQu9_Kgek',
    appId: '1:726784968587:ios:422934486604126a07518e', // Assume same as web for now
    messagingSenderId: '726784968587',
    projectId: 'go-nesa',
    storageBucket: 'go-nesa.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBMoef0oRBl8u8RCqS6QWPIQxDQu9_Kgek',
    appId: '1:726784968587:macos:422934486604126a07518e', // Assume same as web for now
    messagingSenderId: '726784968587',
    projectId: 'go-nesa',
    storageBucket: 'go-nesa.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBMoef0oRBl8u8RCqS6QWPIQxDQu9_Kgek',
    appId: '1:726784968587:windows:422934486604126a07518e', // Assume same as web for now
    messagingSenderId: '726784968587',
    projectId: 'go-nesa',
    storageBucket: 'go-nesa.firebasestorage.app',
  );
}
