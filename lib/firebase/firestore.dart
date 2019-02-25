import 'dart:async';
import 'dart:html';
import 'dart:convert';

import 'firebase.dart';

import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;

fs.Firestore firestore = fb.firestore();

fs.CollectionReference classes;
fs.CollectionReference users;
fs.CollectionReference mini;
fs.DocumentReference me;
Map myClasses;
bool newUser;


Storage localStorage = window.localStorage;

Future<bool> loadFirestore() {
  return new Future<bool>(() async {
    await loadFirebase();
    classes = firestore.collection('classes');
    users = firestore.collection('users');
    mini = firestore.collection('mini');
    if (localStorage['myClasses'] != null) {
     myClasses = json.decode(localStorage['myClasses']); 
    }
    auth.onAuthStateChanged.listen((_user) {
      if (_user != null) {
        me = users.doc(_user.email);
        me.get().then((docSnap) {
          if (docSnap.exists && docSnap.data()["classes"] != null) {
            myClasses = docSnap.data()["classes"];
            localStorage['myClasses'] = json.encode(myClasses);
            newUser = false;
            print(myClasses);
          } else {
            myClasses = null;
            localStorage['myClasses'] = null;
            newUser = true;
            window.history.replaceState({'state':'select_class','component':'class-list'}, 'Select Classes', '/select_class');
          }
          return true;
        });
      }
    });
  });
}

class Block { // a class to make working with the new database structure easier
  fs.DocumentReference block;
  fs.DocumentSnapshot blockData = null; 
  Block(String _block) { // Sets variable block to a reference to the document with the block
    block = classes.doc(_block);
    _blockData();
  }
  _blockData() async {
    return new Future(() async {
      if (blockData == null) {
        blockData = await block.get();
        return blockData;
      } else {
        return blockData;
      }
    });
  }
  getClass(String _class) { // returns a future with the block data
    return new Future(() async {
      await _blockData();
      return blockData.data()[_class];
    });
  }
  createClass(String name) async { // creates a new class. If the class already exists, the data gets reset.
    if (name.contains('.')) {
      throw 'Class names cannot contain a period.';
    } else {
      await block.update(data:{
        name: {
          'events':[],
          'homework':[]
        }
      });
      return true;
    }
  }
  classList() {
    return new Future(() async {
      await _blockData();
      return blockData.data().keys;
    });
  }
  reloadData() async {
    return new Future(() async {
      blockData = null;
      await _blockData();
    });
  }
}