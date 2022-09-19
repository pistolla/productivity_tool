import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:remotesurveyadmin/models/form_model.dart';
import 'package:remotesurveyadmin/models/user_model.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
  FirebaseFirestore.instance.collection('users');
  final CollectionReference _postsCollectionReference =
  FirebaseFirestore.instance.collection('survey_forms');

  final StreamController<List<FormModel>> _postsController =
  StreamController<List<FormModel>>.broadcast();

  Future createUser(UserModel user) async {
    try {
      await _usersCollectionReference.doc(user.id).set(user.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      return UserModel.fromSnapShot(userData);
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future addPost(FormModel post) async {
    try {
      await _postsCollectionReference.add(post.toMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getPostsOnceOff() async {
    try {
      var postDocumentSnapshot = _postsCollectionReference.doc().snapshots();
      if (await postDocumentSnapshot.isEmpty) {
        return postDocumentSnapshot
            .map((snapshot) => FormModel.fromSnapShot(snapshot))
            .toList();
      }
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Stream listenToPostsRealTime() {
    _postsCollectionReference.snapshots().listen((postsSnapshot) {
      var posts = postsSnapshot.docs
          .map((snapshot) => FormModel.fromSnapShot(snapshot))
          .toList();
      _postsController.add(posts);
    });

    return _postsController.stream;
  }

  Future deletePost(String documentId) async {
    await _postsCollectionReference.doc(documentId).delete();
  }

  Future updatePost(String documentId, String data) async {
    try {
      await _postsCollectionReference
          .doc(documentId)
          .update({"data": FieldValue.arrayUnion([data])});
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }
}
