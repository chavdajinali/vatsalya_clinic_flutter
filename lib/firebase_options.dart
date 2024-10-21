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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAbSHt6Qn7xECZbMsXjCwA-KP9VUs2LfwA',
    appId: '1:420736845468:web:43d5c6abeb7fa5d6420f59',
    messagingSenderId: '420736845468',
    projectId: 'vatsalyaclinic-7142e',
    authDomain: 'vatsalyaclinic-7142e.firebaseapp.com',
    storageBucket: 'vatsalyaclinic-7142e.appspot.com',
    measurementId: 'G-NK26CVCY74',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD59IIHOlWWqaEjO26Qj_THMA7ppUKi6r4',
    appId: '1:420736845468:android:b395abe7a79df553420f59',
    messagingSenderId: '420736845468',
    projectId: 'vatsalyaclinic-7142e',
    storageBucket: 'vatsalyaclinic-7142e.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAbSHt6Qn7xECZbMsXjCwA-KP9VUs2LfwA',
    appId: '1:420736845468:web:06fc636ad6ce5030420f59',
    messagingSenderId: '420736845468',
    projectId: 'vatsalyaclinic-7142e',
    authDomain: 'vatsalyaclinic-7142e.firebaseapp.com',
    storageBucket: 'vatsalyaclinic-7142e.appspot.com',
    measurementId: 'G-G66QQZ7E7X',
  );
}
