import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web platform is not configured.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS platform is not configured.');
      case TargetPlatform.windows:
        throw UnsupportedError('Windows platform is not configured.');
      case TargetPlatform.linux:
        throw UnsupportedError('Linux platform is not configured.');
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDpcFkdsnhssNiQz_SDAHrFsKAdFpC3pDI',
    appId: '1:129788816836:android:88063069ad0863715f0891',
    messagingSenderId: '129788816836',
    projectId: 'a-eye-8c9a7',
    storageBucket: 'a-eye-8c9a7.firebasestorage.app',
    databaseURL: 'https://a-eye-8c9a7-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDNlNFvQUs2DLjRZ_HL9YyAKQAVrcRnRoc',
    appId: '1:129788816836:ios:57f33b46548dbddc5f0891',
    messagingSenderId: '129788816836',
    projectId: 'a-eye-8c9a7',
    storageBucket: 'a-eye-8c9a7.firebasestorage.app',
    databaseURL: 'https://a-eye-8c9a7-default-rtdb.firebaseio.com',
    iosBundleId: 'ge.motoslot.app',
  );
}
