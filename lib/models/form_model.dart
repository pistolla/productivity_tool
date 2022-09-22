
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class FormModel {
  String documentId;
  String title;
  String description;
  List form;
  List data;
  Map rules;
  Timestamp published_on;

  FormModel(
      {required this.documentId,
      required this.title,
      required this.description,
      required this.form,
      required this.data,
      required this.rules,
        required this.published_on});

  factory FormModel.fromMap(Map<String, dynamic> data) {
    return FormModel(
        documentId: data["collectionId"],
        title: data["title"],
        description: data["description"],
        form: data["form"],
        data: data["data"],
        published_on: data["published_on"],
        rules: data["rules"]);
  }

  factory FormModel.dummy() {
    return FormModel(
        documentId: "",
        title: "",
        description: "",
        form: [],
        data: [],
        published_on: Timestamp(1, 1000),
        rules: {});
  }

  factory FormModel.fromSnapShot(DocumentSnapshot data) {
    return FormModel(
        documentId: data.id,
        title: data["title"],
        description: data["description"],
        form: data["form"],
        data: data["data"],
        published_on: data["published_on"],
        rules: data["rules"]);
  }

  List<String> getTabs() {
    List<String> values = [];
    for (var element in form) {
      var decoded = json.decode(element);
      if(decoded != null){
        values.add(decoded["id"]);
      }
    }
    return values;
  }

  Map<String, Object?> toMap() {
    return {
      "documentId": documentId,
      "title": title,
      "description": description,
      "form": form,
      "data": data,
      "rules": rules
    };
  }
}
