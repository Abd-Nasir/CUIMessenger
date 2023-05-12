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
    apiKey: 'AIzaSyDeJoAhsteHXdqF9LOtkFYZLAs9eRLPGXM',
    appId: '1:619353262412:web:7c8876abf98c5ba83527e9',
    messagingSenderId: '619353262412',
    projectId: 'yourteam-ec310',
    authDomain: 'yourteam-ec310.firebaseapp.com',
    storageBucket: 'yourteam-ec310.appspot.com',
    measurementId: 'G-RK1XTC1GBN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAqtlVUFpmXbVEEd_Hg2vGMbV1WYCgFa5Y',
    appId: '1:619353262412:android:2d2708c4f8a748c93527e9',
    messagingSenderId: '619353262412',
    projectId: 'yourteam-ec310',
    storageBucket: 'yourteam-ec310.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCHkEgPBkGLBB0IiIr3-QyvPjvRPY_ClqA',
    appId: '1:619353262412:ios:12a4971964f7fd473527e9',
    messagingSenderId: '619353262412',
    projectId: 'yourteam-ec310',
    storageBucket: 'yourteam-ec310.appspot.com',
    iosClientId: '619353262412-trn60e34a32fqfs2epprtofcd7bhq97s.apps.googleusercontent.com',
    iosBundleId: 'com.example.yourteam',
  );
}