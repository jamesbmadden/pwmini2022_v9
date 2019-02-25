import 'package:angular/angular.dart';
import 'package:pwmini2022_v9/app_component.template.dart' as ng;

import 'package:pwmini2022_v9/firebase/firebase.dart';
import 'package:pwmini2022_v9/firebase/firestore.dart';
import 'package:pwmini2022_v9/firebase/keys.dart';
import 'package:firebase/firebase.dart' as fb;

void main() async {
  fb.initializeApp(
    apiKey: apiKey,
    authDomain: authDomain,
    databaseURL: databaseURL,
    projectId: projectId,
    storageBucket: storageBucket,
    messagingSenderId: messagingSenderId
  );
  await loadFirestore();
  runApp(ng.AppComponentNgFactory);
}