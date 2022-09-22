import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/api/firestore_service.dart';
import 'package:remotesurveyadmin/models/form_model.dart';
import 'package:remotesurveyadmin/models/notification_model.dart';
import 'package:remotesurveyadmin/storage/session.dart';

class CustomFormManager {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> sendDataToServer(
      String documentId, String title, String userId, properties) async {
    debugPrint('Uploading server communication...');
    var jsonData = {};
    for (var property in properties) {
      var data = {};
      data["label"] = property.property;
      data["value"] = property.value;

      jsonData[property.id] = data;
    }
    _firestoreService.updatePost(documentId, jsonData.toString()).then((value) {
      Session session = Session();
      session.getUserID().then((userId) {
        session.getUsername().then((value) {
          var message = "user has posted answer form $title ";
          var timestamp = Timestamp.fromDate(DateTime.now());
          var user_id = userId;
          var reference = documentId;

          _firestoreService.createNotification(NotificationModel(
              id: '',
              message: message,
              date_created: timestamp,
              reference: reference,
              user_id: user_id));
        });
      });
    });
  }

  Future<String> initialize(String documentId, int formNumber) async {
    String jsonForm = "";
    await _firestoreService.getPost(documentId).then((value) => {
          if (value is FormModel)
            {
              if (value.form.isNotEmpty)
                {jsonForm = value.form.elementAt(formNumber)}
            }
        });
    return jsonForm;
  }
}
