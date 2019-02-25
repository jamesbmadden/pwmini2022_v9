import 'dart:async';

import 'package:firebase/firebase.dart' as fb;
import './keys.dart';

export 'firestore.dart';

fb.Auth auth = fb.auth();
bool loggedIn = false;
bool setup = true;
fb.User user;
fb.GoogleAuthProvider google = new fb.GoogleAuthProvider();
fb.Storage storage = fb.storage();
fb.StorageReference storageRef = storage.ref();
fb.StorageReference testImage = storage.ref('homework-test-image.jpg');

Future<bool> loadFirebase() {
  return new Future<bool>(() {
    if (setup) {
      return setup;
    } else {
      fb.initializeApp(
        apiKey: apiKey,
        authDomain: authDomain,
        databaseURL: databaseURL,
        projectId: projectId,
        storageBucket: storageBucket,
        messagingSenderId: messagingSenderId
      );
      return true;
    }
  });
}

Stream<bool> onLogout() async* {
  await loadFirebase();
  auth.onAuthStateChanged.listen((_user) {
    if (_user == null) {
      return true;
    }
  });
}

Stream<fb.User> onLogin() async* {
  await loadFirebase();
  auth.onAuthStateChanged.listen((_user) {
    user = _user;
    if (_user != null) {
      print(_user.email);
      return _user;
    }
  });
}

Future logout() {
  return new Future(() async {
    return await auth.signOut();
  });
}

Future<fb.UserCredential> login(String email, String password) {
  return auth.signInWithEmailAndPassword(email, password);
}