// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAbiBNjnElBfpNwosc7mSK3ll0uJFBFgtM',
    appId: '1:563588761219:web:288f99c1bddf42c52d7db6',
    messagingSenderId: '563588761219',
    projectId: 'bengkelkoding1488',
    authDomain: 'bengkelkoding1488.firebaseapp.com',
    storageBucket: 'bengkelkoding1488.appspot.com',
    measurementId: 'G-HMWJZMJDVE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC6ep9_xr22GnBFc7JQeyQ8dQC4R_OPAxs',
    appId: '1:563588761219:android:4b5931043887b92a2d7db6',
    messagingSenderId: '563588761219',
    projectId: 'bengkelkoding1488',
    storageBucket: 'bengkelkoding1488.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCvCHR6Ino6LMPcPWIrZwAaypuwghjs6MI',
    appId: '1:563588761219:ios:3e37002d3187c5642d7db6',
    messagingSenderId: '563588761219',
    projectId: 'bengkelkoding1488',
    storageBucket: 'bengkelkoding1488.appspot.com',
    iosBundleId: 'com.example.flutterTugasakhir',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCvCHR6Ino6LMPcPWIrZwAaypuwghjs6MI',
    appId: '1:563588761219:ios:d331d9352955a2ba2d7db6',
    messagingSenderId: '563588761219',
    projectId: 'bengkelkoding1488',
    storageBucket: 'bengkelkoding1488.appspot.com',
    iosBundleId: 'com.example.flutterTugasakhir.RunnerTests',
  );
}
