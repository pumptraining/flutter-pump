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
// / await Firebase.initializeApp(
// /   options: DefaultFirebaseOptions.currentPlatform,
// / );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBd3-Zydw0GC_cxoCqtM6URk_k83BsFWDc',
    appId: '1:784151565290:web:089d493b6ba4173082d893',
    messagingSenderId: '784151565290',
    projectId: 'pump-681ff',
    authDomain: 'pump-681ff.firebaseapp.com',
    storageBucket: 'pump-681ff.appspot.com',
    measurementId: 'G-CK5W48VP4S',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlzerGM1Pzm5X-Jbfho_Tn4hB0qeJUSuI',
    appId: '1:784151565290:ios:696e46df7346e00082d893',
    messagingSenderId: '784151565290',
    projectId: 'pump-681ff',
    storageBucket: 'pump-681ff.appspot.com',
    androidClientId: '784151565290-33e6mu5outqh5bgu7hj73h3u2tokjq5h.apps.googleusercontent.com',
    iosClientId: '784151565290-cov2u3vseb8f6rk0aorqohh322alv0er.apps.googleusercontent.com',
    iosBundleId: 'br.com.pump.creator',
  );
}
