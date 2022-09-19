
import 'package:cloud_firestore/cloud_firestore.dart';

class FormModel {
  String documentId;
  String title;
  String description;
  String form;
  List data;
  Map rules;

  FormModel(
      {required this.documentId,
      required this.title,
      required this.description,
      required this.form,
      required this.data,
      required this.rules});

  factory FormModel.fromMap(Map<String, dynamic> data) {
    return FormModel(
        documentId: data["collectionId"],
        title: data["title"],
        description: data["description"],
        form: data["form"],
        data: data["data"],
        rules: data["rules"]);
  }

  factory FormModel.fromSnapShot(DocumentSnapshot data) {
    return FormModel(
        documentId: data.id,
        title: data["title"],
        description: data["description"],
        form: data["form"],
        data: data["data"],
        rules: data["rules"]);
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
