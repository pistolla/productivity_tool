import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter/material.dart';
import 'package:remotesurveyadmin/api/firestore_service.dart';

class CustomFormManager extends JsonFormManager {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> sendDataToServer(String documentId) async {
    var properties = getFormProperties();
    debugPrint('Uploading server communication...');
    var jsonData = {};
    for (var property in properties) {
      jsonData[property.id] = property.value;
    }
    _firestoreService.updatePost(documentId, jsonData.toString());
  }
}
