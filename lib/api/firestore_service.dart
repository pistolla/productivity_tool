import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:remotesurveyadmin/models/form_model.dart';
import 'package:remotesurveyadmin/models/notification_model.dart';
import 'package:remotesurveyadmin/models/user_model.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
  FirebaseFirestore.instance.collection('users');
  final CollectionReference _postsCollectionReference =
  FirebaseFirestore.instance.collection('survey_forms');
  final CollectionReference _noteCollectionReference =
  FirebaseFirestore.instance.collection('notifications');

  final StreamController<List<FormModel>> _postsController =
  StreamController<List<FormModel>>.broadcast();

  final StreamController<List<NotificationModel>> _notesController =
  StreamController<List<NotificationModel>>.broadcast();

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

  Stream<List<FormModel>> listenToPostsRealTime() {
    _postsCollectionReference.snapshots().listen((postsSnapshot) {
      var posts = postsSnapshot.docs
          .map((snapshot) => FormModel.fromSnapShot(snapshot))
          .toList();
      _postsController.add(posts);
    });

    return _postsController.stream;
  }

  Stream<List<NotificationModel>> listenToNotificationsRealTime() {
    _noteCollectionReference.snapshots().listen((postsSnapshot) {
      var posts = postsSnapshot.docs
          .map((snapshot) => NotificationModel.fromSnapShot(snapshot))
          .toList();
      _notesController.add(posts);
    });

    return _notesController.stream;
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

  Future getPost(String documentId) async {
    try {
      var data = await _postsCollectionReference.doc(documentId).get();
      return FormModel.fromSnapShot(data);
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future createNotification(NotificationModel notificationModel) async {
    try {
      String docId = _noteCollectionReference.doc().id;
      await _noteCollectionReference.doc(docId).set({
        "message": notificationModel.message,
        "reference": notificationModel.reference,
        "user_id": notificationModel.user_id,
        "date_created": notificationModel.date_created
      });
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }
}
