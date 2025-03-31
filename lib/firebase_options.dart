// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCmhQlr17HxlbmYCYEA1fd-nmX9FJToyr4',
    appId: '1:592728998318:web:4de18fbebaa98e205a483f',
    messagingSenderId: '592728998318',
    projectId: 'phobia-apka',
    authDomain: 'phobia-apka.firebaseapp.com',
    storageBucket: 'phobia-apka.firebasestorage.app',
    measurementId: 'G-3MNPPPVHZH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUbcjTrqzlmDaAA7BRxnXcKqMqspUC1Ro',
    appId: '1:592728998318:android:fa376b9bd20c95c95a483f',
    messagingSenderId: '592728998318',
    projectId: 'phobia-apka',
    storageBucket: 'phobia-apka.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAewfodDtAbMPOXutUp1uQnrWigLyHFgA4',
    appId: '1:592728998318:ios:7b5affc8b9e4b0795a483f',
    messagingSenderId: '592728998318',
    projectId: 'phobia-apka',
    storageBucket: 'phobia-apka.firebasestorage.app',
    iosBundleId: 'com.example.phobiaApp',
  );
}
