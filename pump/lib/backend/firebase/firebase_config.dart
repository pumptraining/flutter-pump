import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBd3-Zydw0GC_cxoCqtM6URk_k83BsFWDc",
            authDomain: "pump-681ff.firebaseapp.com",
            projectId: "pump-681ff",
            storageBucket: "pump-681ff.appspot.com",
            messagingSenderId: "784151565290",
            appId: "1:784151565290:web:089d493b6ba4173082d893",
            measurementId: "G-CK5W48VP4S"));
  } else {
    await Firebase.initializeApp();
  }
}
